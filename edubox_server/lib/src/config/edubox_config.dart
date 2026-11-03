import 'dart:io';

import 'package:yaml/yaml.dart';

/// EduBox settings that are not secrets, read from the `edubox:` section of
/// the run-mode file `config/<runMode>.yaml`, then overridden by environment
/// variables (the compose `server` and `seed` services use the overrides).
///
/// Secrets (MinIO keys, auth peppers, the AI key) live in the git-ignored
/// `config/passwords.yaml` or in environment variables instead.
class EduboxConfig {
  const EduboxConfig({
    required this.storage,
    required this.e2eControl,
    required this.ai,
    required this.learning,
  });

  /// Object storage settings (MinIO locally).
  final StorageConfig storage;

  /// True only for the compose `e2e` server (the `development` run mode) and
  /// the `test` run mode: enables the e2e control route (see
  /// docs/build/phase-1/contract.md). Any other run mode, including
  /// `production` and `staging`, always resolves this to false even when the
  /// file or `EDUBOX_E2E_CONTROL` asks for true.
  final bool e2eControl;

  /// AI-tutor provider settings.
  final AiConfig ai;

  /// Content upload and grading limits.
  final LearningConfig learning;

  EduboxConfig copyWith({AiConfig? ai, LearningConfig? learning}) =>
      EduboxConfig(
        storage: storage,
        e2eControl: e2eControl,
        ai: ai ?? this.ai,
        learning: learning ?? this.learning,
      );

  /// Run modes in which the e2e control route may be enabled. The compose
  /// `e2e` server runs the `development` mode; Serverpod test tools run
  /// `test`. Everything else is rejected.
  static const Set<String> e2eControlRunModes = {'development', 'test'};

  /// Loads the config for [runMode] from [serverDirectory]/config.  ///
  /// [passwords] is the run mode's password map; the AI key may come from
  /// there or from the environment (the local compose stack passes the
  /// developer's `OPENCODE_API_KEY`).
  static EduboxConfig load({
    required String runMode,
    String serverDirectory = '.',
    Map<String, String>? environment,
    Map<String, String?> passwords = const {},
  }) {
    final env = environment ?? Platform.environment;
    final file = File('$serverDirectory/config/$runMode.yaml');
    final yaml = file.existsSync() ? loadYaml(file.readAsStringSync()) : null;
    final section = yaml is YamlMap ? yaml['edubox'] : null;
    final storage = section is YamlMap ? section['storage'] : null;
    final ai = section is YamlMap ? section['ai'] : null;
    final learning = section is YamlMap ? section['learning'] : null;

    String read(
      YamlMap? map,
      String key,
      String envName, {
      String? fallback,
    }) {
      final override = env[envName];
      if (override != null && override.isNotEmpty) return override;
      final value = map?[key];
      if (value is String && value.isNotEmpty) return value;
      if (fallback != null) return fallback;
      throw StateError(
        'Missing EduBox setting edubox.storage.$key in '
        'config/$runMode.yaml (or environment variable $envName).',
      );
    }

    int readInt(
      YamlMap? map,
      String key,
      String envName, {
      required int fallback,
    }) {
      final override = env[envName];
      if (override != null && override.isNotEmpty) {
        return int.parse(override);
      }
      final value = map?[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      return fallback;
    }

    final storageMap = storage is YamlMap ? storage : null;
    final e2eOverride = env['EDUBOX_E2E_CONTROL'];
    final e2eValue = section is YamlMap ? section['e2eControl'] : null;
    final e2eConfigured = e2eOverride != null
        ? e2eOverride == 'true'
        : e2eValue == true;

    final aiMap = ai is YamlMap ? ai : null;
    final learningMap = learning is YamlMap ? learning : null;
    final aiKey =
        env['EDUBOX_AI_API_KEY'] ??
        env['OPENCODE_API_KEY'] ??
        passwords['aiApiKey'] ??
        passwords['openRouterApiKey'] ??
        '';

    return EduboxConfig(
      storage: StorageConfig(
        endpoint: Uri.parse(
          read(storageMap, 'endpoint', 'EDUBOX_STORAGE_ENDPOINT'),
        ),
        publicEndpoint: Uri.parse(
          read(storageMap, 'publicEndpoint', 'EDUBOX_STORAGE_PUBLIC_ENDPOINT'),
        ),
        bucket: read(storageMap, 'bucket', 'EDUBOX_STORAGE_BUCKET'),
        region: read(storageMap, 'region', 'EDUBOX_STORAGE_REGION'),
      ),
      // The run-mode gate comes first: an environment override can enable
      // the route in development/test, but never in production/staging.
      e2eControl: e2eControlRunModes.contains(runMode) && e2eConfigured,
      ai: AiConfig(
        baseUrl: Uri.parse(
          read(
            aiMap,
            'baseUrl',
            'EDUBOX_AI_BASE_URL',
            fallback: 'https://opencode.ai/inference/go/openai/v1',
          ),
        ),
        model: read(
          aiMap,
          'model',
          'EDUBOX_AI_MODEL',
          fallback: 'deepseek-v4.1-flash',
        ),
        apiKey: aiKey,
        // Tests force the deterministic mock even when a developer key is
        // present in the environment.
        mock:
            (env['EDUBOX_AI_MOCK'] ?? (aiMap?['mock'] == true).toString()) ==
            'true',
        dailyLimit: readInt(
          aiMap,
          'dailyLimit',
          'EDUBOX_AI_DAILY_LIMIT',
          fallback: 30,
        ),
        requestTimeout: Duration(
          seconds: readInt(
            aiMap,
            'timeoutSeconds',
            'EDUBOX_AI_TIMEOUT_SECONDS',
            fallback: 60,
          ),
        ),
      ),
      learning: LearningConfig(
        maxEbookBytes: readInt(
          learningMap,
          'maxEbookBytes',
          'EDUBOX_MAX_EBOOK_BYTES',
          fallback: 20 * 1024 * 1024,
        ),
        maxVideoBytes: readInt(
          learningMap,
          'maxVideoBytes',
          'EDUBOX_MAX_VIDEO_BYTES',
          fallback: 120 * 1024 * 1024,
        ),
        lateGrace: Duration(
          seconds: readInt(
            learningMap,
            'lateGraceSeconds',
            'EDUBOX_LATE_GRACE_SECONDS',
            fallback: 60,
          ),
        ),
      ),
    );
  }
}

/// S3-compatible storage settings. Credentials are the passwords
/// `storageAccessKey` and `storageSecretKey`.
class StorageConfig {
  const StorageConfig({
    required this.endpoint,
    required this.publicEndpoint,
    required this.bucket,
    required this.region,
  });

  /// Where the server reaches the store, e.g. `http://localhost:9000` for
  /// host-side tests and `http://minio:9000` inside compose.
  final Uri endpoint;

  /// The host that signed URLs are issued for, e.g. `http://10.0.2.2:9000`
  /// for the Android emulator. The signature covers this host.
  final Uri publicEndpoint;

  /// The private bucket for this run mode (created by `minio-init`).
  final String bucket;

  /// Signing region; MinIO accepts `us-east-1`.
  final String region;
}

/// The AI tutor's provider settings. The API key is server-only.
class AiConfig {
  const AiConfig({
    required this.baseUrl,
    required this.model,
    required this.apiKey,
    required this.mock,
    required this.dailyLimit,
    required this.requestTimeout,
  });

  /// OpenAI-compatible base URL (no trailing `/chat/completions`).
  final Uri baseUrl;
  final String model;
  final String apiKey;

  /// True when no provider call may be made (tests and keyless local runs).
  final bool mock;
  final int dailyLimit;
  final Duration requestTimeout;
}

/// Upload sizes and the late-submission grace window.
class LearningConfig {
  const LearningConfig({
    required this.maxEbookBytes,
    required this.maxVideoBytes,
    required this.lateGrace,
  });

  final int maxEbookBytes;
  final int maxVideoBytes;
  final Duration lateGrace;
}
