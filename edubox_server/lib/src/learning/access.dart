import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Small authorization/visibility helpers shared by the learning endpoints.
abstract final class LearningAccess {
  static Future<Set<int>> studentClassIds(
    Session session,
    int studentId,
  ) async {
    final rows = await ClassMember.db.find(
      session,
      where: (t) => t.studentId.equals(studentId),
    );
    return rows.map((row) => row.classId).toSet();
  }

  static Future<bool> studentInClass(
    Session session, {
    required int studentId,
    required int classId,
  }) async {
    final row = await ClassMember.db.findFirstRow(
      session,
      where: (t) => t.studentId.equals(studentId) & t.classId.equals(classId),
    );
    return row != null;
  }

  static Future<SchoolClass?> teacherClass(
    Session session, {
    required int teacherId,
    required int classId,
  }) => SchoolClass.db.findFirstRow(
    session,
    where: (t) => t.id.equals(classId) & t.teacherId.equals(teacherId),
  );

  static Future<ContentRecord?> ownedContent(
    Session session, {
    required int teacherId,
    required int contentId,
  }) => ContentRecord.db.findFirstRow(
    session,
    where: (t) => t.id.equals(contentId) & t.ownerTeacherId.equals(teacherId),
  );

  /// True when the content is `approved` and scoped to a class the student is
  /// a member of.
  static Future<bool> studentSeesContent(
    Session session, {
    required int studentId,
    required ContentRecord content,
  }) async {
    if (content.status != ContentStatus.approved) return false;
    final memberships = await studentClassIds(session, studentId);
    if (memberships.isEmpty) return false;
    final scope = await ContentClass.db.find(
      session,
      where: (t) =>
          t.contentId.equals(content.id!) & t.classId.inSet(memberships),
    );
    return scope.isNotEmpty;
  }

  /// True when the caller may read the content's file: its owning teacher or
  /// a student it is approved for.
  static Future<bool> canReadFile(
    Session session, {
    required EduboxCallerView caller,
    required ContentRecord content,
  }) async {
    if (content.ownerTeacherId == caller.userId) return true;
    if (caller.role == UserRole.student) {
      return studentSeesContent(
        session,
        studentId: caller.userId,
        content: content,
      );
    }
    return false;
  }

  /// The class ids in a teacher's own classes.
  static Future<Set<int>> teacherClassIds(
    Session session,
    int teacherId,
  ) async {
    final rows = await SchoolClass.db.find(
      session,
      where: (t) => t.teacherId.equals(teacherId),
    );
    return rows.map((row) => row.id!).toSet();
  }
}

/// The narrow caller shape access helpers need, so this file does not depend
/// on the authz layer's concrete class.
class EduboxCallerView {
  const EduboxCallerView({required this.userId, required this.role});

  final int userId;
  final UserRole role;
}
