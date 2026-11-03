# Phases 2-6 implementation record

Branch: `phase-2-6` (stacked on `phase-1`; phases 2-6 were built together).
Date: 2026-11-03.

## Delivered

### Phase 2 - content publish and study

- Server: `content.createUpload`, `content.completeUpload`, `content.approve`,
  `content.detail`, `content.teacherList`, `content.fileUrl`.
- Direct presigned PUT into the private MinIO bucket; ingest validates the
  bytes, size and type, then normalizes MIME, byte size, PDF page count and
  MP4 duration. Rejected files carry a reason and are never shown to students.
- Student detail, PDF reader (`pdfrx`) and video player (`video_player`), with
  a local file cache in the app support directory. Downloaded files open
  offline; not-downloaded items show `contentNeedsInternet`.
- Seed uploads a valid two-page PDF and a 2.2 s playable MP4 for every seeded
  e-book/video.

Decision: EPUB is rejected with a clear reason in this build. The roadmap's
own risk note allows shipping PDF-only until the EPUB reader is mature; a
rejected upload is better than a file the student cannot open.

### Phase 3 - practice loop

- Tables: `exercises`, `exercise_questions`, `exercise_options`,
  `exercise_answer_keys` (server-only), `assignments`, `submissions`,
  `progress`.
- Teacher exercise editor, assignment editor, class gradebook (`Sổ điểm`).
- Student assignment list/detail, linked lesson + mark complete, exercise
  runner, auto-graded result.
- Auto-grading is objective-only on the Vietnamese 10-point scale.
- Idempotency: `clientSubmissionId` is unique; replaying it returns the stored
  result. Progress is idempotent on `(studentId, contentId)`.
- The answer key snapshot is taken when a test starts and when a practice
  submission arrives; `regrade` explicitly re-reads the current key.
- Offline writes use the drift outbox (`progress.markComplete`,
  `submission.submit`); the sync worker replays them in order on reconnect.

### Phase 4 - AI tutor

- `tutor.state`, `tutor.chats`, `tutor.chat`, streaming `tutor.ask`,
  `tutor.classChats`, `tutor.classChat`.
- Subject allowlist comes from the student's classes and `subjects[]`; the
  system prompt names the subject and grade level.
- Daily limit is an atomic PostgreSQL conditional upsert keyed by
  `(studentId, yyyy-MM-dd in Asia/Ho_Chi_Minh)`; default 30. Failed provider
  attempts still consume a message, and are logged.
- The provider is OpenAI-compatible. The local stack uses the developer's
  `OPENCODE_API_KEY` from the root `.env` through
  `EDUBOX_AI_API_KEY`; with no key, or in tests, a deterministic mock streams
  the same event path. In all tests the model is mocked.
- `ai_chats` and `ai_messages` are written only by the server. Every
  completed exchange stores both messages; a partial stream is stored if any
  text arrived and the UI shows a retry.

### Phase 5 - timed tests

- `tests.start` creates the server-owned `in_progress` submission with
  `startedAt` and an answer-key snapshot; it requires connectivity and is
  never queued.
- The room timer is derived from the server deadline, survives an in-process
  restart through `TestAttempts` in drift, saves answers on every change, and
  auto-submits on expiry.
- Submissions after `startedAt + timeLimit + grace` are accepted and flagged
  `late`; grace is server config (`EDUBOX_LATE_GRACE_SECONDS`, default 60).
- `tutor.ask` is locked while any in-progress test exists. The client shows
  `aiTutorPausedDuringTest`.
- Test answers are never queued as a separate operation: the final submission
  uses the normal outbox idempotency key.

### Phase 6 - parent and teacher review

- `parent.summary`, `parent.chats`, `parent.chat` are read-only and scoped to
  the caller's `linkedStudentId`.
- Parent summary shows assignment/test results with title, score and status,
  plus the AI transcript list. Tapping the parent home record card opens it;
  no visual change was made to the phase 1 card, so its golden stays valid.
- Teacher `Trò chuyện AI` lists students from their own classes and opens
  read-only transcripts.

## Configuration

- Non-secret settings: `edubox_server/config/development.yaml` and `test.yaml`
  (`edubox.ai.*`, `edubox.learning.*`).
- AI key: root `.env` `OPENCODE_API_KEY`; compose passes it to the server as
  `EDUBOX_AI_API_KEY`. The key is never in the app or the committed config.
- Default provider/model: `https://opencode.ai/inference/go/openai/v1`,
  `deepseek-v4.1-flash`. Any OpenAI-compatible base URL/model can be set with
  `EDUBOX_AI_BASE_URL` / `EDUBOX_AI_MODEL`.

## Proof run (browser, not emulator)

The user's test environment is the browser. The Android emulator is not used.

```sh
tool/bootstrap.sh
docker compose up -d --wait postgres minio postgres_test
docker compose run --rm minio-init
docker compose --profile e2e up -d --build --wait
docker compose run --build --rm seed   # --build matters after code changes
(cd edubox_server && dart analyze --fatal-infos && dart test)
(cd edubox_flutter && flutter analyze && flutter test)
(cd edubox_flutter && flutter build web)
python3 -m http.server 5173 -d edubox_flutter/build/web
```

Open `http://localhost:5173`. On web the app defaults to
`http://localhost:8080`; compose passes `OPENCODE_API_KEY` from the root
`.env` to the server as `EDUBOX_AI_API_KEY`, and MinIO issues signed URLs for
`http://localhost:9000` (override `EDUBOX_STORAGE_PUBLIC_ENDPOINT` for an
Android host alias). MinIO's default CORS handling covers the browser's
range GETs and presigned PUTs.

Browser smoke evidence collected on 2026-11-03:

- student sign-in -> library -> e-book opens with `Trang 1 / 2`; video plays
  and reports `0:02 / 0:02`;
- student opens the practice assignment, answers, submits, and sees `10/10`;
- tutor streams a real `deepseek-v4.1-flash` answer through the OpenCode Go
  OpenAI-compatible endpoint (no key or test mode uses the mock);
- teacher sees the content table, assignment table, gradebook (`3,3` and
  `10` cells), and AI chat review with the student's transcripts;
- parent sees results and read-only AI transcripts on `Sổ liên lạc`.

`test/integration/learning/learning_flow_test.dart` covers: upload + ingest +
approve + signed file read, byte-type rejection, grading + idempotent replay +
regrade + gradebook, online test start + tutor lockout + grading, late flag,
tutor prompt/scope/daily limit/logging, and parent read-only scoping.

## Known limits / follow-ups

- Browser E2E was run manually with Playwright against the built web app and
  the compose stack; there is no committed browser-E2E CI job yet. The new
  screens are covered by a widget smoke test and the existing phase 1 goldens
  were updated for the added nav destinations.
- Upload progress is indeterminate; the file picker and direct PUT path are
  wired, but the UI does not report byte-level upload percentage.
- The outbox records permanent failures, but the assignment UI only overlays
  pending entries, not a named failed state with manual retry.
- EPUB is rejected rather than read.
