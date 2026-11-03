import 'package:serverpod/serverpod.dart';

import '../authz/edubox_endpoint.dart';
import '../authz/guard.dart';
import '../generated/protocol.dart';
import '../learning/access.dart';
import '../learning/exercise_service.dart';
import '../learning/grading.dart';
import '../services/edubox_services.dart';

/// Test start: the only assignment action that requires connectivity by
/// design, so the server owns `startedAt` and the AI lockout.
class TestsEndpoint extends EduboxEndpoint {
  /// Starts a timed test for the calling student, or returns the already
  /// running attempt for the same assignment (restart-safe).
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  Future<TestStartResult> start(
    Session session, {
    required int assignmentId,
    required String clientSubmissionId,
  }) async {
    final caller = await requireRole(session, UserRole.student);
    final id = clientSubmissionId.trim();
    if (id.isEmpty || id.length > 100) {
      throw ArgumentError.value(
        clientSubmissionId,
        'clientSubmissionId',
        'Required, max 100 chars',
      );
    }
    final assignment = await Assignment.db.findById(session, assignmentId);
    if (assignment == null ||
        !await LearningAccess.studentInClass(
          session,
          studentId: caller.userId,
          classId: assignment.classId,
        )) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    if (assignment.type != AssignmentType.test ||
        assignment.timeLimitSec == null) {
      throw ArgumentError.value(assignmentId, 'assignmentId', 'Not a test');
    }
    final existingByClient = await Submission.db.findFirstRow(
      session,
      where: (t) => t.clientSubmissionId.equals(id),
    );
    if (existingByClient != null) {
      if (existingByClient.studentId != caller.userId ||
          existingByClient.assignmentId != assignmentId) {
        throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
      }
      return _result(assignment, existingByClient);
    }
    final inProgress = await Submission.db.findFirstRow(
      session,
      where: (t) =>
          t.assignmentId.equals(assignmentId) &
          t.studentId.equals(caller.userId) &
          t.status.equals(SubmissionStatus.inProgress),
      orderByList: (t) => [t.startedAt.desc()],
    );
    if (inProgress != null) {
      // A new start after a lost response reuses the running attempt.
      return _result(assignment, inProgress);
    }
    final finished = await Submission.db.findFirstRow(
      session,
      where: (t) =>
          t.assignmentId.equals(assignmentId) &
          t.studentId.equals(caller.userId),
    );
    if (finished != null) {
      throw SubmissionRejectedException(
        reason: SubmissionRejectReason.alreadySubmitted,
      );
    }
    final activeElsewhere = await Submission.db.findFirstRow(
      session,
      where: (t) =>
          t.studentId.equals(caller.userId) &
          t.status.equals(SubmissionStatus.inProgress),
    );
    if (activeElsewhere != null) {
      throw SubmissionRejectedException(
        reason: SubmissionRejectReason.alreadySubmitted,
      );
    }
    final exercise = await Exercise.db.findById(session, assignment.exerciseId);
    if (exercise == null) {
      throw SubmissionRejectedException(
        reason: SubmissionRejectReason.assignmentChanged,
      );
    }
    final questions = await ExerciseQueries.questions(session, exercise.id!);
    final now = EduboxServices.now();
    final row = await Submission.db.insertRow(
      session,
      Submission(
        assignmentId: assignmentId,
        studentId: caller.userId,
        clientSubmissionId: id,
        status: SubmissionStatus.inProgress,
        answersJson: '{}',
        answerKeySnapshotJson: questions.isEmpty
            ? null
            : AutoGrader.snapshot(
                ExerciseQueries.gradeQuestions(questions),
              ),
        answerKeyVersion: exercise.answerKeyVersion,
        late: false,
        startedAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return _result(assignment, row);
  }

  /// The calling student's active test, if any (in-process restart).
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  Future<TestStartResult?> active(Session session) async {
    final caller = await requireRole(session, UserRole.student);
    final row = await Submission.db.findFirstRow(
      session,
      where: (t) =>
          t.studentId.equals(caller.userId) &
          t.status.equals(SubmissionStatus.inProgress),
      orderByList: (t) => [t.startedAt.desc()],
    );
    if (row == null) return null;
    final assignment = await Assignment.db.findById(session, row.assignmentId);
    if (assignment == null) return null;
    return _result(assignment, row);
  }

  static TestStartResult _result(Assignment assignment, Submission submission) {
    final started = submission.startedAt!;
    return TestStartResult(
      assignmentId: assignment.id!,
      submissionId: submission.id!,
      clientSubmissionId: submission.clientSubmissionId,
      startedAt: started,
      deadline: started.add(Duration(seconds: assignment.timeLimitSec!)),
    );
  }
}
