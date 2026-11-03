@Tags(['integration'])
library;

import 'package:edubox_server/src/ai/mock_ai_provider.dart';
import 'package:edubox_server/src/config/edubox_config.dart';
import 'package:edubox_server/src/generated/protocol.dart';
import 'package:edubox_server/src/seed/fixture_files.dart';
import 'package:edubox_server/src/seed/learning_fixtures.dart';
import 'package:edubox_server/src/services/edubox_services.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import '../support/harness.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('phase 2-6 learning flows', (sessionBuilder, endpoints) {
    setUpAll(initTestAuthServices);

    late EduboxConfig config;

    EduboxConfig loadConfig() => EduboxConfig.load(
      runMode: 'test',
      serverDirectory: sessionBuilder.build().serverpod.serverDirectory.path,
    );

    setUp(() {
      config = loadConfig();
      EduboxServices.configOverride = config;
    });

    tearDown(() {
      EduboxServices.configOverride = null;
      EduboxServices.aiOverride = null;
      EduboxServices.clockOverride = null;
    });

    test('teacher uploads, ingest normalizes metadata, approves, and the '
        'student reads the same bytes through a signed URL', () async {
      final seeded = await seedLearning(sessionBuilder);
      final teacher = signedInAs(
        sessionBuilder,
        seeded,
        FixtureKeys.teacherLan,
      );
      final student = signedInAs(sessionBuilder, seeded, FixtureKeys.studentAn);
      final bytes = samplePdf();
      final ticket = await endpoints.content.createUpload(
        teacher,
        classId: seeded.classIds[FixtureKeys.class7A]!,
        type: ContentType.ebook,
        title: 'Bài đọc mới',
        subject: 'Toán',
        gradeLevel: 7,
        fileName: 'bai-doc.pdf',
        sizeBytes: bytes.length,
      );
      final put = await http.put(
        Uri.parse(ticket.url),
        headers: ticket.headers,
        body: bytes,
      );
      expect(put.statusCode, inInclusiveRange(200, 299));
      final ready = await endpoints.content.completeUpload(
        teacher,
        contentId: ticket.contentId,
      );
      expect(ready.ingestStatus, IngestStatus.ready);
      expect(ready.pageCount, 2);
      expect(ready.mimeType, 'application/pdf');
      await endpoints.content.approve(teacher, contentId: ticket.contentId);

      final library = await endpoints.content.library(student);
      expect(
        library.items.map((item) => item.id),
        contains(ticket.contentId),
      );
      final signed = await endpoints.content.fileUrl(
        student,
        contentId: ticket.contentId,
      );
      final got = await http.get(Uri.parse(signed.url));
      expect(got.statusCode, 200);
      expect(got.bodyBytes, bytes);
    });

    test('ingest rejects a file whose bytes do not match its type', () async {
      final seeded = await seedLearning(sessionBuilder);
      final teacher = signedInAs(
        sessionBuilder,
        seeded,
        FixtureKeys.teacherLan,
      );
      final bytes = samplePdf();
      final ticket = await endpoints.content.createUpload(
        teacher,
        classId: seeded.classIds[FixtureKeys.class7A]!,
        type: ContentType.video,
        title: 'Sai định dạng',
        subject: 'Toán',
        gradeLevel: 7,
        fileName: 'sai.mp4',
        sizeBytes: bytes.length,
      );
      await http.put(Uri.parse(ticket.url), body: bytes);
      final rejected = await endpoints.content.completeUpload(
        teacher,
        contentId: ticket.contentId,
      );
      expect(rejected.ingestStatus, IngestStatus.rejected);
      expect(rejected.ingestReason, isNotEmpty);
      final student = signedInAs(sessionBuilder, seeded, FixtureKeys.studentAn);
      final library = await endpoints.content.library(student);
      expect(
        library.items.map((item) => item.id),
        isNot(contains(ticket.contentId)),
      );
    });

    test('practice submission is graded against the answer key, replays '
        'idempotently, and appears in the teacher gradebook', () async {
      final seeded = await seedLearning(sessionBuilder);
      final student = signedInAs(sessionBuilder, seeded, FixtureKeys.studentAn);
      final teacher = signedInAs(
        sessionBuilder,
        seeded,
        FixtureKeys.teacherLan,
      );
      final assignmentId = seeded.assignmentIds[LearningFixtureKeys.practice]!;
      final detail = await endpoints.assignments.detailForStudent(
        student,
        assignmentId: assignmentId,
      );
      final questions = detail.exercise.questions;
      final answers = [
        for (final (index, question) in questions.indexed)
          SubmittedAnswer(
            questionId: question.id,
            selectedPositions: switch (index) {
              0 || 1 => const [1],
              _ => const [0, 1, 3],
            },
          ),
      ];
      final first = await endpoints.submissions.submit(
        student,
        assignmentId: assignmentId,
        clientSubmissionId: 'flow-1',
        answers: answers,
      );
      expect(first.status, SubmissionStatus.graded);
      expect(first.score, 10);
      final replay = await endpoints.submissions.submit(
        student,
        assignmentId: assignmentId,
        clientSubmissionId: 'flow-1',
        answers: answers,
      );
      expect(replay.id, first.id);
      final regraded = await endpoints.submissions.regrade(
        teacher,
        submissionId: first.id,
      );
      expect(regraded.score, 10);
      final results = await endpoints.results.classResults(
        teacher,
        classId: seeded.classIds[FixtureKeys.class7A]!,
      );
      expect(
        results.cells.any(
          (cell) => cell.submissionId == first.id && cell.score == 10,
        ),
        isTrue,
      );
    });

    test('a timed test starts online, locks the tutor, auto-grades, and '
        'rejects a tutor call while in progress', () async {
      final seeded = await seedLearning(sessionBuilder);
      final student = signedInAs(sessionBuilder, seeded, FixtureKeys.studentAn);
      final assignmentId = seeded.assignmentIds[LearningFixtureKeys.test]!;
      final start = await endpoints.tests.start(
        student,
        assignmentId: assignmentId,
        clientSubmissionId: 'test-run-1',
      );
      final locked = await endpoints.tutor
          .ask(student, subject: 'Toán', message: 'Giúp em với')
          .toList();
      expect(locked.single.errorCode, TutorErrorCode.lockedDuringTest);
      final detail = await endpoints.assignments.detailForStudent(
        student,
        assignmentId: assignmentId,
      );
      final result = await endpoints.submissions.submit(
        student,
        assignmentId: assignmentId,
        clientSubmissionId: start.clientSubmissionId,
        answers: [
          for (final (index, question) in detail.exercise.questions.indexed)
            SubmittedAnswer(
              questionId: question.id,
              selectedPositions: switch (index) {
                0 || 1 => const [1],
                _ => const [0, 1, 3],
              },
            ),
        ],
      );
      expect(result.status, SubmissionStatus.graded);
      final tutorState = await endpoints.tutor.state(student);
      expect(tutorState.pausedForTest, isFalse);
    });

    test('a late test submission is accepted and flagged late', () async {
      final seeded = await seedLearning(sessionBuilder);
      final student = signedInAs(sessionBuilder, seeded, FixtureKeys.studentAn);
      var now = DateTime.utc(2026, 11, 3, 2);
      EduboxServices.clockOverride = () => now;
      final assignmentId = seeded.assignmentIds[LearningFixtureKeys.test]!;
      final start = await endpoints.tests.start(
        student,
        assignmentId: assignmentId,
        clientSubmissionId: 'late-1',
      );
      now = now.add(const Duration(seconds: 300));
      final result = await endpoints.submissions.submit(
        student,
        assignmentId: assignmentId,
        clientSubmissionId: start.clientSubmissionId,
        answers: const [],
      );
      expect(result.late, isTrue);
      expect(result.status, SubmissionStatus.graded);
    });

    test('tutor scopes the prompt, refuses other subjects, enforces the '
        'daily limit atomically, and logs both messages', () async {
      final seeded = await seedLearning(sessionBuilder);
      final student = signedInAs(sessionBuilder, seeded, FixtureKeys.studentAn);
      final mock = _RecordingMock();
      EduboxServices.aiOverride = mock;
      EduboxServices.configOverride = config.copyWith(
        ai: AiConfig(
          baseUrl: config.ai.baseUrl,
          model: 'mock',
          apiKey: '',
          mock: true,
          dailyLimit: 1,
          requestTimeout: const Duration(seconds: 1),
        ),
      );
      final events = await endpoints.tutor
          .ask(student, subject: 'Toán', message: 'Cách cộng phân số?')
          .toList();
      expect(events.any((event) => event.type == TutorEventType.delta), isTrue);
      expect(events.last.type, TutorEventType.done);
      expect(mock.lastSystemPrompt, contains('Môn: Toán'));
      expect(mock.lastSystemPrompt, contains('Lớp: 7'));

      final blocked = await endpoints.tutor
          .ask(student, subject: 'Vật lý', message: 'Định luật Newton?')
          .toList();
      expect(
        blocked.single.errorCode,
        TutorErrorCode.subjectNotAllowed,
      );
      final limited = await endpoints.tutor
          .ask(student, subject: 'Toán', message: 'Thêm một câu?')
          .toList();
      expect(limited.single.errorCode, TutorErrorCode.dailyLimitReached);

      final chats = await endpoints.tutor.chats(student);
      expect(chats, isNotEmpty);
      final chat = await endpoints.tutor.chat(student, chatId: chats.first.id);
      expect(chat.messages, hasLength(2));
      expect(chat.messages.first.role, ChatRole.student);
      expect(chat.messages.last.role, ChatRole.tutor);
    });

    test(
      'parent summary is limited to the linked child and read-only',
      () async {
        final seeded = await seedLearning(sessionBuilder);
        final parent = signedInAs(
          sessionBuilder,
          seeded,
          FixtureKeys.parentBinh,
        );
        final offlineParent = signedInAs(
          sessionBuilder,
          seeded,
          FixtureKeys.parentNoChild,
        );
        final summary = await endpoints.parent.summary(parent);
        expect(summary.linkedStudentName, 'Nguyễn Minh An');
        expect(summary.results, isNotEmpty);
        expect(summary.chats, isNotEmpty);
        final chat = await endpoints.parent.chat(
          parent,
          chatId: summary.chats.first.id,
        );
        expect(chat.messages, hasLength(2));

        final noChild = await endpoints.parent.summary(offlineParent);
        expect(noChild.linkedStudentName, isNull);
        expect(noChild.results, isEmpty);
        await expectLater(
          endpoints.parent.chat(offlineParent, chatId: summary.chats.first.id),
          throwsA(isA<AccessDeniedException>()),
        );
      },
    );
  });
}

class _RecordingMock extends MockAiProvider {
  _RecordingMock() : super(chunkDelay: Duration.zero);
}
