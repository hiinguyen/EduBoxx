import 'package:serverpod/serverpod.dart';

import '../authz/edubox_endpoint.dart';
import '../authz/guard.dart';
import '../generated/protocol.dart';
import '../learning/access.dart';

/// The teacher's Sổ điểm: one class, its students, assignments and cells.
class ResultsEndpoint extends EduboxEndpoint {
  /// Read-only gradebook for one of the teacher's own classes.
  ///
  /// Allowed: the owning teacher. Denied: student, parent, other teacher, not
  /// set up, unauthenticated.
  Future<ClassResults> classResults(
    Session session, {
    required int classId,
  }) async {
    final caller = await requireRole(session, UserRole.teacher);
    final schoolClass = await LearningAccess.teacherClass(
      session,
      teacherId: caller.userId,
      classId: classId,
    );
    if (schoolClass == null) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final members = await ClassMember.db.find(
      session,
      where: (t) => t.classId.equals(classId),
    );
    final studentIds = members.map((m) => m.studentId).toSet();
    final students = studentIds.isEmpty
        ? const <EduboxUser>[]
        : await EduboxUser.db.find(
            session,
            where: (t) => t.id.inSet(studentIds),
            orderByList: (t) => [t.name.asc()],
          );
    final assignments = await Assignment.db.find(
      session,
      where: (t) => t.classId.equals(classId),
      orderByList: (t) => [t.createdAt.asc(), t.id.asc()],
    );
    final assignmentIds = assignments.map((a) => a.id!).toSet();
    final submissions = assignmentIds.isEmpty
        ? const <Submission>[]
        : await Submission.db.find(
            session,
            where: (t) => t.assignmentId.inSet(assignmentIds),
          );
    return ClassResults(
      classId: classId,
      className: schoolClass.name,
      students: [
        for (final student in students)
          ResultStudent(id: student.id!, name: student.name),
      ],
      assignments: [
        for (final assignment in assignments)
          ResultAssignment(
            id: assignment.id!,
            title: assignment.title,
            type: assignment.type,
            dueAt: assignment.dueAt,
            timeLimitSec: assignment.timeLimitSec,
          ),
      ],
      cells: [
        for (final assignment in assignments)
          for (final student in students)
            ?_cell(assignment, student, submissions),
      ],
    );
  }

  static ResultCell? _cell(
    Assignment assignment,
    EduboxUser student,
    List<Submission> submissions,
  ) {
    final matches = submissions
        .where(
          (s) => s.assignmentId == assignment.id && s.studentId == student.id,
        )
        .toList();
    if (matches.isEmpty) return null;
    matches.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final latest = matches.first;
    return ResultCell(
      studentId: student.id!,
      assignmentId: assignment.id!,
      submissionId: latest.id,
      status: latest.status,
      score: latest.score,
      maxScore: latest.maxScore,
      late: latest.late,
      clientSubmissionId: latest.clientSubmissionId,
    );
  }
}
