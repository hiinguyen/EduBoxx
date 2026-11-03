/// Provider-neutral AI-tutor interface. The only implementation used by the
/// server is OpenAI-compatible; tests inject [MockAiProvider].
library;

/// One prior turn sent to the model.
class AiTurn {
  const AiTurn({required this.role, required this.content});

  final String role;
  final String content;
}

/// Streams the tutor's answer as incremental text chunks.
abstract interface class AiProvider {
  Stream<String> streamReply({
    required String model,
    required String systemPrompt,
    required List<AiTurn> history,
    required String sessionId,
  });
}

class AiProviderException implements Exception {
  const AiProviderException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AiProviderException($statusCode: $message)';
}
