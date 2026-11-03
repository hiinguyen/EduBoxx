// CONTRACT (phase 1): the authorization matrix.
//
// Every method the server dispatches must appear in exactly one of the four
// lists below; `authorization_matrix_test.dart` fails otherwise. When a phase
// adds an endpoint method, it adds the method's row here in the same change.

import 'package:edubox_fixtures/edubox_fixtures.dart';
import 'package:edubox_server/src/generated/protocol.dart';
import 'package:edubox_server/src/seed/fixture_loader.dart';
import 'package:edubox_server/src/seed/learning_fixtures.dart';

import '../test_tools/serverpod_test_tools.dart';

/// The kinds of caller every EduBox endpoint method is tested with.
enum MatrixCaller {
  student(FixtureKeys.studentAn),
  teacher(FixtureKeys.teacherLan),
  parent(FixtureKeys.parentBinh),

  /// An auth user with no `users` row.
  noProfile(FixtureKeys.noProfile),

  /// A `users` row whose role is null.
  nullRole(FixtureKeys.nullRole),

  /// No session at all.
  anonymous(null);

  const MatrixCaller(this.fixtureKey);

  /// The fixture account this caller signs in as (null for [anonymous]).
  final String? fixtureKey;
}

/// One EduBox endpoint method: who may call it, and how to call it.
class MethodRule {
  const MethodRule({
    required this.allowed,
    required this.invoke,
    this.isStream = false,
  });

  /// Callers that must succeed. Every other caller must be denied:
  /// [MatrixCaller.anonymous] by Serverpod (requireLogin), the not-set-up
  /// callers with `AccessDeniedReason.notSetUp`, and the remaining roles
  /// with `AccessDeniedReason.wrongRole`.
  final Set<MatrixCaller> allowed;

  /// Calls the method and waits for its full result (a stream is drained).
  final Future<Object?> Function(
    TestEndpoints endpoints,
    TestSessionBuilder sessionBuilder,
    SeededFixtures seeded,
  )
  invoke;

  final bool isStream;
}

/// EduBox endpoint methods (key: `<endpoint>.<method>`).
final Map<String, MethodRule> eduboxMethodMatrix = {
  'profile.me': MethodRule(
    // Not-set-up callers are allowed: they receive `notSetUp`, never an error.
    allowed: {
      MatrixCaller.student,
      MatrixCaller.teacher,
      MatrixCaller.parent,
      MatrixCaller.noProfile,
      MatrixCaller.nullRole,
    },
    invoke: (e, sb, seeded) => e.profile.me(sb),
  ),
  'classes.mine': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.classes.mine(sb),
  ),
  'content.library': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.content.library(sb),
  ),
  'content.detail': MethodRule(
    allowed: {MatrixCaller.student, MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.content.detail(
      sb,
      contentId: seeded.contentIds[FixtureKeys.ebookFractions]!,
    ),
  ),
  'content.teacherList': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.content.teacherList(sb),
  ),
  'content.createUpload': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.content.createUpload(
      sb,
      classId: seeded.classIds[FixtureKeys.class7A]!,
      type: ContentType.ebook,
      title: 'Matrix upload',
      subject: 'Toán',
      gradeLevel: 7,
      fileName: 'matrix.pdf',
      sizeBytes: 1024,
    ),
  ),
  'content.completeUpload': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) async {
      final ticket = await e.content.createUpload(
        sb,
        classId: seeded.classIds[FixtureKeys.class7A]!,
        type: ContentType.ebook,
        title: 'Matrix upload',
        subject: 'Toán',
        gradeLevel: 7,
        fileName: 'matrix.pdf',
        sizeBytes: 1024,
      );
      return e.content.completeUpload(sb, contentId: ticket.contentId);
    },
  ),
  'content.approve': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.content.approve(
      sb,
      contentId: seeded.contentIds[FixtureKeys.draftGeometry]!,
    ),
  ),
  'content.fileUrl': MethodRule(
    allowed: {MatrixCaller.student, MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.content.fileUrl(
      sb,
      contentId: seeded.contentIds[FixtureKeys.ebookFractions]!,
    ),
  ),
  'exercises.save': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.exercises.save(
      sb,
      ExerciseUpsert(
        contentId: seeded.contentIds[FixtureKeys.exerciseFractions]!,
        classId: seeded.classIds[FixtureKeys.class7A]!,
        title: 'Luyện tập: Phép cộng phân số',
        subject: 'Toán',
        gradeLevel: 7,
        questions: [
          ExerciseQuestionInput(
            position: 0,
            stem: '1/2 + 1/4 = ?',
            multiSelect: false,
            options: const ['1/6', '3/4', '2/6', '1/8'],
            correctPositions: const [1],
          ),
        ],
      ),
    ),
  ),
  'exercises.detail': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.exercises.detail(
      sb,
      exerciseId: seeded.exerciseIds[LearningFixtureKeys.fractions]!,
    ),
  ),
  'exercises.mine': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.exercises.mine(sb),
  ),
  'assignments.save': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.assignments.save(
      sb,
      AssignmentUpsert(
        classId: seeded.classIds[FixtureKeys.class7A]!,
        exerciseId: seeded.exerciseIds[LearningFixtureKeys.fractions]!,
        type: AssignmentType.practice,
        title: 'Matrix assignment',
        dueAt: DateTime.utc(2026, 12, 1),
      ),
    ),
  ),
  'assignments.delete': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.assignments.delete(
      sb,
      assignmentId: seeded.assignmentIds[LearningFixtureKeys.test]!,
    ),
  ),
  'assignments.mine': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.assignments.mine(sb),
  ),
  'assignments.listForStudent': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.assignments.listForStudent(sb),
  ),
  'assignments.detailForStudent': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.assignments.detailForStudent(
      sb,
      assignmentId: seeded.assignmentIds[LearningFixtureKeys.practice]!,
    ),
  ),
  'progress.markComplete': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.progress.markComplete(
      sb,
      contentId: seeded.contentIds[FixtureKeys.ebookFractions]!,
    ),
  ),
  'progress.mine': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.progress.mine(sb),
  ),
  'results.classResults': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.results.classResults(
      sb,
      classId: seeded.classIds[FixtureKeys.class7A]!,
    ),
  ),
  'submissions.submit': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.submissions.submit(
      sb,
      assignmentId: seeded.assignmentIds[LearningFixtureKeys.practice]!,
      clientSubmissionId: 'matrix-submit',
      answers: const [],
    ),
  ),
  'submissions.forAssignment': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.submissions.forAssignment(
      sb,
      assignmentId: seeded.assignmentIds[LearningFixtureKeys.practice]!,
    ),
  ),
  'submissions.regrade': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.submissions.regrade(
      sb,
      submissionId: seeded.submissionIds[LearningFixtureKeys.attempt]!,
    ),
  ),
  'tests.start': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.tests.start(
      sb,
      assignmentId: seeded.assignmentIds[LearningFixtureKeys.test]!,
      clientSubmissionId: 'matrix-test',
    ),
  ),
  'tests.active': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.tests.active(sb),
  ),
  'tutor.state': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.tutor.state(sb),
  ),
  'tutor.chats': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.tutor.chats(sb),
  ),
  'tutor.chat': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.tutor.chat(
      sb,
      chatId: seeded.chatIds[LearningFixtureKeys.tutorChat]!,
    ),
  ),
  'tutor.ask': MethodRule(
    allowed: {MatrixCaller.student},
    invoke: (e, sb, seeded) => e.tutor
        .ask(sb, subject: 'Toán', message: 'Làm sao cộng hai phân số?')
        .toList(),
    isStream: true,
  ),
  'tutor.classChats': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.tutor.classChats(
      sb,
      studentId: seeded.userIds[FixtureKeys.studentAn]!,
    ),
  ),
  'tutor.classChat': MethodRule(
    allowed: {MatrixCaller.teacher},
    invoke: (e, sb, seeded) => e.tutor.classChat(
      sb,
      chatId: seeded.chatIds[LearningFixtureKeys.tutorChat]!,
    ),
  ),
  'parent.summary': MethodRule(
    allowed: {MatrixCaller.parent},
    invoke: (e, sb, seeded) => e.parent.summary(sb),
  ),
  'parent.chats': MethodRule(
    allowed: {MatrixCaller.parent},
    invoke: (e, sb, seeded) => e.parent.chats(sb),
  ),
  'parent.chat': MethodRule(
    allowed: {MatrixCaller.parent},
    invoke: (e, sb, seeded) => e.parent.chat(
      sb,
      chatId: seeded.chatIds[LearningFixtureKeys.tutorChat]!,
    ),
  ),
  'diagnostics.pingStream': MethodRule(
    allowed: {MatrixCaller.student, MatrixCaller.teacher, MatrixCaller.parent},
    invoke: (e, sb, seeded) => e.diagnostics.pingStream(sb).toList(),
    isStream: true,
  ),
};

/// Test-only HTTP/endpoint surface that is not role-gated but is guarded by
/// the e2e control token and exists only in the `development` (compose e2e)
/// and `test` run modes when `edubox.e2eControl` is true. `production`,
/// `staging` and every other mode reject it. `test/integration/e2e/`
/// `e2e_control_test.dart` proves the allowed and denied states.
const Map<String, String> tokenGuardedE2eMethods = {
  'e2e.run':
      'Allowed only in the development/test run modes with '
      'edubox.e2eControl/EDUBOX_E2E_CONTROL=true; every call requires the '
      'e2eControlToken password. Production and staging always deny.',
};

/// Auth-module methods a caller may use without a session, each with the
/// reason it is safe. Each has a test in `module_endpoints_test.dart`.
const Map<String, String> moduleUnauthenticatedExceptions = {
  'emailIdp.login':
      'Sign-in. Wrong credentials, rate limit, and blocked users are tested.',
  'jwtRefresh.refreshAccessToken':
      'Session refresh. Needs a valid refresh token; none is denied.',
  'serverpod_auth_core.status.isSignedIn':
      'Returns false without a session; reads and writes nothing.',
  'serverpod_auth_core.status.signOutDevice':
      'No-op without a session (the client session manager calls it).',
  'serverpod_auth_core.status.signOutAllDevices': 'No-op without a session.',
};

/// Serverpod core raw routes (not in the generated client) that are
/// reachable without a session, each with the reason it is safe. Tested over
/// real HTTP in `module_endpoints_test.dart`.
const Map<String, String> frameworkUnauthenticatedExceptions = {
  'serverpod_cloud_storage.file':
      'Serves the database-backed "public" storage only; EduBox never writes '
      'to it (EduBox files live in the private MinIO bucket).',
  'serverpod_cloud_storage.temporaryFile':
      'Needs a server-issued download key; EduBox issues none.',
  'serverpod_cloud_storage.upload':
      'Needs a server-issued upload key; EduBox issues none.',
};

/// Auth-module methods that must deny an unauthenticated caller.
const Set<String> moduleDeniedUnauthenticated = {
  'serverpod_auth_core.userProfileInfo.get',
};
