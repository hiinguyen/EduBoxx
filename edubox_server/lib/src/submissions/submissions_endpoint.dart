import 'package:serverpod/serverpod.dart';

import '../authz/edubox_endpoint.dart';
import '../authz/guard.dart';
import '../generated/protocol.dart';
import '../learning/access.dart';
import '../learning/exercise_service.dart';
import '../learning/grading.dart';
import '../services/edubox_services.dart';

/// Student submissions and auto-grading.
class SubmissionsEndpoint extends EduboxEndpoint {
  /// Accepts the calling student's answers for one of their assignments.
  /// Replays with the same [clientSubmissionId] return the stored grade
  /// (outbox idempotency); a test without a `tests.start` row is rejected.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  Future<SubmissionResult> submit(
    Session session, {
    required int assignmentId,
    required String clientSubmissionId,
    required List<SubmittedAnswer> answers,
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
    final duplicate = await Submission.db.findFirstRow(
      session,
      where: (t) => t.clientSubmissionId.equals(id),
    );
    if (duplicate != null) {
      if (duplicate.studentId != caller.userId ||
          duplicate.assignmentId != assignmentId) {
        throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
      }
      // An in-progress timed test is completed by this submit; only a
      // finished attempt is an outbox replay.
      if (duplicate.status != SubmissionStatus.inProgress) {
        return _result(duplicate);
      }
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
    final exercise = await Exercise.db.findById(session, assignment.exerciseId);
    if (exercise == null) {
      throw SubmissionRejectedException(
        reason: SubmissionRejectReason.assignmentChanged,
      );
    }
    final questions = await ExerciseQueries.questions(session, exercise.id!);
    final gradeQuestions = ExerciseQueries.gradeQuestions(questions);
    final multiSelect = {
      for (final question in questions) question.id: question.multiSelect,
    };
    final now = EduboxServices.now();
    final answerMap = {
      for (final answer in answers)
        answer.questionId: answer.selectedPositions..sort(),
    };

    Submission? testAttempt;
    if (assignment.type == AssignmentType.test) {
      testAttempt = await Submission.db.findFirstRow(
        session,
        where: (t) =>
            t.assignmentId.equals(assignmentId) &
            t.studentId.equals(caller.userId) &
            t.status.equals(SubmissionStatus.inProgress),
        orderByList: (t) => [t.startedAt.desc()],
      );
      if (testAttempt == null) {
        final any = await Submission.db.findFirstRow(
          session,
          where: (t) =>
              t.assignmentId.equals(assignmentId) &
              t.studentId.equals(caller.userId),
        );
        throw SubmissionRejectedException(
          reason: any == null
              ? SubmissionRejectReason.testNotStarted
              : SubmissionRejectReason.alreadySubmitted,
        );
      }
    }

    final snapshot =
        testAttempt?.answerKeySnapshotJson ??
        (gradeQuestions.isEmpty ? null : AutoGrader.snapshot(gradeQuestions));
    final snapshotQuestions = AutoGrader.readSnapshot(snapshot, multiSelect);
    final graded = snapshotQuestions == null
        ? null
        : AutoGrader.grade(questions: snapshotQuestions, answers: answerMap);
    final late = _isLate(
      EduboxServices.configFor(session).learning.lateGrace,
      assignment,
      testAttempt,
      now,
    );
    final answersJson = AutoGrader.encodeAnswers(answerMap);

    if (testAttempt != null) {
      final updated = await Submission.db.updateRow(
        session,
        testAttempt.copyWith(
          clientSubmissionId: id,
          status: graded == null
              ? SubmissionStatus.gradingFailed
              : SubmissionStatus.graded,
          answersJson: answersJson,
          score: graded?.score,
          maxScore: graded?.maxScore,
          late: late,
          submittedAt: now,
          gradedAt: graded == null ? null : now,
          gradedBy: graded == null ? null : GradedBy.auto,
          failureReason: graded == null
              ? 'Không đọc được đáp án của bài tập.'
              : null,
          updatedAt: now,
        ),
      );
      return _result(updated);
    }

    final created = await Submission.db.insertRow(
      session,
      Submission(
        assignmentId: assignmentId,
        studentId: caller.userId,
        clientSubmissionId: id,
        status: graded == null
            ? SubmissionStatus.gradingFailed
            : SubmissionStatus.graded,
        answersJson: answersJson,
        answerKeySnapshotJson: snapshot,
        answerKeyVersion: exercise.answerKeyVersion,
        score: graded?.score,
        maxScore: graded?.maxScore,
        late: false,
        submittedAt: now,
        gradedAt: graded == null ? null : now,
        gradedBy: graded == null ? null : GradedBy.auto,
        failureReason: graded == null
            ? 'Không đọc được đáp án của bài tập.'
            : null,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return _result(created);
  }

  /// The calling student's latest submission for one assignment.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  Future<SubmissionResult?> forAssignment(
    Session session, {
    required int assignmentId,
  }) async {
    final caller = await requireRole(session, UserRole.student);
    final assignment = await Assignment.db.findById(session, assignmentId);
    if (assignment == null ||
        !await LearningAccess.studentInClass(
          session,
          studentId: caller.userId,
          classId: assignment.classId,
        )) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final row = await Submission.db.findFirstRow(
      session,
      where: (t) =>
          t.assignmentId.equals(assignmentId) &
          t.studentId.equals(caller.userId),
      orderByList: (t) => [t.updatedAt.desc(), t.id.desc()],
    );
    return row == null ? null : _result(row);
  }

  /// Re-runs grading with the exercise's current answer key.
  ///
  /// Allowed: the teacher owning the assignment's class. Denied: every other
  /// caller.
  Future<SubmissionResult> regrade(
    Session session, {
    required int submissionId,
  }) async {
    final caller = await requireRole(session, UserRole.teacher);
    final submission = await Submission.db.findById(session, submissionId);
    if (submission == null) {
      throw SubmissionRejectedException(
        reason: SubmissionRejectReason.notFound,
      );
    }
    final assignment = await Assignment.db.findById(
      session,
      submission.assignmentId,
    );
    if (assignment == null || assignment.teacherId != caller.userId) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final exercise = await Exercise.db.findById(session, assignment.exerciseId);
    if (exercise == null) {
      throw SubmissionRejectedException(
        reason: SubmissionRejectReason.assignmentChanged,
      );
    }
    final questions = await ExerciseQueries.questions(session, exercise.id!);
    final gradeQuestions = ExerciseQueries.gradeQuestions(questions);
    final answers = AutoGrader.decodeAnswers(submission.answersJson);
    final graded = gradeQuestions.isEmpty
        ? null
        : AutoGrader.grade(questions: gradeQuestions, answers: answers);
    final now = EduboxServices.now();
    final updated = await Submission.db.updateRow(
      session,
      submission.copyWith(
        status: graded == null
            ? SubmissionStatus.gradingFailed
            : SubmissionStatus.graded,
        score: graded?.score,
        maxScore: graded?.maxScore,
        answerKeySnapshotJson: gradeQuestions.isEmpty
            ? null
            : AutoGrader.snapshot(gradeQuestions),
        answerKeyVersion: exercise.answerKeyVersion,
        gradedAt: graded == null ? null : now,
        gradedBy: graded == null ? null : GradedBy.auto,
        failureReason: graded == null
            ? 'Bài tập chưa có đáp án để chấm.'
            : null,
        updatedAt: now,
      ),
    );
    return _result(updated);
  }

  static bool _isLate(
    Duration grace,
    Assignment assignment,
    Submission? attempt,
    DateTime now,
  ) {
    if (assignment.type != AssignmentType.test) return false;
    final startedAt = attempt?.startedAt;
    final limit = assignment.timeLimitSec;
    if (startedAt == null || limit == null) return true;
    return now.isAfter(
      startedAt.add(Duration(seconds: limit)).add(grace),
    );
  }

  static SubmissionResult _result(Submission row) => SubmissionResult(
    id: row.id!,
    assignmentId: row.assignmentId,
    clientSubmissionId: row.clientSubmissionId,
    status: row.status,
    score: row.score,
    maxScore: row.maxScore,
    late: row.late,
    startedAt: row.startedAt,
    submittedAt: row.submittedAt,
    gradedAt: row.gradedAt,
    gradedBy: row.gradedBy,
    failureReason: row.failureReason,
    answers: [
      for (final entry in AutoGrader.decodeAnswers(row.answersJson).entries)
        SubmittedAnswer(
          questionId: entry.key,
          selectedPositions: entry.value,
        ),
    ],
  );
}
