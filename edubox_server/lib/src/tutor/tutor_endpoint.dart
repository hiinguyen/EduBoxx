import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../ai/ai_provider.dart';
import '../authz/edubox_endpoint.dart';
import '../authz/guard.dart';
import '../generated/protocol.dart';
import '../learning/access.dart';
import '../services/edubox_services.dart';
import 'tutor_service.dart';

/// The scoped, rate-limited, logged AI study tutor.
class TutorEndpoint extends EduboxEndpoint {
  /// Preflight state: the student's subjects, today's budget, and whether a
  /// timed test currently locks the tutor.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  Future<TutorState> state(Session session) async {
    final caller = await requireRole(session, UserRole.student);
    final config = EduboxServices.configFor(session);
    final now = EduboxServices.now();
    final subjects = await TutorService.subjects(session, caller.userId);
    final used = await TutorService.usedToday(session, caller.userId, now);
    final active = await TutorService.activeTest(session, caller.userId);
    return TutorState(
      subjects: [for (final subject in subjects) subject.toDto()],
      usedToday: used,
      dailyLimit: config.ai.dailyLimit,
      remainingToday: used >= config.ai.dailyLimit
          ? 0
          : config.ai.dailyLimit - used,
      pausedForTest: active != null,
      activeTestAssignmentId: active?.assignmentId,
    );
  }

  /// The calling student's past tutor conversations, newest first.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  Future<List<TutorChatSummary>> chats(Session session) async {
    final caller = await requireRole(session, UserRole.student);
    final rows = await AiChat.db.find(
      session,
      where: (t) => t.studentId.equals(caller.userId),
      orderByList: (t) => [t.updatedAt.desc(), t.id.desc()],
    );
    return [
      for (final chat in rows) await TutorService.summary(session, chat: chat),
    ];
  }

  /// One of the calling student's transcripts.
  ///
  /// Allowed: the owning student. Denied: every other caller.
  Future<TutorChatDetail> chat(
    Session session, {
    required int chatId,
  }) async {
    final caller = await requireRole(session, UserRole.student);
    final chat = await AiChat.db.findById(session, chatId);
    if (chat == null || chat.studentId != caller.userId) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    return TutorService.detail(session, chat: chat);
  }

  /// Streams one tutor answer. Subject scope, the active-test lockout and
  /// the daily limit are enforced before anything is sent to the provider;
  /// both messages are written by the server only.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  Stream<TutorEvent> ask(
    Session session, {
    required String subject,
    required String message,
    int? chatId,
  }) async* {
    final caller = await requireRole(session, UserRole.student);
    final config = EduboxServices.configFor(session);
    final now = EduboxServices.now();
    final student = await EduboxUser.db.findById(session, caller.userId);
    final available = await TutorService.subjects(session, caller.userId);
    if (available.isEmpty) {
      yield TutorEvent(
        type: TutorEventType.error,
        errorCode: TutorErrorCode.noClass,
      );
      return;
    }
    final requested = subject.trim();
    final match = available.where(
      (item) => item.subject.toLowerCase() == requested.toLowerCase(),
    );
    if (requested.isEmpty || match.isEmpty) {
      yield TutorEvent(
        type: TutorEventType.error,
        errorCode: TutorErrorCode.subjectNotAllowed,
      );
      return;
    }
    final scope = match.first;
    final activeTest = await TutorService.activeTest(session, caller.userId);
    if (activeTest != null) {
      yield TutorEvent(
        type: TutorEventType.error,
        errorCode: TutorErrorCode.lockedDuringTest,
      );
      return;
    }
    final question = message.trim();
    if (question.isEmpty) {
      yield TutorEvent(
        type: TutorEventType.error,
        errorCode: TutorErrorCode.emptyMessage,
      );
      return;
    }
    if (question.length > TutorService.maxMessageLength) {
      yield TutorEvent(
        type: TutorEventType.error,
        errorCode: TutorErrorCode.emptyMessage,
      );
      return;
    }

    AiChat? chat;
    if (chatId != null) {
      final existing = await AiChat.db.findById(session, chatId);
      if (existing == null || existing.studentId != caller.userId) {
        throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
      }
      if (existing.subject.toLowerCase() != scope.subject.toLowerCase()) {
        yield TutorEvent(
          type: TutorEventType.error,
          errorCode: TutorErrorCode.subjectNotAllowed,
        );
        return;
      }
      chat = existing;
    }

    final consumed = await TutorService.consumeOne(
      session,
      studentId: caller.userId,
      now: now,
      limit: config.ai.dailyLimit,
    );
    if (consumed == null) {
      yield TutorEvent(
        type: TutorEventType.error,
        errorCode: TutorErrorCode.dailyLimitReached,
      );
      return;
    }

    chat ??= await TutorService.createChat(
      session,
      studentId: caller.userId,
      classId: scope.classId,
      subject: scope.subject,
      firstMessage: question,
    );
    final historyRows = await AiMessage.db.find(
      session,
      where: (t) => t.chatId.equals(chat!.id!),
      orderByList: (t) => [t.position.desc()],
      limit: TutorService.historyLimit,
    );
    final history = [
      for (final row in historyRows.reversed)
        AiTurn(
          role: row.role == ChatRole.student ? 'user' : 'assistant',
          content: row.content,
        ),
      AiTurn(role: 'user', content: question),
    ];
    await TutorService.appendMessage(
      session,
      chat: chat,
      role: ChatRole.student,
      content: question,
    );

    final provider = EduboxServices.aiFor(session);
    final prompt = TutorService.systemPrompt(
      subject: scope.subject,
      gradeLevel: scope.gradeLevel,
      studentName: student?.name ?? 'học sinh',
    );
    final chatIdValue = chat.id!;
    final answer = StringBuffer();
    var providerFailed = false;
    try {
      await for (final chunk in provider.streamReply(
        model: config.ai.model,
        systemPrompt: prompt,
        history: history,
        sessionId: 'edubox-${caller.userId}-$chatIdValue',
      )) {
        answer.write(chunk);
        yield TutorEvent(
          type: TutorEventType.delta,
          chatId: chatIdValue,
          delta: chunk,
        );
      }
    } catch (error, stackTrace) {
      providerFailed = true;
      TutorService.logFailure('provider stream', error, stackTrace);
    }

    final text = answer.toString().trim();
    if (text.isNotEmpty) {
      try {
        await TutorService.appendMessage(
          session,
          chat: chat,
          role: ChatRole.tutor,
          content: text,
        );
      } catch (error, stackTrace) {
        TutorService.logFailure('saving tutor message', error, stackTrace);
      }
    }
    if (providerFailed || text.isEmpty) {
      yield TutorEvent(
        type: TutorEventType.error,
        chatId: chatIdValue,
        errorCode: TutorErrorCode.providerUnavailable,
      );
      return;
    }
    yield TutorEvent(
      type: TutorEventType.done,
      chatId: chatIdValue,
    );
  }

  /// Chats of a student in one of the teacher's own classes.
  ///
  /// Allowed: teacher. Denied: student, parent, unauthenticated.
  Future<List<TutorChatSummary>> classChats(
    Session session, {
    required int studentId,
  }) async {
    final caller = await requireRole(session, UserRole.teacher);
    if (!await _teacherCanReadStudent(session, caller.userId, studentId)) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final student = await EduboxUser.db.findById(session, studentId);
    final rows = await AiChat.db.find(
      session,
      where: (t) => t.studentId.equals(studentId),
      orderByList: (t) => [t.updatedAt.desc(), t.id.desc()],
    );
    return [
      for (final chat in rows)
        await TutorService.summary(
          session,
          chat: chat,
          studentName: student?.name,
        ),
    ];
  }

  /// One read-only transcript for a student in the teacher's class.
  ///
  /// Allowed: teacher. Denied: student, parent, unauthenticated.
  Future<TutorChatDetail> classChat(
    Session session, {
    required int chatId,
  }) async {
    final caller = await requireRole(session, UserRole.teacher);
    final chat = await AiChat.db.findById(session, chatId);
    if (chat == null ||
        !await _teacherCanReadStudent(session, caller.userId, chat.studentId)) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    return TutorService.detail(session, chat: chat);
  }

  static Future<bool> _teacherCanReadStudent(
    Session session,
    int teacherId,
    int studentId,
  ) async {
    final classes = await LearningAccess.teacherClassIds(session, teacherId);
    if (classes.isEmpty) return false;
    final membership = await ClassMember.db.findFirstRow(
      session,
      where: (t) => t.studentId.equals(studentId) & t.classId.inSet(classes),
    );
    return membership != null;
  }
}
