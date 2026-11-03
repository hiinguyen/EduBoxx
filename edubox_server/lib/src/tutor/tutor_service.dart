import 'dart:developer' as developer;

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/edubox_services.dart';

/// A tutor subject available to a student, with the class that supplies it.
class AvailableSubject {
  const AvailableSubject({
    required this.classId,
    required this.className,
    required this.subject,
    required this.gradeLevel,
  });

  final int classId;
  final String className;
  final String subject;
  final int gradeLevel;

  TutorSubject toDto() => TutorSubject(
    classId: classId,
    className: className,
    subject: subject,
    gradeLevel: gradeLevel,
  );
}

/// Tutor scoping, usage, and transcript helpers.
abstract final class TutorService {
  static const maxMessageLength = 2000;
  static const historyLimit = 20;

  /// Every subject in the student's classes, de-duplicated by (class, subject).
  static Future<List<AvailableSubject>> subjects(
    Session session,
    int studentId,
  ) async {
    final memberships = await ClassMember.db.find(
      session,
      where: (t) => t.studentId.equals(studentId),
    );
    final classIds = memberships.map((m) => m.classId).toSet();
    if (classIds.isEmpty) return const [];
    final classes = await SchoolClass.db.find(
      session,
      where: (t) => t.id.inSet(classIds),
      orderByList: (t) => [t.gradeLevel.asc(), t.name.asc()],
    );
    final subjects = await ClassSubject.db.find(
      session,
      where: (t) => t.classId.inSet(classIds),
      orderByList: (t) => [t.position.asc()],
    );
    final result = <AvailableSubject>[];
    for (final schoolClass in classes) {
      for (final row in subjects) {
        if (row.classId != schoolClass.id) continue;
        result.add(
          AvailableSubject(
            classId: schoolClass.id!,
            className: schoolClass.name,
            subject: row.subject,
            gradeLevel: schoolClass.gradeLevel,
          ),
        );
      }
    }
    return result;
  }

  /// The active timed test that must lock the tutor, if any.
  static Future<Submission?> activeTest(Session session, int studentId) =>
      Submission.db.findFirstRow(
        session,
        where: (t) =>
            t.studentId.equals(studentId) &
            t.status.equals(SubmissionStatus.inProgress),
        orderByList: (t) => [t.startedAt.desc()],
      );

  static Future<int> usedToday(
    Session session,
    int studentId,
    DateTime now,
  ) async {
    final row = await AiUsage.db.findFirstRow(
      session,
      where: (t) =>
          t.studentId.equals(studentId) &
          t.day.equals(EduboxServices.ictDay(now)),
    );
    return row?.messageCount ?? 0;
  }

  /// Atomically consumes one message from today's budget. Returns the new
  /// count, or null when the limit is already reached. The conditional
  /// upsert makes concurrent requests unable to exceed [limit].
  static Future<int?> consumeOne(
    Session session, {
    required int studentId,
    required DateTime now,
    required int limit,
  }) async {
    final table = AiUsage.t.tableName;
    final studentColumn = AiUsage.t.studentId.columnName;
    final dayColumn = AiUsage.t.day.columnName;
    final countColumn = AiUsage.t.messageCount.columnName;
    final result = await session.db.unsafeQuery(
      'INSERT INTO "$table" ("$studentColumn", "$dayColumn", "$countColumn") '
      'VALUES (@studentId, @day, 1) '
      'ON CONFLICT ("$studentColumn", "$dayColumn") DO UPDATE SET '
      '"$countColumn" = "$table"."$countColumn" + 1 '
      'WHERE "$table"."$countColumn" < @limit '
      'RETURNING "$countColumn"',
      parameters: QueryParameters.named({
        'studentId': studentId,
        'day': EduboxServices.ictDay(now),
        'limit': limit,
      }),
    );
    if (result.isEmpty) return null;
    return result.first.first as int;
  }

  /// The system prompt for one subject/class. It names both the subject and
  /// the grade level, which phase 4's criterion 2 asserts.
  static String systemPrompt({
    required String subject,
    required int gradeLevel,
    required String studentName,
  }) {
    return '''
Bạn là gia sư học tập của EduBox cho học sinh Việt Nam.
Học sinh: $studentName. Môn: $subject. Lớp: $gradeLevel.

Nhiệm vụ:
- Chỉ hỗ trợ học tập trong môn $subject của chương trình lớp $gradeLevel.
- Trả lời bằng tiếng Việt, giọng thân thiện, ngắn gọn, phù hợp lứa tuổi.
- Giải thích từng bước, khuyến khích học sinh tự làm; không đưa đáp án của bài kiểm tra đang làm.
- Viết phân số dạng 1/2, không dùng LaTeX, markdown hoặc ký hiệu trang trí.
- Từ chối lịch sự mọi câu hỏi ngoài phạm vi học tập của môn học này.
- Không yêu cầu thông tin cá nhân, không hướng dẫn vi phạm nội quy nhà trường.
'''
        .trim();
  }

  static Future<AiChat> createChat(
    Session session, {
    required int studentId,
    required int classId,
    required String subject,
    required String firstMessage,
  }) {
    final now = EduboxServices.now();
    return AiChat.db.insertRow(
      session,
      AiChat(
        studentId: studentId,
        subject: subject,
        classId: classId,
        title: _title(firstMessage),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  static Future<TutorChatDetail> detail(
    Session session, {
    required AiChat chat,
  }) async {
    final messages = await AiMessage.db.find(
      session,
      where: (t) => t.chatId.equals(chat.id!),
      orderByList: (t) => [t.position.asc()],
    );
    final student = await EduboxUser.db.findById(session, chat.studentId);
    return TutorChatDetail(
      id: chat.id!,
      subject: chat.subject,
      title: chat.title,
      createdAt: chat.createdAt,
      updatedAt: chat.updatedAt,
      studentName: student?.name,
      messages: [
        for (final message in messages)
          TutorMessage(
            id: message.id!,
            role: message.role,
            content: message.content,
            createdAt: message.createdAt,
          ),
      ],
    );
  }

  static Future<TutorChatSummary> summary(
    Session session, {
    required AiChat chat,
    String? studentName,
  }) async {
    final count = await AiMessage.db.count(
      session,
      where: (t) => t.chatId.equals(chat.id!),
    );
    return TutorChatSummary(
      id: chat.id!,
      subject: chat.subject,
      title: chat.title,
      createdAt: chat.createdAt,
      updatedAt: chat.updatedAt,
      messageCount: count,
      studentName: studentName,
    );
  }

  static Future<void> appendMessage(
    Session session, {
    required AiChat chat,
    required ChatRole role,
    required String content,
  }) async {
    final count = await AiMessage.db.count(
      session,
      where: (t) => t.chatId.equals(chat.id!),
    );
    final now = EduboxServices.now();
    await AiMessage.db.insertRow(
      session,
      AiMessage(
        chatId: chat.id!,
        role: role,
        content: content,
        position: count,
        createdAt: now,
      ),
    );
    await AiChat.db.updateRow(
      session,
      chat.copyWith(updatedAt: now),
    );
  }

  static void logFailure(
    String where,
    Object error, [
    StackTrace? stackTrace,
  ]) {
    developer.log(
      'EduBox tutor failure: $where',
      name: 'EduBox.Tutor',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static String _title(String message) {
    final singleLine = message.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (singleLine.length <= 80) return singleLine;
    return '${singleLine.substring(0, 79)}…';
  }
}
