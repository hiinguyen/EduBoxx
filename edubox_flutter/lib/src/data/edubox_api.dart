import 'package:edubox_client/edubox_client.dart';

/// The raw server calls the data layer needs, one method per endpoint.
///
/// Every method throws the server/transport exception unchanged; the caller
/// maps it with `mapApiError`. Production is `ClientEduBoxApi` (the generated
/// Serverpod client); unit tests use a fixture-backed fake.
abstract interface class EduBoxApi {
  /// `emailIdp.login`, then stores the returned session in the auth module's
  /// session manager.
  Future<void> login({required String email, required String password});

  /// Restores the stored auth session from local secure storage without a
  /// server call. Returns true when a session is stored.
  Future<bool> restoreStoredAuth();

  Future<ProfileResult> profileMe();

  Future<List<ClassSummary>> classesMine();

  Future<StudentLibrary> contentLibrary();

  Future<ContentDetail> contentDetail(int contentId);

  Future<List<TeacherContentItem>> contentTeacherList();

  Future<UploadTicket> contentCreateUpload({
    required int classId,
    required ContentType type,
    required String title,
    required String subject,
    required int gradeLevel,
    required String fileName,
    required int sizeBytes,
  });

  Future<TeacherContentItem> contentCompleteUpload(int contentId);

  Future<TeacherContentItem> contentApprove(int contentId);

  Future<SignedFileUrl> contentFileUrl(int contentId);

  Future<TeacherExerciseDetail> exerciseSave(ExerciseUpsert input);

  Future<TeacherExerciseDetail> exerciseDetail(int exerciseId);

  Future<List<TeacherExerciseSummary>> exercisesMine();

  Future<TeacherAssignmentItem> assignmentSave(AssignmentUpsert input);

  Future<void> assignmentDelete(int assignmentId);

  Future<List<TeacherAssignmentItem>> assignmentsMine();

  Future<StudentAssignmentList> studentAssignments();

  Future<StudentAssignmentDetail> studentAssignmentDetail(int assignmentId);

  Future<ProgressResult> progressMarkComplete(int contentId);

  Future<List<ProgressResult>> progressMine();

  Future<ClassResults> classResults(int classId);

  Future<SubmissionResult> submissionRegrade(int submissionId);

  Future<SubmissionResult> submissionSubmit({
    required int assignmentId,
    required String clientSubmissionId,
    required List<SubmittedAnswer> answers,
  });

  Future<SubmissionResult?> submissionForAssignment(int assignmentId);

  Future<TestStartResult> testStart({
    required int assignmentId,
    required String clientSubmissionId,
  });

  Future<TestStartResult?> testActive();

  Future<TutorState> tutorState();

  Future<List<TutorChatSummary>> tutorChats();

  Future<TutorChatDetail> tutorChat(int chatId);

  Stream<TutorEvent> tutorAsk({
    required String subject,
    required String message,
    int? chatId,
  });

  Future<List<TutorChatSummary>> tutorClassChats(int studentId);

  Future<TutorChatDetail> tutorClassChat(int chatId);

  Future<ParentSummary> parentSummary();

  Future<List<TutorChatSummary>> parentChats();

  Future<TutorChatDetail> parentChat(int chatId);

  Stream<PingMessage> pingStream();

  Future<void> signOut();

  Future<void> clearStoredAuth();

  Future<void> close();
}
