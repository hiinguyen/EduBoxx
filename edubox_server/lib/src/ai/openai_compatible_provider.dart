import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/edubox_config.dart';
import 'ai_provider.dart';

/// An OpenAI-compatible chat-completions client. It works against OpenRouter,
/// OpenCode Go, or any other compatible gateway; the base URL and model come
/// from server config, never from the app.
class OpenAiCompatibleProvider implements AiProvider {
  OpenAiCompatibleProvider({required this.config, http.Client? client})
    : _client = client ?? http.Client();

  final AiConfig config;
  final http.Client _client;

  @override
  Stream<String> streamReply({
    required String model,
    required String systemPrompt,
    required List<AiTurn> history,
    required String sessionId,
  }) async* {
    final base = config.baseUrl.toString().replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.parse('$base/chat/completions');
    final request = http.Request('POST', uri)
      ..headers.addAll({
        'Authorization': 'Bearer ${config.apiKey}',
        'Content-Type': 'application/json',
        'Accept': 'text/event-stream',
        'User-Agent': 'EduBox/1.0',
        'x-opencode-session': sessionId,
      })
      ..body = jsonEncode({
        'model': model,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          for (final turn in history)
            {'role': turn.role, 'content': turn.content},
        ],
        'stream': true,
        'temperature': 0.4,
        'max_tokens': 700,
      });

    final http.StreamedResponse response;
    try {
      response = await _client.send(request).timeout(config.requestTimeout);
    } on TimeoutException {
      throw const AiProviderException('The provider timed out.');
    } catch (error) {
      throw AiProviderException('The provider is unreachable: $error');
    }

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw AiProviderException(
        'Provider returned ${response.statusCode}: '
        '${body.length > 500 ? body.substring(0, 500) : body}',
        statusCode: response.statusCode,
      );
    }

    try {
      await for (final line
          in response.stream
              .transform(utf8.decoder)
              .transform(const LineSplitter())) {
        if (!line.startsWith('data:')) continue;
        final data = line.substring(5).trim();
        if (data.isEmpty) continue;
        if (data == '[DONE]') return;
        final Object? decoded;
        try {
          decoded = jsonDecode(data);
        } on FormatException {
          continue;
        }
        if (decoded is! Map<String, Object?>) continue;
        final choices = decoded['choices'];
        if (choices is! List || choices.isEmpty) continue;
        final choice = choices.first;
        if (choice is! Map<String, Object?>) continue;
        final delta = choice['delta'];
        if (delta is! Map<String, Object?>) continue;
        final content = delta['content'];
        if (content is String && content.isNotEmpty) yield content;
      }
    } on TimeoutException {
      throw const AiProviderException('The provider stream timed out.');
    } catch (error) {
      if (error is AiProviderException) rethrow;
      throw AiProviderException('The provider stream failed: $error');
    }
  }
}
