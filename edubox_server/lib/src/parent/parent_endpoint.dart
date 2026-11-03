import 'package:serverpod/serverpod.dart';

import '../authz/edubox_endpoint.dart';
import '../authz/guard.dart';
import '../generated/protocol.dart';
import '../tutor/tutor_service.dart';

/// Read-only parent view of the linked child. Parents have no write method
/// anywhere in the API.
class ParentEndpoint extends EduboxEndpoint {
  /// The linked child's results and AI chats.
  ///
  /// Allowed: parent. Denied: student, teacher, not set up, unauthenticated.
  Future<ParentSummary> summary(Session session) async {
    final caller = await requireRole(session, UserRole.parent);
    final childId = caller.user.linkedStudentId;
    if (childId == null) {
      return ParentSummary(
        linkedStudentName: caller.user.linkedStudentName,
        className: null,
        results: const [],
        chats: const [],
      );
    }
    final child = await EduboxUser.db.findById(session, childId);
    if (child == null) {
      return ParentSummary(
        linkedStudentName: caller.user.linkedStudentName,
        className: null,
        results: const [],
        chats: const [],
      );
    }
    final memberships = await ClassMember.db.find(
      session,
      where: (t) => t.studentId.equals(childId),
    );
    final classIds = memberships.map((m) => m.classId).toSet();
    final classes = classIds.isEmpty
        ? const <SchoolClass>[]
        : await SchoolClass.db.find(
            session,
            where: (t) => t.id.inSet(classIds),
            orderByList: (t) => [t.gradeLevel.asc(), t.name.asc()],
          );
    final submissions = await Submission.db.find(
      session,
      where: (t) => t.studentId.equals(childId),
      orderByList: (t) => [t.submittedAt.desc(), t.id.desc()],
    );
    final assignmentIds = submissions.map((s) => s.assignmentId).toSet();
    final assignments = assignmentIds.isEmpty
        ? const <Assignment>[]
        : await Assignment.db.find(
            session,
            where: (t) => t.id.inSet(assignmentIds),
          );
    final assignmentById = {for (final a in assignments) a.id!: a};
    final chats = await AiChat.db.find(
      session,
      where: (t) => t.studentId.equals(childId),
      orderByList: (t) => [t.updatedAt.desc(), t.id.desc()],
    );
    return ParentSummary(
      linkedStudentName: child.name,
      className: classes.isEmpty ? null : classes.first.name,
      results: [
        for (final submission in submissions)
          if (assignmentById[submission.assignmentId] case final assignment?)
            ParentResultEntry(
              assignmentId: assignment.id!,
              title: assignment.title,
              type: assignment.type,
              dueAt: assignment.dueAt,
              submittedAt: submission.submittedAt,
              status: submission.status,
              score: submission.score,
              maxScore: submission.maxScore,
              late: submission.late,
            ),
      ],
      chats: [
        for (final chat in chats)
          await TutorService.summary(
            session,
            chat: chat,
            studentName: child.name,
          ),
      ],
    );
  }

  /// The linked child's AI chats, newest first.
  ///
  /// Allowed: parent. Denied: student, teacher, not set up, unauthenticated.
  Future<List<TutorChatSummary>> chats(Session session) async {
    final caller = await requireRole(session, UserRole.parent);
    final childId = caller.user.linkedStudentId;
    if (childId == null) return const [];
    final child = await EduboxUser.db.findById(session, childId);
    final rows = await AiChat.db.find(
      session,
      where: (t) => t.studentId.equals(childId),
      orderByList: (t) => [t.updatedAt.desc(), t.id.desc()],
    );
    return [
      for (final chat in rows)
        await TutorService.summary(
          session,
          chat: chat,
          studentName: child?.name,
        ),
    ];
  }

  /// One full read-only transcript of the linked child.
  ///
  /// Allowed: parent. Denied: student, teacher, not set up, unauthenticated.
  Future<TutorChatDetail> chat(
    Session session, {
    required int chatId,
  }) async {
    final caller = await requireRole(session, UserRole.parent);
    final childId = caller.user.linkedStudentId;
    final chat = await AiChat.db.findById(session, chatId);
    if (childId == null || chat == null || chat.studentId != childId) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    return TutorService.detail(session, chat: chat);
  }
}
