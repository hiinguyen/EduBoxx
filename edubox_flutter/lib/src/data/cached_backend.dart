import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:edubox_client/edubox_client.dart'
    show
        AssignmentUpsert,
        ClassResults,
        ClassSummary,
        ContentDetail,
        ContentType,
        ExerciseUpsert,
        PingMessage,
        ProfileResult,
        ProfileStatus,
        ProgressResult,
        ParentSummary,
        SignedFileUrl,
        StudentAssignmentDetail,
        StudentAssignmentItem,
        StudentAssignmentList,
        StudentAssignmentState,
        StudentLibrary,
        SubmissionResult,
        SubmissionStatus,
        SubmittedAnswer,
        TeacherAssignmentItem,
        TeacherContentItem,
        TeacherExerciseDetail,
        TeacherExerciseSummary,
        TestStartResult,
        TutorChatDetail,
        TutorChatSummary,
        TutorEvent,
        TutorState,
        UploadTicket,
        UserRole;
import 'package:http/http.dart' as http;

import '../contract/backend.dart';
import '../contract/backend_result.dart';
import '../contract/learning_repositories.dart';
import '../contract/network_controller.dart';
import '../contract/outbox.dart';
import '../contract/repositories.dart';
import '../contract/session.dart';
import '../local/local_store.dart';
import 'content_cache.dart';
import 'edubox_api.dart';
import 'error_mapping.dart';

/// The production [EduBoxBackend]: the server API, the drift cache and the
/// network seam.
///
/// Online it calls the server, saves the snapshot and returns
/// `isStale: false`. Offline or reconnecting it never dials the server: data
/// reads return the snapshot with `isStale: true` or `OfflineNoCacheError`,
/// and `signIn` / `refreshProfile` fail fast with `BackendUnreachableError`.
/// Progress and submission writes go to the outbox first; the sync worker
/// replays them on every reconnect.
class CachedBackend implements EduBoxBackend {
  CachedBackend({
    required this.api,
    required this.store,
    required this.network,
    Outbox? outbox,
    ContentCache? contentCache,
    http.Client? httpClient,
    DateTime Function()? clock,
  }) : outbox = outbox ?? DriftOutbox(store.db),
       contentCache = contentCache ?? UnsupportedContentCache(),
       _http = httpClient ?? http.Client(),
       _ownsHttp = httpClient == null,
       _clock = clock ?? DateTime.now {
    _lastStatus = network.status;
    _networkSub = network.changes.listen(_onNetworkChange);
  }

  final EduBoxApi api;
  final CachedDataStore store;
  final NetworkController network;
  final Outbox outbox;
  final ContentCache contentCache;
  final http.Client _http;
  final bool _ownsHttp;
  final DateTime Function() _clock;

  late NetworkStatus _lastStatus;
  late final StreamSubscription<NetworkStatus> _networkSub;

  /// Completes when the most recent reconnect refresh finishes (tests).
  Future<void> reconnectRefresh = Future.value();

  bool get _online => network.status == NetworkStatus.online;

  @override
  late final AuthRepository auth = _Auth(this);

  @override
  late final ProfileRepository profile = _Profile(this);

  @override
  late final ClassesRepository classes = _Classes(this);

  @override
  late final LibraryRepository library = _Library(this);

  @override
  late final ParentRepository parent = _Parent(this);

  @override
  late final ContentRepository content = _Content(this);

  @override
  late final AssignmentRepository assignments = _Assignments(this);

  @override
  late final TutorRepository tutor = _Tutor(this);

  @override
  late final DiagnosticsRepository diagnostics = _Diagnostics(this);

  @override
  Future<void> dispose() async {
    await _networkSub.cancel();
    if (_ownsHttp) _http.close();
    await api.close();
    await store.close();
  }

  void _onNetworkChange(NetworkStatus status) {
    final wasOffline = _lastStatus != NetworkStatus.online;
    _lastStatus = status;
    if (wasOffline && status == NetworkStatus.online) {
      reconnectRefresh = _refreshAfterReconnect();
    }
  }

  Future<void> _refreshAfterReconnect() async {
    try {
      await assignments.syncOutbox();
      final cached = await store.readSession();
      if (cached == null) return;
      final me = await profile.me();
      final session = me.valueOrNull;
      if (session == null || session.status != ProfileStatus.ready) return;
      switch (session.profile?.role) {
        case UserRole.student:
          await library.library();
          await assignments.studentAssignments();
        case UserRole.teacher:
          await classes.mine();
          await content.teacherList();
          await assignments.teacherAssignments();
        case UserRole.parent:
          await parent.home();
        case null:
          break;
      }
    } catch (error, stackTrace) {
      // A background refresh has no caller to report to; never let it become
      // an uncaught async error in the app zone.
      developer.log(
        'EduBox reconnect refresh failed',
        name: 'EduBox.CachedBackend',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<BackendResult<T>> _guard<T>(
    Future<BackendResult<T>> Function() call,
  ) async {
    try {
      return await call();
    } catch (error) {
      return BackendFailure<T>(mapApiError(error));
    }
  }

  Future<AuthSession> _saveProfile(ProfileResult result, String? email) async {
    final cached = await store.readSession();
    final session = AuthSession(
      signedInEmail:
          result.signedInEmail ?? email ?? cached?.value.signedInEmail ?? '',
      profileResult: result,
    );
    await store.saveSession(session);
    return session;
  }

  Future<BackendError?> _offlineRoleFailure(UserRole role) async {
    final cached = await store.readSession();
    if (cached == null) return const OfflineNoCacheError();
    final session = cached.value;
    if (session.isNotSetUp) return const NotSetUpError();
    if (session.role != role) return const PermissionDeniedError();
    return null;
  }

  Future<void> _saveDocument(
    String kind,
    String key,
    Map<String, dynamic> payload,
  ) => store.saveDocument(kind: kind, key: key, payload: payload);

  Future<CachedValue<Map<String, dynamic>>?> _readDocument(
    String kind,
    String key,
  ) async {
    final cached = await store.readDocument(kind: kind, key: key);
    if (cached == null) return null;
    return CachedValue(value: cached.value, cachedAt: cached.cachedAt);
  }

  Future<List<CachedValue<Map<String, dynamic>>>> _readDocuments(
    String kind,
  ) async {
    final rows = await store.readDocumentsByKind(kind);
    return [
      for (final row in rows)
        CachedValue(value: row.value, cachedAt: row.cachedAt),
    ];
  }

  DateTime get now => _clock().toUtc();

  static String newClientId() {
    final random = Random.secure();
    final suffix = List.generate(
      8,
      (_) => random.nextInt(256),
    ).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    return 'eb-${DateTime.now().microsecondsSinceEpoch}-$suffix';
  }
}

class _Auth implements AuthRepository {
  _Auth(this.b);

  final CachedBackend b;

  @override
  Future<BackendResult<AuthSession>> signIn({
    required String email,
    required String password,
  }) async {
    if (!b._online) return const BackendFailure(BackendUnreachableError());
    final normalized = email.trim().toLowerCase();
    return b._guard(() async {
      await b.api.login(email: normalized, password: password);
      try {
        final result = await b.api.profileMe();
        final session = await b._saveProfile(result, normalized);
        final saved = await b.store.readSession();
        return BackendOk(session, cachedAt: saved?.cachedAt);
      } catch (_) {
        try {
          await b.api.clearStoredAuth();
        } catch (_) {
          // Preserve the original sign-in failure.
        }
        rethrow;
      }
    });
  }

  @override
  Future<BackendResult<AuthSession?>> restoreSession() async {
    if (!b._online) {
      final cached = await b.store.readSession();
      if (cached == null) return const BackendOk(null);
      return BackendOk(cached.value, cachedAt: cached.cachedAt, isStale: true);
    }
    final hasAuth = await b._guard<bool>(
      () async => BackendOk(await b.api.restoreStoredAuth()),
    );
    if (hasAuth case BackendFailure(:final error)) return BackendFailure(error);
    if (hasAuth.valueOrNull != true) {
      await b.store.clearAll();
      return const BackendOk(null);
    }
    final result = await _refresh();
    if (result case BackendFailure(:final error)) {
      switch (error) {
        case SessionExpiredError():
          await b.api.clearStoredAuth();
          await b.store.clearAll();
          return const BackendOk(null);
        case BackendUnreachableError():
          final cached = await b.store.readSession();
          if (cached != null) {
            return BackendOk(
              cached.value,
              cachedAt: cached.cachedAt,
              isStale: true,
            );
          }
        default:
          break;
      }
    }
    return result;
  }

  @override
  Future<BackendResult<AuthSession>> refreshProfile() async {
    if (!b._online) return const BackendFailure(BackendUnreachableError());
    final hasAuth = await b._guard<bool>(
      () async => BackendOk(await b.api.restoreStoredAuth()),
    );
    if (hasAuth case BackendFailure(:final error)) return BackendFailure(error);
    if (hasAuth.valueOrNull != true) {
      return const BackendFailure(SessionExpiredError());
    }
    return _refresh();
  }

  Future<BackendResult<AuthSession>> _refresh() => b._guard(() async {
    final result = await b.api.profileMe();
    final session = await b._saveProfile(result, null);
    final saved = await b.store.readSession();
    return BackendOk(session, cachedAt: saved?.cachedAt);
  });

  @override
  Future<BackendResult<void>> signOut() async {
    if (b._online) {
      try {
        await b.api.signOut();
      } catch (_) {
        // Best effort: the local session is cleared below regardless.
      }
    }
    BackendError? failure;
    try {
      await b.api.clearStoredAuth();
    } catch (error) {
      failure = mapApiError(error);
    }
    try {
      await b.store.clearAll();
    } catch (error) {
      failure ??= UnexpectedBackendError(error);
    }
    return failure == null ? const BackendOk(null) : BackendFailure(failure);
  }
}

class _Profile implements ProfileRepository {
  _Profile(this.b);

  final CachedBackend b;

  @override
  Future<BackendResult<ProfileResult>> me() async {
    if (!b._online) {
      final cached = await b.store.readSession();
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        cached.value.profileResult,
        cachedAt: cached.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final result = await b.api.profileMe();
      await b._saveProfile(result, null);
      final saved = await b.store.readSession();
      return BackendOk(result, cachedAt: saved?.cachedAt);
    });
  }
}

class _Classes implements ClassesRepository {
  _Classes(this.b);

  final CachedBackend b;

  @override
  Future<BackendResult<List<ClassSummary>>> mine() async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.teacher);
      if (denial != null) return BackendFailure(denial);
      final cached = await b.store.readTeacherClasses();
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(cached.value, cachedAt: cached.cachedAt, isStale: true);
    }
    return b._guard(() async {
      final value = await b.api.classesMine();
      await b.store.saveTeacherClasses(value);
      final saved = await b.store.readTeacherClasses();
      return BackendOk(value, cachedAt: saved?.cachedAt);
    });
  }
}

class _Library implements LibraryRepository {
  _Library(this.b);

  final CachedBackend b;

  @override
  Future<BackendResult<StudentLibrary>> library() async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.student);
      if (denial != null) return BackendFailure(denial);
      final cached = await b.store.readStudentLibrary();
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(cached.value, cachedAt: cached.cachedAt, isStale: true);
    }
    return b._guard(() async {
      final value = await b.api.contentLibrary();
      await b.store.saveStudentLibrary(value);
      final saved = await b.store.readStudentLibrary();
      return BackendOk(value, cachedAt: saved?.cachedAt);
    });
  }
}

class _Content implements ContentRepository {
  _Content(this.b);

  final CachedBackend b;

  static const _teacherListKind = 'teacherContentList';
  static const _detailKind = 'contentDetail';

  @override
  Future<BackendResult<List<TeacherContentItem>>> teacherList() async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.teacher);
      if (denial != null) return BackendFailure(denial);
      final rows = await b._readDocuments(_teacherListKind);
      if (rows.isEmpty) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        [
          for (final row in rows) TeacherContentItem.fromJson(row.value),
        ],
        cachedAt: rows.first.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.contentTeacherList();
      await b.store.deleteDocuments(_teacherListKind);
      for (final item in value) {
        await b._saveDocument(
          _teacherListKind,
          '${item.id}',
          item.toJson(),
        );
      }
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<ContentDetail>> detail(int contentId) async {
    if (!b._online) {
      final cached = await b._readDocument(_detailKind, '$contentId');
      if (cached != null) {
        return BackendOk(
          ContentDetail.fromJson(cached.value),
          cachedAt: cached.cachedAt,
          isStale: true,
        );
      }
      final download = await b.store.readDownload(contentId);
      if (download == null) {
        return const BackendFailure(OfflineNoCacheError());
      }
      return BackendOk(
        ContentDetail(
          id: contentId,
          type: download.type,
          title: download.title,
          subject: '',
          gradeLevel: 0,
          hasFile: true,
          mimeType: download.mimeType,
          pageCount: download.pageCount,
          durationSeconds: download.durationSeconds,
          createdAt: download.downloadedAt,
          lessonCompleted: false,
        ),
        cachedAt: download.downloadedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.contentDetail(contentId);
      await b._saveDocument(_detailKind, '$contentId', value.toJson());
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<TeacherContentItem>> upload({
    required int classId,
    required ContentType type,
    required String title,
    required String subject,
    required int gradeLevel,
    required String fileName,
    required List<int> bytes,
  }) async {
    if (!b._online) return const BackendFailure(BackendUnreachableError());
    return b._guard(() async {
      final ticket = await b.api.contentCreateUpload(
        classId: classId,
        type: type,
        title: title,
        subject: subject,
        gradeLevel: gradeLevel,
        fileName: fileName,
        sizeBytes: bytes.length,
      );
      await _put(ticket, bytes);
      final item = await b.api.contentCompleteUpload(ticket.contentId);
      await b.store.deleteDocuments(_teacherListKind);
      return BackendOk(item, cachedAt: b.now);
    });
  }

  Future<void> _put(UploadTicket ticket, List<int> bytes) async {
    final response = await b._http.put(
      Uri.parse(ticket.url),
      headers: ticket.headers,
      body: bytes,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('Upload failed with HTTP ${response.statusCode}');
    }
  }

  @override
  Future<BackendResult<TeacherContentItem>> approve(int contentId) async {
    if (!b._online) return const BackendFailure(BackendUnreachableError());
    return b._guard(() async {
      final value = await b.api.contentApprove(contentId);
      await b.store.deleteDocuments(_teacherListKind);
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<SignedFileUrl>> fileUrl(int contentId) async {
    if (!b._online) return const BackendFailure(BackendUnreachableError());
    return b._guard(() async {
      final value = await b.api.contentFileUrl(contentId);
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<String>> download(int contentId) async {
    final existing = await b.store.readDownload(contentId);
    if (existing != null && await b.contentCache.exists(existing.localPath)) {
      return BackendOk(existing.localPath, cachedAt: existing.downloadedAt);
    }
    if (!b._online) return const BackendFailure(BackendUnreachableError());
    return b._guard(() async {
      final detail = await b.api.contentDetail(contentId);
      await b._saveDocument(_detailKind, '$contentId', detail.toJson());
      final url = await b.api.contentFileUrl(contentId);
      final response = await b._http.get(Uri.parse(url.url));
      if (response.statusCode != 200) {
        throw StateError('Download failed with HTTP ${response.statusCode}');
      }
      final extension = _extensionFor(detail);
      final path = await b.contentCache.write(
        contentId: contentId,
        extension: extension,
        bytes: response.bodyBytes,
      );
      await b.store.saveDownload(
        contentId: contentId,
        localPath: path,
        title: detail.title,
        type: detail.type.name,
        mimeType: detail.mimeType,
        pageCount: detail.pageCount,
        durationSeconds: detail.durationSeconds,
      );
      return BackendOk(path, cachedAt: b.now);
    });
  }

  @override
  Future<bool> isDownloaded(int contentId) async {
    final path = await localPath(contentId);
    return path != null;
  }

  @override
  Future<String?> localPath(int contentId) async {
    final row = await b.store.readDownload(contentId);
    if (row == null) return null;
    if (await b.contentCache.exists(row.localPath)) return row.localPath;
    await b.store.deleteDownload(contentId);
    return null;
  }

  static String _extensionFor(ContentDetail detail) {
    if (detail.type == ContentType.video) return 'mp4';
    return 'pdf';
  }
}

class _Assignments implements AssignmentRepository {
  _Assignments(this.b);

  final CachedBackend b;

  static const _teacherAssignmentsKind = 'teacherAssignments';
  static const _studentAssignmentsKind = 'studentAssignments';
  static const _studentAssignmentKind = 'studentAssignmentDetail';
  static const _teacherExercisesKind = 'teacherExercises';
  static const _teacherExerciseKind = 'teacherExerciseDetail';
  static const _resultsKind = 'classResults';
  static const _submissionKind = 'submission';

  @override
  Future<BackendResult<List<TeacherAssignmentItem>>>
  teacherAssignments() async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.teacher);
      if (denial != null) return BackendFailure(denial);
      final rows = await b._readDocuments(_teacherAssignmentsKind);
      if (rows.isEmpty) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        [
          for (final row in rows) TeacherAssignmentItem.fromJson(row.value),
        ],
        cachedAt: rows.first.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.assignmentsMine();
      await b.store.deleteDocuments(_teacherAssignmentsKind);
      for (final item in value) {
        await b._saveDocument(
          _teacherAssignmentsKind,
          '${item.id}',
          item.toJson(),
        );
      }
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<TeacherAssignmentItem>> saveAssignment(
    AssignmentUpsert input,
  ) async {
    if (!b._online) return const BackendFailure(BackendUnreachableError());
    return b._guard(() async {
      final value = await b.api.assignmentSave(input);
      await b.store.deleteDocuments(_teacherAssignmentsKind);
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<void>> deleteAssignment(int assignmentId) async {
    if (!b._online) return const BackendFailure(BackendUnreachableError());
    return b._guard(() async {
      await b.api.assignmentDelete(assignmentId);
      await b.store.deleteDocuments(_teacherAssignmentsKind);
      return BackendOk(null, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<List<TeacherExerciseSummary>>> teacherExercises() async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.teacher);
      if (denial != null) return BackendFailure(denial);
      final rows = await b._readDocuments(_teacherExercisesKind);
      if (rows.isEmpty) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        [
          for (final row in rows) TeacherExerciseSummary.fromJson(row.value),
        ],
        cachedAt: rows.first.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.exercisesMine();
      await b.store.deleteDocuments(_teacherExercisesKind);
      for (final item in value) {
        await b._saveDocument(
          _teacherExercisesKind,
          '${item.id}',
          item.toJson(),
        );
      }
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<TeacherExerciseDetail>> teacherExercise(
    int exerciseId,
  ) async {
    if (!b._online) {
      final cached = await b._readDocument(_teacherExerciseKind, '$exerciseId');
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        TeacherExerciseDetail.fromJson(cached.value),
        cachedAt: cached.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.exerciseDetail(exerciseId);
      await b._saveDocument(
        _teacherExerciseKind,
        '$exerciseId',
        value.toJson(),
      );
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<TeacherExerciseDetail>> saveExercise(
    ExerciseUpsert input,
  ) async {
    if (!b._online) return const BackendFailure(BackendUnreachableError());
    return b._guard(() async {
      final value = await b.api.exerciseSave(input);
      await b.store.deleteDocuments(_teacherExercisesKind);
      await b._saveDocument(
        _teacherExerciseKind,
        '${value.id}',
        value.toJson(),
      );
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<StudentAssignmentList>> studentAssignments() async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.student);
      if (denial != null) return BackendFailure(denial);
      final rows = await b._readDocuments(_studentAssignmentsKind);
      if (rows.isEmpty) return const BackendFailure(OfflineNoCacheError());
      final pending = await _pendingAssignments();
      return BackendOk(
        StudentAssignmentList(
          assignments: [
            for (final row in rows)
              _overlayPending(
                StudentAssignmentItem.fromJson(row.value),
                pending,
              ),
          ],
        ),
        cachedAt: rows.first.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.studentAssignments();
      final pending = await _pendingAssignments();
      await b.store.deleteDocuments(_studentAssignmentsKind);
      for (final item in value.assignments) {
        final overlaid = _overlayPending(item, pending);
        await b._saveDocument(
          _studentAssignmentsKind,
          '${item.id}',
          overlaid.toJson(),
        );
      }
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<StudentAssignmentDetail>> studentAssignment(
    int assignmentId,
  ) async {
    if (!b._online) {
      final cached = await b._readDocument(
        _studentAssignmentKind,
        '$assignmentId',
      );
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        StudentAssignmentDetail.fromJson(cached.value),
        cachedAt: cached.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.studentAssignmentDetail(assignmentId);
      await b._saveDocument(
        _studentAssignmentKind,
        '$assignmentId',
        value.toJson(),
      );
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<ProgressResult>> markLessonComplete(
    int contentId,
  ) async {
    if (b._online) {
      final result = await b._guard(() async {
        final value = await b.api.progressMarkComplete(contentId);
        return BackendOk(value, cachedAt: b.now);
      });
      if (result.isOk) return result;
      if (result.errorOrNull is! BackendUnreachableError) return result;
    }
    await b.outbox.enqueue(
      OutboxWrite(
        operation: 'progress.markComplete',
        payload: {'contentId': contentId},
        createdAt: b.now,
      ),
    );
    return BackendOk(
      ProgressResult(
        contentId: contentId,
        status: 'completed',
        updatedAt: b.now,
      ),
      cachedAt: b.now,
    );
  }

  @override
  Future<BackendResult<SubmissionResult>> submit({
    required int assignmentId,
    required List<SubmittedAnswer> answers,
  }) async {
    final attempt = await b.store.readTestAttempt(assignmentId);
    final clientId = attempt?.clientSubmissionId ?? CachedBackend.newClientId();
    if (b._online) {
      final result = await b._guard(() async {
        final value = await b.api.submissionSubmit(
          assignmentId: assignmentId,
          clientSubmissionId: clientId,
          answers: answers,
        );
        await b.store.clearTestAttempt(assignmentId);
        await _saveSubmission(value);
        return BackendOk(value, cachedAt: b.now);
      });
      if (result.isOk) return result;
      if (result.errorOrNull is! BackendUnreachableError) return result;
    }
    await b.outbox.enqueue(
      OutboxWrite(
        operation: 'submission.submit',
        payload: {
          'assignmentId': assignmentId,
          'clientSubmissionId': clientId,
          'answers': [
            for (final answer in answers)
              {
                'questionId': answer.questionId,
                'selectedPositions': answer.selectedPositions,
              },
          ],
        },
        createdAt: b.now,
      ),
    );
    final queued = SubmissionResult(
      id: -1,
      assignmentId: assignmentId,
      clientSubmissionId: clientId,
      status: SubmissionStatus.submitted,
      late: false,
      answers: answers,
    );
    await _saveSubmission(queued);
    return BackendOk(queued, cachedAt: b.now);
  }

  @override
  Future<BackendResult<SubmissionResult?>> submissionFor(
    int assignmentId,
  ) async {
    if (!b._online) {
      final cached = await b._readDocument(_submissionKind, '$assignmentId');
      if (cached == null) return const BackendOk(null);
      return BackendOk(
        SubmissionResult.fromJson(cached.value),
        cachedAt: cached.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.submissionForAssignment(assignmentId);
      if (value == null) return const BackendOk(null);
      await _saveSubmission(value);
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<TestStartResult>> startTest(int assignmentId) async {
    if (!b._online) return const BackendFailure(BackendUnreachableError());
    return b._guard(() async {
      final value = await b.api.testStart(
        assignmentId: assignmentId,
        clientSubmissionId: CachedBackend.newClientId(),
      );
      final existing = await b.store.readTestAttempt(assignmentId);
      await b.store.saveTestAttempt(
        StoredTestAttempt(
          assignmentId: assignmentId,
          clientSubmissionId: value.clientSubmissionId,
          startedAt: value.startedAt,
          deadline: value.deadline,
          answers: existing?.answers ?? const [],
          submitted: false,
        ),
      );
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<TestStartResult?>> activeTest() async {
    if (b._online) {
      final result = await b._guard(() async {
        final value = await b.api.testActive();
        if (value == null) return const BackendOk<TestStartResult?>(null);
        await b.store.saveTestAttempt(
          StoredTestAttempt(
            assignmentId: value.assignmentId,
            clientSubmissionId: value.clientSubmissionId,
            startedAt: value.startedAt,
            deadline: value.deadline,
            answers:
                (await b.store.readTestAttempt(value.assignmentId))?.answers ??
                const [],
            submitted: false,
          ),
        );
        return BackendOk(value, cachedAt: b.now);
      });
      if (result.isOk) return result;
      if (result.errorOrNull is! BackendUnreachableError) return result;
    }
    final local = await b.store.readActiveTest();
    if (local == null) return const BackendOk(null);
    return BackendOk(
      TestStartResult(
        assignmentId: local.assignmentId,
        submissionId: -1,
        clientSubmissionId: local.clientSubmissionId,
        startedAt: local.startedAt,
        deadline: local.deadline,
      ),
      cachedAt: local.startedAt,
      isStale: !b._online,
    );
  }

  @override
  Future<void> saveTestAnswers(
    int assignmentId,
    List<SubmittedAnswer> answers,
  ) => b.store.saveTestAnswers(assignmentId: assignmentId, answers: answers);

  @override
  Future<List<SubmittedAnswer>> loadTestAnswers(int assignmentId) async {
    final attempt = await b.store.readTestAttempt(assignmentId);
    return attempt?.answers ?? const [];
  }

  @override
  Future<void> syncOutbox() async {
    if (!b._online) return;
    final pending = await b.outbox.pending();
    for (final entry in pending) {
      final id = entry.id!;
      try {
        switch (entry.operation) {
          case 'progress.markComplete':
            await b.api.progressMarkComplete(
              (entry.payload['contentId'] as num).toInt(),
            );
          case 'submission.submit':
            final assignmentId = (entry.payload['assignmentId'] as num).toInt();
            final clientId = entry.payload['clientSubmissionId'] as String;
            final answers = [
              for (final raw in entry.payload['answers'] as List)
                SubmittedAnswer(
                  questionId: (raw as Map)['questionId'] as int,
                  selectedPositions: [
                    for (final value in raw['selectedPositions'] as List)
                      value as int,
                  ],
                ),
            ];
            final result = await b.api.submissionSubmit(
              assignmentId: assignmentId,
              clientSubmissionId: clientId,
              answers: answers,
            );
            await _saveSubmission(result);
            await b.store.clearTestAttempt(assignmentId);
          default:
            await b.outbox.markFailed(
              id,
              'Unknown outbox operation ${entry.operation}',
            );
            continue;
        }
        await b.outbox.markSent(id);
      } catch (error) {
        final mapped = mapApiError(error);
        if (mapped is BackendUnreachableError) {
          return; // Keep the queue; the next reconnect retries.
        }
        await b.outbox.markFailed(id, mapped.runtimeType.toString());
      }
    }
  }

  @override
  Future<bool> hasPendingSubmission(int assignmentId) async {
    final pending = await _pendingAssignments();
    return pending.contains(assignmentId);
  }

  @override
  Future<BackendResult<ClassResults>> classResults(int classId) async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.teacher);
      if (denial != null) return BackendFailure(denial);
      final cached = await b._readDocument(_resultsKind, '$classId');
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        ClassResults.fromJson(cached.value),
        cachedAt: cached.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.classResults(classId);
      await b._saveDocument(_resultsKind, '$classId', value.toJson());
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<SubmissionResult>> regrade(int submissionId) async {
    if (!b._online) return const BackendFailure(BackendUnreachableError());
    return b._guard(() async {
      final value = await b.api.submissionRegrade(submissionId);
      await _saveSubmission(value);
      return BackendOk(value, cachedAt: b.now);
    });
  }

  Future<Set<int>> _pendingAssignments() async {
    final pending = await b.outbox.pending();
    return {
      for (final entry in pending)
        if (entry.operation == 'submission.submit')
          (entry.payload['assignmentId'] as num).toInt(),
    };
  }

  StudentAssignmentItem _overlayPending(
    StudentAssignmentItem item,
    Set<int> pending,
  ) {
    if (!pending.contains(item.id)) return item;
    if (item.state == StudentAssignmentState.inProgress) return item;
    return item.copyWith(state: StudentAssignmentState.submitted);
  }

  Future<void> _saveSubmission(SubmissionResult result) => b._saveDocument(
    _submissionKind,
    '${result.assignmentId}',
    result.toJson(),
  );
}

class _Tutor implements TutorRepository {
  _Tutor(this.b);

  final CachedBackend b;

  static const _stateKind = 'tutorState';
  static const _chatsKind = 'tutorChats';
  static const _chatKind = 'tutorChat';

  @override
  Future<BackendResult<TutorState>> state() async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.student);
      if (denial != null) return BackendFailure(denial);
      final cached = await b._readDocument(_stateKind, 'state');
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        TutorState.fromJson(cached.value),
        cachedAt: cached.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.tutorState();
      await b._saveDocument(_stateKind, 'state', value.toJson());
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<List<TutorChatSummary>>> chats() async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.student);
      if (denial != null) return BackendFailure(denial);
      final rows = await b._readDocuments(_chatsKind);
      if (rows.isEmpty) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        [
          for (final row in rows) TutorChatSummary.fromJson(row.value),
        ],
        cachedAt: rows.first.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.tutorChats();
      await b.store.deleteDocuments(_chatsKind);
      for (final item in value) {
        await b._saveDocument(_chatsKind, '${item.id}', item.toJson());
      }
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<TutorChatDetail>> chat(int chatId) async {
    if (!b._online) {
      final cached = await b._readDocument(_chatKind, '$chatId');
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        TutorChatDetail.fromJson(cached.value),
        cachedAt: cached.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.tutorChat(chatId);
      await b._saveDocument(_chatKind, '$chatId', value.toJson());
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Stream<TutorEvent> ask({
    required String subject,
    required String message,
    int? chatId,
  }) {
    if (!b._online) {
      return Stream.error(const BackendException(BackendUnreachableError()));
    }
    return b.api
        .tutorAsk(subject: subject, message: message, chatId: chatId)
        .handleError(
          (Object error) => throw BackendException(mapApiError(error)),
        );
  }

  @override
  Future<BackendResult<List<TutorChatSummary>>> classChats(
    int studentId,
  ) async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.teacher);
      if (denial != null) return BackendFailure(denial);
      final rows = await b._readDocuments(_chatsKind);
      if (rows.isEmpty) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        [
          for (final row in rows) TutorChatSummary.fromJson(row.value),
        ],
        cachedAt: rows.first.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.tutorClassChats(studentId);
      await b.store.deleteDocuments(_chatsKind);
      for (final item in value) {
        await b._saveDocument(_chatsKind, '${item.id}', item.toJson());
      }
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<TutorChatDetail>> classChat(int chatId) async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.teacher);
      if (denial != null) return BackendFailure(denial);
      final cached = await b._readDocument(_chatKind, '$chatId');
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        TutorChatDetail.fromJson(cached.value),
        cachedAt: cached.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.tutorClassChat(chatId);
      await b._saveDocument(_chatKind, '$chatId', value.toJson());
      return BackendOk(value, cachedAt: b.now);
    });
  }
}

class _Parent implements ParentRepository {
  _Parent(this.b);

  final CachedBackend b;

  static const _summaryKind = 'parentSummary';
  static const _chatsKind = 'parentChats';
  static const _chatKind = 'parentChat';

  @override
  Future<BackendResult<ParentHomeData>> home() async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.parent);
      if (denial != null) return BackendFailure(denial);
      final cached = await b.store.readParentHome();
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(cached.value, cachedAt: cached.cachedAt, isStale: true);
    }
    return b._guard(() async {
      final result = await b.api.profileMe();
      await b._saveProfile(result, null);
      final profile = result.profile;
      if (result.status != ProfileStatus.ready || profile == null) {
        return const BackendFailure(NotSetUpError());
      }
      if (profile.role != UserRole.parent) {
        return const BackendFailure(PermissionDeniedError());
      }
      final data = ParentHomeData(linkedStudentName: profile.linkedStudentName);
      await b.store.saveParentHome(data);
      final saved = await b.store.readParentHome();
      return BackendOk(data, cachedAt: saved?.cachedAt);
    });
  }

  @override
  Future<BackendResult<ParentSummary>> summary() async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.parent);
      if (denial != null) return BackendFailure(denial);
      final cached = await b._readDocument(_summaryKind, 'summary');
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        ParentSummary.fromJson(cached.value),
        cachedAt: cached.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.parentSummary();
      await b._saveDocument(_summaryKind, 'summary', value.toJson());
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<List<TutorChatSummary>>> chats() async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.parent);
      if (denial != null) return BackendFailure(denial);
      final rows = await b._readDocuments(_chatsKind);
      if (rows.isEmpty) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        [
          for (final row in rows) TutorChatSummary.fromJson(row.value),
        ],
        cachedAt: rows.first.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.parentChats();
      await b.store.deleteDocuments(_chatsKind);
      for (final item in value) {
        await b._saveDocument(_chatsKind, '${item.id}', item.toJson());
      }
      return BackendOk(value, cachedAt: b.now);
    });
  }

  @override
  Future<BackendResult<TutorChatDetail>> chat(int chatId) async {
    if (!b._online) {
      final denial = await b._offlineRoleFailure(UserRole.parent);
      if (denial != null) return BackendFailure(denial);
      final cached = await b._readDocument(_chatKind, '$chatId');
      if (cached == null) return const BackendFailure(OfflineNoCacheError());
      return BackendOk(
        TutorChatDetail.fromJson(cached.value),
        cachedAt: cached.cachedAt,
        isStale: true,
      );
    }
    return b._guard(() async {
      final value = await b.api.parentChat(chatId);
      await b._saveDocument(_chatKind, '$chatId', value.toJson());
      return BackendOk(value, cachedAt: b.now);
    });
  }
}

class _Diagnostics implements DiagnosticsRepository {
  _Diagnostics(this.b);

  final CachedBackend b;

  @override
  Stream<PingMessage> pingStream() {
    if (!b._online) {
      return Stream.error(const BackendException(BackendUnreachableError()));
    }
    return b.api.pingStream().handleError(
      (Object error) => throw BackendException(mapApiError(error)),
    );
  }
}
