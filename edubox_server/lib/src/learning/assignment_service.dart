import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Builds the student-facing assignment row from its rows and the student's
/// latest submission.
abstract final class AssignmentQueries {
  static StudentAssignmentState stateOf(Submission? submission) {
    if (submission == null) return StudentAssignmentState.toDo;
    return switch (submission.status) {
      SubmissionStatus.inProgress => StudentAssignmentState.inProgress,
      SubmissionStatus.submitted => StudentAssignmentState.submitted,
      SubmissionStatus.graded => StudentAssignmentState.graded,
      SubmissionStatus.gradingFailed => StudentAssignmentState.gradingFailed,
    };
  }

  static Future<Map<int, Submission>> latestSubmissions(
    Session session, {
    required int studentId,
    required Set<int> assignmentIds,
  }) async {
    if (assignmentIds.isEmpty) return const {};
    final rows = await Submission.db.find(
      session,
      where: (t) =>
          t.studentId.equals(studentId) & t.assignmentId.inSet(assignmentIds),
      orderByList: (t) => [t.updatedAt.desc(), t.id.desc()],
    );
    final result = <int, Submission>{};
    for (final row in rows) {
      result.putIfAbsent(row.assignmentId, () => row);
    }
    return result;
  }

  static Future<StudentAssignmentItem> itemFor(
    Session session, {
    required Assignment assignment,
    required Exercise exercise,
    required ContentRecord content,
    required SchoolClass schoolClass,
    required Submission? submission,
    ContentRecord? lesson,
  }) async {
    return StudentAssignmentItem(
      id: assignment.id!,
      classId: assignment.classId,
      className: schoolClass.name,
      exerciseId: exercise.id!,
      contentId: content.id!,
      title: assignment.title,
      subject: content.subject,
      type: assignment.type,
      dueAt: assignment.dueAt,
      timeLimitSec: assignment.timeLimitSec,
      state: stateOf(submission),
      score: submission?.score,
      maxScore: submission?.maxScore,
      late: submission?.late ?? false,
      submissionId: submission?.id,
      clientSubmissionId: submission?.clientSubmissionId,
      lessonContentId: exercise.lessonContentId,
      lessonTitle: lesson?.title,
    );
  }
}
