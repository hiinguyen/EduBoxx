import 'dart:async';

import 'ai_provider.dart';

/// Deterministic stream used by tests and by the local stack when no AI key
/// is configured. It still observes streaming so the app path is exercised.
class MockAiProvider implements AiProvider {
  MockAiProvider({this.chunkDelay = const Duration(milliseconds: 15)});

  final Duration chunkDelay;

  /// The last system prompt this mock received (tests assert scope/grade).
  String? lastSystemPrompt;
  String? lastSessionId;
  List<AiTurn> lastHistory = const [];

  @override
  Stream<String> streamReply({
    required String model,
    required String systemPrompt,
    required List<AiTurn> history,
    required String sessionId,
  }) async* {
    lastSystemPrompt = systemPrompt;
    lastSessionId = sessionId;
    lastHistory = history;
    final question = history.isEmpty ? '' : history.last.content;
    final chunks = [
      'Mình cùng xem câu hỏi này nhé. ',
      if (question.isEmpty)
        'Em hãy nêu rõ môn học và điều em muốn hiểu.'
      else
        'Trước hết, em thử tóm tắt ý chính của câu hỏi, '
            'rồi mình đi từng bước.',
      '\n\nĐây là gợi ý từ gia sư EduBox, không phải đáp án của bài kiểm tra.',
    ];
    for (final chunk in chunks) {
      if (chunkDelay > Duration.zero) await Future<void>.delayed(chunkDelay);
      yield chunk;
    }
  }
}
