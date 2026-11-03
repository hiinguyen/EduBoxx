/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:edubox_client/src/protocol/dto/assignment_upsert.dart'
    as _igbonyh0;
import 'package:edubox_client/src/protocol/dto/class_results.dart' as _iznffzrq;
import 'package:edubox_client/src/protocol/dto/class_summary.dart' as _i80od7do;
import 'package:edubox_client/src/protocol/dto/content_detail.dart'
    as _im8gcyvq;
import 'package:edubox_client/src/protocol/dto/exercise_upsert.dart'
    as _ifxtqe0l;
import 'package:edubox_client/src/protocol/dto/parent_summary.dart'
    as _icn13e8a;
import 'package:edubox_client/src/protocol/dto/ping_message.dart' as _i9dbhbpv;
import 'package:edubox_client/src/protocol/dto/profile_result.dart'
    as _ilhq9gsi;
import 'package:edubox_client/src/protocol/dto/progress_result.dart'
    as _i11ejrv7;
import 'package:edubox_client/src/protocol/dto/signed_file_url.dart'
    as _izl9ncfi;
import 'package:edubox_client/src/protocol/dto/student_assignment_detail.dart'
    as _i24a2u1t;
import 'package:edubox_client/src/protocol/dto/student_assignment_list.dart'
    as _in4wwkop;
import 'package:edubox_client/src/protocol/dto/student_library.dart'
    as _i0sccsjs;
import 'package:edubox_client/src/protocol/dto/submission_result.dart'
    as _iio0nk6j;
import 'package:edubox_client/src/protocol/dto/submitted_answer.dart'
    as _io53xjb9;
import 'package:edubox_client/src/protocol/dto/teacher_assignment_item.dart'
    as _itougsx7;
import 'package:edubox_client/src/protocol/dto/teacher_content_item.dart'
    as _izomhfjr;
import 'package:edubox_client/src/protocol/dto/teacher_exercise_detail.dart'
    as _igugjiqy;
import 'package:edubox_client/src/protocol/dto/teacher_exercise_summary.dart'
    as _iftr0d72;
import 'package:edubox_client/src/protocol/dto/test_start_result.dart'
    as _i8abfgd7;
import 'package:edubox_client/src/protocol/dto/tutor_chat_detail.dart'
    as _ie7messy;
import 'package:edubox_client/src/protocol/dto/tutor_chat_summary.dart'
    as _ihm7r1k6;
import 'package:edubox_client/src/protocol/dto/tutor_event.dart' as _io999o4q;
import 'package:edubox_client/src/protocol/dto/tutor_state.dart' as _i6nhj9py;
import 'package:edubox_client/src/protocol/dto/upload_ticket.dart' as _ikvdep2k;
import 'package:edubox_client/src/protocol/enums/content_type.dart'
    as _ihy8p2rl;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// Teacher assignment authoring and the student's assignment list.
/// {@category Endpoint}
class EndpointAssignments extends EndpointEdubox {
  EndpointAssignments(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'assignments';

  /// Creates or updates an assignment for one of the teacher's classes.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  _ida.Future<_itougsx7.TeacherAssignmentItem> save(
    _igbonyh0.AssignmentUpsert input,
  ) => caller.callServerEndpoint<_itougsx7.TeacherAssignmentItem>(
    'assignments',
    'save',
    {'input': input},
  );

  /// Deletes one of the teacher's own assignments (its submissions cascade).
  ///
  /// Allowed: the owning teacher. Denied: every other caller.
  _ida.Future<void> delete({required int assignmentId}) =>
      caller.callServerEndpoint<void>(
        'assignments',
        'delete',
        {'assignmentId': assignmentId},
      );

  /// The teacher's assignments across their classes, newest first.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  _ida.Future<List<_itougsx7.TeacherAssignmentItem>> mine() =>
      caller.callServerEndpoint<List<_itougsx7.TeacherAssignmentItem>>(
        'assignments',
        'mine',
        {},
      );

  /// The student's assignments for their own classes.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  _ida.Future<_in4wwkop.StudentAssignmentList> listForStudent() =>
      caller.callServerEndpoint<_in4wwkop.StudentAssignmentList>(
        'assignments',
        'listForStudent',
        {},
      );

  /// One assignment with its exercise and lesson state, for the student's
  /// lesson-and-exercise screen.
  ///
  /// Allowed: a student of the assignment's class. Denied: every other caller.
  _ida.Future<_i24a2u1t.StudentAssignmentDetail> detailForStudent({
    required int assignmentId,
  }) => caller.callServerEndpoint<_i24a2u1t.StudentAssignmentDetail>(
    'assignments',
    'detailForStudent',
    {'assignmentId': assignmentId},
  );
}

/// Email sign-in. Exposes `login` only.
///
/// This endpoint intentionally does not extend `EmailIdpBaseEndpoint`, so the
/// generated client has no registration, account-request, or password-reset
/// call at all (roadmap phase 1, exit criterion 12).
///
/// Errors reach the client typed:
/// - `EmailAccountLoginException(reason: invalidCredentials)` for a wrong
///   email or password (account existence is never revealed),
/// - `EmailAccountLoginException(reason: tooManyAttempts)` after 5 failed
///   attempts within 5 minutes,
/// - `AuthUserBlockedException` for a blocked auth user.
/// {@category Endpoint}
class EndpointEmailIdp extends _isc.EndpointRef {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Signs in with email and password and returns a JWT session.
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
    authenticated: false,
  );
}

/// JWT refresh. On the unauthenticated exception list: it accepts a refresh
/// token instead of a session.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Base class of every EduBox endpoint (not the auth module endpoints).
///
/// `requireLogin` makes Serverpod reject unauthenticated calls before any
/// EduBox code runs; each method additionally calls `requireCaller` or
/// `requireRole`, which loads the role from the `users` table.
/// {@category Endpoint}
abstract class EndpointEdubox extends _isc.EndpointRef {
  EndpointEdubox(_isc.EndpointCaller caller) : super(caller);
}

/// Classes, from the teacher's side.
/// {@category Endpoint}
class EndpointClasses extends EndpointEdubox {
  EndpointClasses(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'classes';

  /// The calling teacher's own classes, ordered by grade, then name, with
  /// teacher-ordered subjects and the member count.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  _ida.Future<List<_i80od7do.ClassSummary>> mine() =>
      caller.callServerEndpoint<List<_i80od7do.ClassSummary>>(
        'classes',
        'mine',
        {},
      );
}

/// Content, from the student's and the teacher's sides.
/// {@category Endpoint}
class EndpointContent extends EndpointEdubox {
  EndpointContent(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'content';

  /// The calling student's classes and the `approved` content scoped to at
  /// least one of them, newest first. Draft content and other classes'
  /// content are never returned.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  _ida.Future<_i0sccsjs.StudentLibrary> library() =>
      caller.callServerEndpoint<_i0sccsjs.StudentLibrary>(
        'content',
        'library',
        {},
      );

  /// One content item's metadata. A student may read only approved content of
  /// their classes; a teacher only their own content.
  ///
  /// Allowed: student, teacher. Denied: parent, not set up, unauthenticated.
  _ida.Future<_im8gcyvq.ContentDetail> detail({required int contentId}) =>
      caller.callServerEndpoint<_im8gcyvq.ContentDetail>(
        'content',
        'detail',
        {'contentId': contentId},
      );

  /// The teacher's own content, newest first. Exercises appear with their
  /// exercise id so the assignment editor can link them.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  _ida.Future<List<_izomhfjr.TeacherContentItem>> teacherList() =>
      caller.callServerEndpoint<List<_izomhfjr.TeacherContentItem>>(
        'content',
        'teacherList',
        {},
      );

  /// Creates a draft content row and a direct-to-storage upload ticket.
  /// The file is not trusted until [completeUpload] validates it.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  _ida.Future<_ikvdep2k.UploadTicket> createUpload({
    required int classId,
    required _ihy8p2rl.ContentType type,
    required String title,
    required String subject,
    required int gradeLevel,
    required String fileName,
    required int sizeBytes,
  }) => caller.callServerEndpoint<_ikvdep2k.UploadTicket>(
    'content',
    'createUpload',
    {
      'classId': classId,
      'type': type,
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      'fileName': fileName,
      'sizeBytes': sizeBytes,
    },
  );

  /// Verifies and ingests a file uploaded through [createUpload]. Marks the
  /// content `ready` with normalized metadata, or `rejected` with a reason.
  ///
  /// Allowed: the owning teacher. Denied: every other caller.
  _ida.Future<_izomhfjr.TeacherContentItem> completeUpload({
    required int contentId,
  }) => caller.callServerEndpoint<_izomhfjr.TeacherContentItem>(
    'content',
    'completeUpload',
    {'contentId': contentId},
  );

  /// Moves the owning teacher's ready content from draft to approved.
  ///
  /// Allowed: the owning teacher. Denied: every other caller.
  _ida.Future<_izomhfjr.TeacherContentItem> approve({required int contentId}) =>
      caller.callServerEndpoint<_izomhfjr.TeacherContentItem>(
        'content',
        'approve',
        {'contentId': contentId},
      );

  /// A short-lived signed URL for the content file. Only the owning teacher
  /// or a student of a class the approved content belongs to may read it.
  ///
  /// Allowed: student, teacher. Denied: parent, not set up, unauthenticated.
  _ida.Future<_izl9ncfi.SignedFileUrl> fileUrl({required int contentId}) =>
      caller.callServerEndpoint<_izl9ncfi.SignedFileUrl>(
        'content',
        'fileUrl',
        {'contentId': contentId},
      );
}

/// Diagnostics that prove transport paths end to end.
/// {@category Endpoint}
class EndpointDiagnostics extends EndpointEdubox {
  EndpointDiagnostics(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'diagnostics';

  /// Streams [pingCount] messages carrying the caller's role, then closes.
  ///
  /// Allowed: student, teacher, parent. Denied: not set up, unauthenticated.
  _ida.Stream<_i9dbhbpv.PingMessage> pingStream() =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i9dbhbpv.PingMessage>,
        _i9dbhbpv.PingMessage
      >(
        'diagnostics',
        'pingStream',
        {},
        {},
      );
}

/// The token-guarded route the on-device E2E harness uses to change
/// server-side state mid-run (exit criterion 7 and the account-not-set-up
/// check-again case).
///
/// It exists only in the run modes the contract allows (the compose e2e
/// server's `development` mode and Serverpod's `test` mode), only when that
/// mode sets `edubox.e2eControl: true` or `EDUBOX_E2E_CONTROL=true`, and it
/// always requires the `e2eControlToken` password. `production`, `staging` and
/// every other run mode reject it even with the environment override and the
/// correct token. The contract is in docs/build/phase-1/contract.md section
/// 2.8.
/// {@category Endpoint}
class EndpointE2e extends _isc.EndpointRef {
  EndpointE2e(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'e2e';

  /// Runs one control operation and returns `ok:<step>`.
  _ida.Future<String> run({
    required String token,
    required String step,
    String? accountKey,
    String? role,
  }) => caller.callServerEndpoint<String>(
    'e2e',
    'run',
    {
      'token': token,
      'step': step,
      'accountKey': accountKey,
      'role': role,
    },
  );
}

/// Exercise authoring (teacher) and reading (teacher).
/// {@category Endpoint}
class EndpointExercises extends EndpointEdubox {
  EndpointExercises(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'exercises';

  /// Creates or replaces an exercise and its questions. Editing bumps the
  /// answer-key version; submissions keep the snapshot they started with.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  _ida.Future<_igugjiqy.TeacherExerciseDetail> save(
    _ifxtqe0l.ExerciseUpsert input,
  ) => caller.callServerEndpoint<_igugjiqy.TeacherExerciseDetail>(
    'exercises',
    'save',
    {'input': input},
  );

  /// One of the teacher's own exercises, with its answer key.
  ///
  /// Allowed: the owning teacher. Denied: every other caller.
  _ida.Future<_igugjiqy.TeacherExerciseDetail> detail({
    required int exerciseId,
  }) => caller.callServerEndpoint<_igugjiqy.TeacherExerciseDetail>(
    'exercises',
    'detail',
    {'exerciseId': exerciseId},
  );

  /// The teacher's exercises for the assignment editor.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  _ida.Future<List<_iftr0d72.TeacherExerciseSummary>> mine() =>
      caller.callServerEndpoint<List<_iftr0d72.TeacherExerciseSummary>>(
        'exercises',
        'mine',
        {},
      );
}

/// Read-only parent view of the linked child. Parents have no write method
/// anywhere in the API.
/// {@category Endpoint}
class EndpointParent extends EndpointEdubox {
  EndpointParent(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'parent';

  /// The linked child's results and AI chats.
  ///
  /// Allowed: parent. Denied: student, teacher, not set up, unauthenticated.
  _ida.Future<_icn13e8a.ParentSummary> summary() =>
      caller.callServerEndpoint<_icn13e8a.ParentSummary>(
        'parent',
        'summary',
        {},
      );

  /// The linked child's AI chats, newest first.
  ///
  /// Allowed: parent. Denied: student, teacher, not set up, unauthenticated.
  _ida.Future<List<_ihm7r1k6.TutorChatSummary>> chats() =>
      caller.callServerEndpoint<List<_ihm7r1k6.TutorChatSummary>>(
        'parent',
        'chats',
        {},
      );

  /// One full read-only transcript of the linked child.
  ///
  /// Allowed: parent. Denied: student, teacher, not set up, unauthenticated.
  _ida.Future<_ie7messy.TutorChatDetail> chat({required int chatId}) =>
      caller.callServerEndpoint<_ie7messy.TutorChatDetail>(
        'parent',
        'chat',
        {'chatId': chatId},
      );
}

/// The caller's own profile.
/// {@category Endpoint}
class EndpointProfile extends EndpointEdubox {
  EndpointProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profile';

  /// Returns the caller's own profile (`ready`), or `notSetUp` when the
  /// caller has no `users` row, a null role, or an unparseable role.
  ///
  /// Allowed: any authenticated caller, including not-set-up users. It never
  /// answers `notSetUp` with an error, and never returns another user's data.
  _ida.Future<_ilhq9gsi.ProfileResult> me() =>
      caller.callServerEndpoint<_ilhq9gsi.ProfileResult>(
        'profile',
        'me',
        {},
      );
}

/// Lesson completion for the calling student.
/// {@category Endpoint}
class EndpointProgress extends EndpointEdubox {
  EndpointProgress(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'progress';

  /// Marks an approved content item of one of the student's classes complete.
  /// Idempotent: a second call updates the timestamp and adds no row.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  _ida.Future<_i11ejrv7.ProgressResult> markComplete({
    required int contentId,
  }) => caller.callServerEndpoint<_i11ejrv7.ProgressResult>(
    'progress',
    'markComplete',
    {'contentId': contentId},
  );

  /// The calling student's completed lessons.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  _ida.Future<List<_i11ejrv7.ProgressResult>> mine() =>
      caller.callServerEndpoint<List<_i11ejrv7.ProgressResult>>(
        'progress',
        'mine',
        {},
      );
}

/// The teacher's Sổ điểm: one class, its students, assignments and cells.
/// {@category Endpoint}
class EndpointResults extends EndpointEdubox {
  EndpointResults(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'results';

  /// Read-only gradebook for one of the teacher's own classes.
  ///
  /// Allowed: the owning teacher. Denied: student, parent, other teacher, not
  /// set up, unauthenticated.
  _ida.Future<_iznffzrq.ClassResults> classResults({required int classId}) =>
      caller.callServerEndpoint<_iznffzrq.ClassResults>(
        'results',
        'classResults',
        {'classId': classId},
      );
}

/// Student submissions and auto-grading.
/// {@category Endpoint}
class EndpointSubmissions extends EndpointEdubox {
  EndpointSubmissions(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'submissions';

  /// Accepts the calling student's answers for one of their assignments.
  /// Replays with the same [clientSubmissionId] return the stored grade
  /// (outbox idempotency); a test without a `tests.start` row is rejected.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  _ida.Future<_iio0nk6j.SubmissionResult> submit({
    required int assignmentId,
    required String clientSubmissionId,
    required List<_io53xjb9.SubmittedAnswer> answers,
  }) => caller.callServerEndpoint<_iio0nk6j.SubmissionResult>(
    'submissions',
    'submit',
    {
      'assignmentId': assignmentId,
      'clientSubmissionId': clientSubmissionId,
      'answers': answers,
    },
  );

  /// The calling student's latest submission for one assignment.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  _ida.Future<_iio0nk6j.SubmissionResult?> forAssignment({
    required int assignmentId,
  }) => caller.callServerEndpoint<_iio0nk6j.SubmissionResult?>(
    'submissions',
    'forAssignment',
    {'assignmentId': assignmentId},
  );

  /// Re-runs grading with the exercise's current answer key.
  ///
  /// Allowed: the teacher owning the assignment's class. Denied: every other
  /// caller.
  _ida.Future<_iio0nk6j.SubmissionResult> regrade({
    required int submissionId,
  }) => caller.callServerEndpoint<_iio0nk6j.SubmissionResult>(
    'submissions',
    'regrade',
    {'submissionId': submissionId},
  );
}

/// Test start: the only assignment action that requires connectivity by
/// design, so the server owns `startedAt` and the AI lockout.
/// {@category Endpoint}
class EndpointTests extends EndpointEdubox {
  EndpointTests(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'tests';

  /// Starts a timed test for the calling student, or returns the already
  /// running attempt for the same assignment (restart-safe).
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  _ida.Future<_i8abfgd7.TestStartResult> start({
    required int assignmentId,
    required String clientSubmissionId,
  }) => caller.callServerEndpoint<_i8abfgd7.TestStartResult>(
    'tests',
    'start',
    {
      'assignmentId': assignmentId,
      'clientSubmissionId': clientSubmissionId,
    },
  );

  /// The calling student's active test, if any (in-process restart).
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  _ida.Future<_i8abfgd7.TestStartResult?> active() =>
      caller.callServerEndpoint<_i8abfgd7.TestStartResult?>(
        'tests',
        'active',
        {},
      );
}

/// The scoped, rate-limited, logged AI study tutor.
/// {@category Endpoint}
class EndpointTutor extends EndpointEdubox {
  EndpointTutor(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'tutor';

  /// Preflight state: the student's subjects, today's budget, and whether a
  /// timed test currently locks the tutor.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  _ida.Future<_i6nhj9py.TutorState> state() =>
      caller.callServerEndpoint<_i6nhj9py.TutorState>(
        'tutor',
        'state',
        {},
      );

  /// The calling student's past tutor conversations, newest first.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  _ida.Future<List<_ihm7r1k6.TutorChatSummary>> chats() =>
      caller.callServerEndpoint<List<_ihm7r1k6.TutorChatSummary>>(
        'tutor',
        'chats',
        {},
      );

  /// One of the calling student's transcripts.
  ///
  /// Allowed: the owning student. Denied: every other caller.
  _ida.Future<_ie7messy.TutorChatDetail> chat({required int chatId}) =>
      caller.callServerEndpoint<_ie7messy.TutorChatDetail>(
        'tutor',
        'chat',
        {'chatId': chatId},
      );

  /// Streams one tutor answer. Subject scope, the active-test lockout and
  /// the daily limit are enforced before anything is sent to the provider;
  /// both messages are written by the server only.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  _ida.Stream<_io999o4q.TutorEvent> ask({
    required String subject,
    required String message,
    int? chatId,
  }) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_io999o4q.TutorEvent>,
        _io999o4q.TutorEvent
      >(
        'tutor',
        'ask',
        {
          'subject': subject,
          'message': message,
          'chatId': chatId,
        },
        {},
      );

  /// Chats of a student in one of the teacher's own classes.
  ///
  /// Allowed: teacher. Denied: student, parent, unauthenticated.
  _ida.Future<List<_ihm7r1k6.TutorChatSummary>> classChats({
    required int studentId,
  }) => caller.callServerEndpoint<List<_ihm7r1k6.TutorChatSummary>>(
    'tutor',
    'classChats',
    {'studentId': studentId},
  );

  /// One read-only transcript for a student in the teacher's class.
  ///
  /// Allowed: teacher. Denied: student, parent, unauthenticated.
  _ida.Future<_ie7messy.TutorChatDetail> classChat({required int chatId}) =>
      caller.callServerEndpoint<_ie7messy.TutorChatDetail>(
        'tutor',
        'classChat',
        {'chatId': chatId},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    assignments = EndpointAssignments(this);
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    classes = EndpointClasses(this);
    content = EndpointContent(this);
    diagnostics = EndpointDiagnostics(this);
    e2e = EndpointE2e(this);
    exercises = EndpointExercises(this);
    parent = EndpointParent(this);
    profile = EndpointProfile(this);
    progress = EndpointProgress(this);
    results = EndpointResults(this);
    submissions = EndpointSubmissions(this);
    tests = EndpointTests(this);
    tutor = EndpointTutor(this);
    modules = Modules(this);
  }

  late final EndpointAssignments assignments;

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointClasses classes;

  late final EndpointContent content;

  late final EndpointDiagnostics diagnostics;

  late final EndpointE2e e2e;

  late final EndpointExercises exercises;

  late final EndpointParent parent;

  late final EndpointProfile profile;

  late final EndpointProgress progress;

  late final EndpointResults results;

  late final EndpointSubmissions submissions;

  late final EndpointTests tests;

  late final EndpointTutor tutor;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'assignments': assignments,
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'classes': classes,
    'content': content,
    'diagnostics': diagnostics,
    'e2e': e2e,
    'exercises': exercises,
    'parent': parent,
    'profile': profile,
    'progress': progress,
    'results': results,
    'submissions': submissions,
    'tests': tests,
    'tutor': tutor,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
