import 'package:serverpod/serverpod.dart';

import '../authz/edubox_endpoint.dart';
import '../authz/guard.dart';
import '../generated/protocol.dart';
import '../learning/access.dart';
import '../services/edubox_services.dart';

/// Lesson completion for the calling student.
class ProgressEndpoint extends EduboxEndpoint {
  /// Marks an approved content item of one of the student's classes complete.
  /// Idempotent: a second call updates the timestamp and adds no row.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  Future<ProgressResult> markComplete(
    Session session, {
    required int contentId,
  }) async {
    final caller = await requireRole(session, UserRole.student);
    final content = await ContentRecord.db.findById(session, contentId);
    if (content == null ||
        !await LearningAccess.studentSeesContent(
          session,
          studentId: caller.userId,
          content: content,
        )) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final now = EduboxServices.now();
    final existing = await ProgressEntry.db.findFirstRow(
      session,
      where: (t) =>
          t.studentId.equals(caller.userId) & t.contentId.equals(contentId),
    );
    final row = existing == null
        ? await ProgressEntry.db.insertRow(
            session,
            ProgressEntry(
              studentId: caller.userId,
              contentId: contentId,
              status: 'completed',
              updatedAt: now,
            ),
          )
        : await ProgressEntry.db.updateRow(
            session,
            existing.copyWith(status: 'completed', updatedAt: now),
          );
    return ProgressResult(
      contentId: contentId,
      status: row.status,
      updatedAt: row.updatedAt,
    );
  }

  /// The calling student's completed lessons.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  Future<List<ProgressResult>> mine(Session session) async {
    final caller = await requireRole(session, UserRole.student);
    final rows = await ProgressEntry.db.find(
      session,
      where: (t) => t.studentId.equals(caller.userId),
      orderByList: (t) => [t.updatedAt.desc()],
    );
    return [
      for (final row in rows)
        ProgressResult(
          contentId: row.contentId,
          status: row.status,
          updatedAt: row.updatedAt,
        ),
    ];
  }
}
