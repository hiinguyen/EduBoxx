import 'package:edubox_client/edubox_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart'
    show
        AuthSuccess,
        ClientAuthSuccessStorage,
        FlutterAuthSessionManager,
        FlutterAuthSessionManagerExtension,
        SecureClientAuthSuccessStorage;
import 'package:serverpod_flutter/serverpod_flutter.dart'
    show FlutterConnectivityMonitor;

import '../contract/backend_config.dart';
import '../network/platform_sources.dart' show serverRootUrl;
import 'edubox_api.dart';

/// [EduBoxApi] over the generated Serverpod client and the auth module's
/// Flutter session manager (secure storage). Used by `main.dart` and the
/// on-device integration tests; host unit tests use a fake instead because
/// `flutter test` has no secure-storage plugin.
class ClientEduBoxApi implements EduBoxApi {
  ClientEduBoxApi._(this.client, this.sessionManager);

  /// The sign-in brief's 15 s submit timeout maps to the client timeout.
  static const connectionTimeout = Duration(seconds: 15);

  factory ClientEduBoxApi.create(BackendConfig config) {
    final client = Client(
      '${serverRootUrl(config)}/',
      connectionTimeout: connectionTimeout,
    )..connectivityMonitor = FlutterConnectivityMonitor();
    final sessionManager = FlutterAuthSessionManager(
      storage: _FallbackAuthStorage(SecureClientAuthSuccessStorage()),
    );
    client.authSessionManager = sessionManager;
    return ClientEduBoxApi._(client, sessionManager);
  }

  final Client client;
  final FlutterAuthSessionManager sessionManager;

  @override
  Future<void> login({required String email, required String password}) async {
    final success = await client.emailIdp.login(
      email: email,
      password: password,
    );
    await sessionManager.updateSignedInUser(success);
  }

  @override
  Future<bool> restoreStoredAuth() async {
    await sessionManager.restore();
    return sessionManager.isAuthenticated;
  }

  @override
  Future<ProfileResult> profileMe() => client.profile.me();

  @override
  Future<List<ClassSummary>> classesMine() => client.classes.mine();

  @override
  Future<StudentLibrary> contentLibrary() => client.content.library();

  @override
  Stream<PingMessage> pingStream() => client.diagnostics.pingStream();

  @override
  Future<ContentDetail> contentDetail(int contentId) =>
      client.content.detail(contentId: contentId);

  @override
  Future<List<TeacherContentItem>> contentTeacherList() =>
      client.content.teacherList();

  @override
  Future<UploadTicket> contentCreateUpload({
    required int classId,
    required ContentType type,
    required String title,
    required String subject,
    required int gradeLevel,
    required String fileName,
    required int sizeBytes,
  }) => client.content.createUpload(
    classId: classId,
    type: type,
    title: title,
    subject: subject,
    gradeLevel: gradeLevel,
    fileName: fileName,
    sizeBytes: sizeBytes,
  );

  @override
  Future<TeacherContentItem> contentCompleteUpload(int contentId) =>
      client.content.completeUpload(contentId: contentId);

  @override
  Future<TeacherContentItem> contentApprove(int contentId) =>
      client.content.approve(contentId: contentId);

  @override
  Future<SignedFileUrl> contentFileUrl(int contentId) =>
      client.content.fileUrl(contentId: contentId);

  @override
  Future<TeacherExerciseDetail> exerciseSave(ExerciseUpsert input) =>
      client.exercises.save(input);

  @override
  Future<TeacherExerciseDetail> exerciseDetail(int exerciseId) =>
      client.exercises.detail(exerciseId: exerciseId);

  @override
  Future<List<TeacherExerciseSummary>> exercisesMine() =>
      client.exercises.mine();

  @override
  Future<TeacherAssignmentItem> assignmentSave(AssignmentUpsert input) =>
      client.assignments.save(input);

  @override
  Future<void> assignmentDelete(int assignmentId) =>
      client.assignments.delete(assignmentId: assignmentId);

  @override
  Future<List<TeacherAssignmentItem>> assignmentsMine() =>
      client.assignments.mine();

  @override
  Future<StudentAssignmentList> studentAssignments() =>
      client.assignments.listForStudent();

  @override
  Future<StudentAssignmentDetail> studentAssignmentDetail(int assignmentId) =>
      client.assignments.detailForStudent(assignmentId: assignmentId);

  @override
  Future<ProgressResult> progressMarkComplete(int contentId) =>
      client.progress.markComplete(contentId: contentId);

  @override
  Future<List<ProgressResult>> progressMine() => client.progress.mine();

  @override
  Future<ClassResults> classResults(int classId) =>
      client.results.classResults(classId: classId);

  @override
  Future<SubmissionResult> submissionRegrade(int submissionId) =>
      client.submissions.regrade(submissionId: submissionId);

  @override
  Future<SubmissionResult> submissionSubmit({
    required int assignmentId,
    required String clientSubmissionId,
    required List<SubmittedAnswer> answers,
  }) => client.submissions.submit(
    assignmentId: assignmentId,
    clientSubmissionId: clientSubmissionId,
    answers: answers,
  );

  @override
  Future<SubmissionResult?> submissionForAssignment(int assignmentId) =>
      client.submissions.forAssignment(assignmentId: assignmentId);

  @override
  Future<TestStartResult> testStart({
    required int assignmentId,
    required String clientSubmissionId,
  }) => client.tests.start(
    assignmentId: assignmentId,
    clientSubmissionId: clientSubmissionId,
  );

  @override
  Future<TestStartResult?> testActive() => client.tests.active();

  @override
  Future<TutorState> tutorState() => client.tutor.state();

  @override
  Future<List<TutorChatSummary>> tutorChats() => client.tutor.chats();

  @override
  Future<TutorChatDetail> tutorChat(int chatId) =>
      client.tutor.chat(chatId: chatId);

  @override
  Stream<TutorEvent> tutorAsk({
    required String subject,
    required String message,
    int? chatId,
  }) => client.tutor.ask(subject: subject, message: message, chatId: chatId);

  @override
  Future<List<TutorChatSummary>> tutorClassChats(int studentId) =>
      client.tutor.classChats(studentId: studentId);

  @override
  Future<TutorChatDetail> tutorClassChat(int chatId) =>
      client.tutor.classChat(chatId: chatId);

  @override
  Future<ParentSummary> parentSummary() => client.parent.summary();

  @override
  Future<List<TutorChatSummary>> parentChats() => client.parent.chats();

  @override
  Future<TutorChatDetail> parentChat(int chatId) =>
      client.parent.chat(chatId: chatId);

  @override
  Future<void> signOut() async {
    // signOutDevice clears the stored session in a finally block, so the
    // device is signed out locally even when the server call fails.
    await sessionManager.signOutDevice();
  }

  @override
  Future<void> clearStoredAuth() => sessionManager.updateSignedInUser(null);

  @override
  Future<void> close() async => client.close();
}

/// Keeps the session usable when a browser blocks WebCrypto/local storage.
///
/// Secure storage is still the first choice so a normal browser keeps the
/// session across reloads. If the browser refuses the write, the auth info is
/// retained for the lifetime of the tab instead of turning a successful
/// 200 login into a generic sign-in error.
class _FallbackAuthStorage implements ClientAuthSuccessStorage {
  _FallbackAuthStorage(this._secure);

  final ClientAuthSuccessStorage _secure;
  AuthSuccess? _memory;
  bool _secureUnavailable = false;

  @override
  Future<void> set(AuthSuccess? data) async {
    _memory = data;
    if (_secureUnavailable) return;
    try {
      await _secure.set(data);
    } catch (_) {
      _secureUnavailable = true;
    }
  }

  @override
  Future<AuthSuccess?> get() async {
    if (!_secureUnavailable) {
      try {
        final value = await _secure.get();
        if (value != null) _memory = value;
        return value;
      } catch (_) {
        _secureUnavailable = true;
      }
    }
    return _memory;
  }
}
