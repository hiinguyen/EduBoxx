import 'package:edubox_client/edubox_client.dart';

import 'backend_result.dart';
import 'session.dart';

/// Content: the student library, the teacher upload flow, and downloads.
abstract interface class ContentRepository {
  /// `content.teacherList`: the teacher's own content, newest first.
  Future<BackendResult<List<TeacherContentItem>>> teacherList();

  /// `content.detail`: one item's metadata for the student or owning teacher.
  Future<BackendResult<ContentDetail>> detail(int contentId);

  /// Creates, uploads (direct to object storage) and completes an e-book or
  /// video. The returned item is the ingest result (`ready` or `rejected`).
  Future<BackendResult<TeacherContentItem>> upload({
    required int classId,
    required ContentType type,
    required String title,
    required String subject,
    required int gradeLevel,
    required String fileName,
    required List<int> bytes,
  });

  /// `content.approve`: the owning teacher approves ready content.
  Future<BackendResult<TeacherContentItem>> approve(int contentId);

  /// A short-lived signed URL for an in-app reader or player.
  Future<BackendResult<SignedFileUrl>> fileUrl(int contentId);

  /// Downloads the file into the app's content cache; returns its local path.
  Future<BackendResult<String>> download(int contentId);

  /// True when a local copy exists.
  Future<bool> isDownloaded(int contentId);

  /// The local path of a downloaded file, or null.
  Future<String?> localPath(int contentId);
}

/// Exercises, assignments, submissions, progress, tests and the gradebook.
abstract interface class AssignmentRepository {
  Future<BackendResult<List<TeacherAssignmentItem>>> teacherAssignments();

  Future<BackendResult<TeacherAssignmentItem>> saveAssignment(
    AssignmentUpsert input,
  );

  Future<BackendResult<void>> deleteAssignment(int assignmentId);

  Future<BackendResult<List<TeacherExerciseSummary>>> teacherExercises();

  Future<BackendResult<TeacherExerciseDetail>> teacherExercise(int exerciseId);

  Future<BackendResult<TeacherExerciseDetail>> saveExercise(
    ExerciseUpsert input,
  );

  /// The student's assignments for their classes, with their own attempt
  /// state and any pending outbox overlay.
  Future<BackendResult<StudentAssignmentList>> studentAssignments();

  Future<BackendResult<StudentAssignmentDetail>> studentAssignment(
    int assignmentId,
  );

  Future<BackendResult<ProgressResult>> markLessonComplete(int contentId);

  /// Submits (or queues, when offline) the calling student's answers.
  Future<BackendResult<SubmissionResult>> submit({
    required int assignmentId,
    required List<SubmittedAnswer> answers,
  });

  /// The latest server submission for one assignment, or null.
  Future<BackendResult<SubmissionResult?>> submissionFor(int assignmentId);

  /// Starts a timed test online; requested connectivity is by design.
  Future<BackendResult<TestStartResult>> startTest(int assignmentId);

  /// The student's running test (server online, local store offline).
  Future<BackendResult<TestStartResult?>> activeTest();

  /// Saves answers to the local test attempt after every change.
  Future<void> saveTestAnswers(
    int assignmentId,
    List<SubmittedAnswer> answers,
  );

  Future<List<SubmittedAnswer>> loadTestAnswers(int assignmentId);

  /// Flushes queued progress and submission writes in order.
  Future<void> syncOutbox();

  /// The class gradebook (teacher).
  Future<BackendResult<ClassResults>> classResults(int classId);

  /// Re-runs grading for one submission (teacher).
  Future<BackendResult<SubmissionResult>> regrade(int submissionId);

  /// True when [assignmentId] has a pending submission in the outbox.
  Future<bool> hasPendingSubmission(int assignmentId);
}

/// The AI tutor's streaming screen and transcript reads.
abstract interface class TutorRepository {
  Future<BackendResult<TutorState>> state();

  Future<BackendResult<List<TutorChatSummary>>> chats();

  Future<BackendResult<TutorChatDetail>> chat(int chatId);

  /// Streams deltas/errors/done. Offline it throws a
  /// [BackendException] before any provider call.
  Stream<TutorEvent> ask({
    required String subject,
    required String message,
    int? chatId,
  });

  Future<BackendResult<List<TutorChatSummary>>> classChats(int studentId);

  Future<BackendResult<TutorChatDetail>> classChat(int chatId);
}

/// The parent's read-only view of the linked child.
abstract interface class ParentRepository {
  /// Phase 1 home data (the linked child's name).
  Future<BackendResult<ParentHomeData>> home();

  Future<BackendResult<ParentSummary>> summary();

  Future<BackendResult<List<TutorChatSummary>>> chats();

  Future<BackendResult<TutorChatDetail>> chat(int chatId);
}
