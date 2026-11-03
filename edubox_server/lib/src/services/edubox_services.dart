import 'package:serverpod/serverpod.dart';

import '../ai/ai_provider.dart';
import '../ai/mock_ai_provider.dart';
import '../ai/openai_compatible_provider.dart';
import '../config/edubox_config.dart';
import '../storage/object_store.dart';

/// Per-call access to the server's side services.
///
/// Endpoint instances are created per request, so the factory keeps no
/// request state. Tests replace [aiOverride] and [clockOverride].
abstract final class EduboxServices {
  /// When set, every tutor call uses this provider instead of configuration
  /// (server integration tests).
  static AiProvider? aiOverride;

  /// When set, every server-side timestamp comes from here (timed tests and
  /// the ICT day boundary tests).
  static DateTime Function()? clockOverride;

  /// When set, tests use this config instead of the run-mode files.
  static EduboxConfig? configOverride;

  static EduboxConfig configFor(Session session) =>
      configOverride ??
      EduboxConfig.load(
        runMode: session.serverpod.runMode,
        serverDirectory: session.serverpod.serverDirectory.path,
        passwords: session.passwords,
      );

  static S3ObjectStore storageFor(Session session) {
    final config = configFor(session);
    return S3ObjectStore(
      config: config.storage,
      accessKey: session.passwords['storageAccessKey'] ?? '',
      secretKey: session.passwords['storageSecretKey'] ?? '',
    );
  }

  static AiProvider aiFor(Session session) {
    final override = aiOverride;
    if (override != null) return override;
    final config = configFor(session).ai;
    if (config.mock || config.apiKey.isEmpty) {
      return MockAiProvider();
    }
    return OpenAiCompatibleProvider(config: config);
  }

  /// The server's "now", injectable for tests.
  static DateTime now() => (clockOverride?.call() ?? DateTime.now()).toUtc();

  /// The Asia/Ho_Chi_Minh calendar day of [instant] as `yyyy-MM-dd`.
  static String ictDay(DateTime instant) {
    final local = instant.toUtc().add(const Duration(hours: 7));
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }

  /// Start of the Asia/Ho_Chi_Minh day containing [instant], as UTC.
  static DateTime ictDayStart(DateTime instant) {
    final local = instant.toUtc().add(const Duration(hours: 7));
    final startLocal = DateTime.utc(local.year, local.month, local.day);
    return startLocal.subtract(const Duration(hours: 7));
  }
}
