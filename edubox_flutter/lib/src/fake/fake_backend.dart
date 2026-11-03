import 'dart:async';
import 'dart:convert';

import 'package:edubox_client/edubox_client.dart';
import 'package:edubox_fixtures/edubox_fixtures.dart';

import '../contract/backend.dart';
import '../contract/backend_result.dart';
import '../contract/learning_repositories.dart';
import '../contract/network_controller.dart';
import '../contract/repositories.dart';
import '../contract/session.dart';

/// How the fake answers data calls. It is derived from [NetworkController]:
/// the fake never keeps a second, independent offline switch.
enum FakeMode {
  /// Normal server answers.
  online,

  /// Offline, but the role home still has its last cached data.
  offlineWithCache,

  /// Offline with an empty cache: screens show their offline-no-data state.
  offlineWithoutCache,
}

/// A fixture-backed backend for every phase 1 screen state.
///
/// It enforces the same role rules as the server, so a wrong-role caller is
/// denied here too. Failure fields switch individual calls without changing
/// the account data; [setRole] simulates an administrator fixing a profile.
///
/// Offline behaviour follows [network] exactly: online calls return fixture
/// data with `BackendOk.cachedAt`, offline/reconnecting calls return the same
/// data as stale while [hasCache] is true, and `OfflineNoCacheError` once it
/// is false. [holdCalls] keeps a call pending for loading/busy previews.
class FakeBackend implements EduBoxBackend {
  FakeBackend({
    FixtureSet? fixtures,
    NetworkController? network,
    this.hasCache = true,
    this.password = devPassword,
    this.latency = Duration.zero,
    DateTime Function()? clock,
  }) : fixtures = fixtures ?? FixtureSet.phase1(),
       network = network ?? ManualNetworkController(),
       _clock = clock ?? DateTime.now {
    _buildLearningFixtures();
  }

  FixtureSet fixtures;
  final String password;
  final NetworkController network;
  final DateTime Function() _clock;

  /// False models a device whose drift cache was cleared.
  bool hasCache;

  /// Artificial latency for loading and busy previews.
  Duration latency;

  BackendError? signInError;
  BackendError? restoreError;
  BackendError? profileError;
  BackendError? classesError;
  BackendError? libraryError;
  BackendError? parentError;
  BackendError? pingError;
  BackendError? signOutError;

  final Map<String, String?> _roleOverrides = {};
  final Map<String, int> _failedSignIns = {};
  final Map<String, Object?> _snapshots = {};
  final Map<int, TeacherContentItem> _teacherContent = {};
  final Map<int, TeacherExerciseDetail> _exercises = {};
  final List<TeacherExerciseSummary> _teacherExercises = [];
  final List<TeacherAssignmentItem> _teacherAssignments = [];
  final Map<int, StudentAssignmentItem> _studentAssignments = {};
  final Map<int, SubmissionResult> _submissions = {};
  final Map<int, TestStartResult> _tests = {};
  final Map<int, String> _tutorDetails = {};
  final Set<int> _pendingSubmissions = {};
  final Map<int, List<SubmittedAnswer>> _testAnswers = {};
  final List<TutorChatSummary> _tutorChats = [];
  final Set<int> _completedLessons = {};
  final Set<int> _downloaded = {};
  final Map<int, String> _downloadPaths = {};
  AccountFixture? _signedInAccount;
  AuthSession? _sessionSnapshot;
  DateTime? _lastRefreshAt;
  Completer<void>? _gate;

  bool get isOnline => network.status == NetworkStatus.online;

  FakeMode get mode {
    if (isOnline) return FakeMode.online;
    return hasCache ? FakeMode.offlineWithCache : FakeMode.offlineWithoutCache;
  }

  /// Compatibility switch for previews; it drives [network], never a second
  /// offline flag.
  set mode(FakeMode value) {
    hasCache = value != FakeMode.offlineWithoutCache;
    final controller = network;
    if (controller is ManualNetworkController) {
      if (value == FakeMode.online) {
        controller.goOnline();
      } else {
        controller.goOffline();
      }
    }
  }

  AuthSession? get currentSession => _signedInAccount == null
      ? null
      : AuthSession(
          signedInEmail: _signedInAccount!.email,
          profileResult: _profileOf(_signedInAccount!),
        );

  /// Signs in as a fixture account without exercising credentials, for
  /// screen previews and widget tests.
  AuthSession signInAs(String accountKey) {
    _signedInAccount = fixtures.account(accountKey);
    _lastRefreshAt = _clock().toUtc();
    _snapshotHomes();
    return currentSession!;
  }

  /// Simulates the admin changing the raw `users.role` value.
  void setRole(String accountKey, String? role) {
    _roleOverrides[accountKey] = role;
  }

  /// Applies exit criterion 7's server-side reconnect deltas mid-session.
  void applyReconnectDeltas() {
    fixtures = fixtures.withReconnectDeltas();
  }

  /// Empties the modelled local cache for offline-no-cache previews.
  void clearCache() {
    hasCache = false;
    _lastRefreshAt = null;
    _snapshots.clear();
  }

  /// Keeps every later call pending until [releaseCalls].
  Completer<void> holdCalls() => _gate ??= Completer<void>();

  void releaseCalls() {
    final gate = _gate;
    _gate = null;
    if (gate != null && !gate.isCompleted) gate.complete();
  }

  /// Clears any call-specific failure.
  void clearFailures() {
    signInError = null;
    restoreError = null;
    profileError = null;
    classesError = null;
    libraryError = null;
    parentError = null;
    pingError = null;
    signOutError = null;
  }

  @override
  AuthRepository get auth => _FakeAuth(this);

  @override
  ProfileRepository get profile => _FakeProfile(this);

  @override
  ClassesRepository get classes => _FakeClasses(this);

  @override
  LibraryRepository get library => _FakeLibrary(this);

  @override
  ParentRepository get parent => _FakeParent(this);

  @override
  ContentRepository get content => _FakeContent(this);

  @override
  AssignmentRepository get assignments => _FakeAssignments(this);

  @override
  TutorRepository get tutor => _FakeTutor(this);

  @override
  DiagnosticsRepository get diagnostics => _FakeDiagnostics(this);

  @override
  Future<void> dispose() async {}

  Future<void> _wait() async {
    final gate = _gate;
    if (gate != null) await gate.future;
    if (latency > Duration.zero) await Future<void>.delayed(latency);
  }

  DateTime get lastRefreshAt => _lastRefreshAt ??= _clock().toUtc();

  DateTime _touchRefresh() => _lastRefreshAt = _clock().toUtc();

  /// Snapshots every role-home value at an online read (sign-in prefetches all
  /// four, like a session that had loaded its home before going offline).
  void _snapshotHomes() {
    final account = _signedInAccount;
    if (account == null) return;
    final session = AuthSession(
      signedInEmail: account.email,
      profileResult: _profileOf(account),
    );
    _sessionSnapshot = session;
    _snapshots['profile'] = session.profileResult;
    _snapshots['classes'] = _teacherClasses();
    _snapshots['library'] = _studentLibrary();
    _snapshots['parent'] = _parentHome();
  }

  BackendResult<T> _dataResult<T>(String key, T Function() build) {
    if (!isOnline) {
      if (!hasCache) return BackendFailure<T>(const OfflineNoCacheError());
      final snapshot = _snapshots[key];
      if (snapshot is! T) {
        return BackendFailure<T>(const OfflineNoCacheError());
      }
      return BackendOk<T>(
        snapshot,
        cachedAt: lastRefreshAt,
        isStale: true,
      );
    }
    final value = build();
    _snapshots[key] = value;
    return BackendOk<T>(value, cachedAt: _touchRefresh());
  }

  AuthSession? _sessionForCall() {
    if (!isOnline) return _sessionSnapshot;
    final account = _signedInAccount;
    if (account == null) return null;
    return AuthSession(
      signedInEmail: account.email,
      profileResult: _profileOf(account),
    );
  }

  ProfileResult _profileOf(AccountFixture account) {
    final rawRole = _roleOverrides[account.key] ?? account.role;
    final role = rawRole == null ? null : UserRole.values.asNameMap()[rawRole];
    if (!account.hasProfile || role == null) {
      return ProfileResult(
        status: ProfileStatus.notSetUp,
        signedInEmail: account.email,
      );
    }
    final linkedKey = account.linkedStudentKey;
    return ProfileResult(
      status: ProfileStatus.ready,
      signedInEmail: account.email,
      profile: Profile(
        userId: _userIdOf(account),
        role: role,
        name: account.name,
        email: account.email,
        linkedStudentName: linkedKey == null
            ? null
            : fixtures.account(linkedKey).name,
      ),
    );
  }

  int _userIdOf(AccountFixture account) =>
      fixtures.accounts.indexOf(account) + 1;

  BackendError? _roleFailure(UserRole role) {
    final session = _sessionForCall();
    if (session == null) return const SessionExpiredError();
    if (session.isNotSetUp) return const NotSetUpError();
    if (session.role != role) return const PermissionDeniedError();
    return null;
  }

  List<ClassSummary> _teacherClasses() => [
    for (final (index, item)
        in fixtures.classesOfTeacher(_signedInAccount!.key).indexed)
      ClassSummary(
        id: index + 1,
        name: item.name,
        gradeLevel: item.gradeLevel,
        subjects: List.unmodifiable(item.subjects),
        studentCount: item.studentKeys.length,
      ),
  ];

  StudentLibrary _studentLibrary() {
    final classes = fixtures.classesOfStudent(_signedInAccount!.key);
    return StudentLibrary(
      classes: [
        for (final (index, item) in classes.indexed)
          StudentClass(
            id: index + 1,
            name: item.name,
            gradeLevel: item.gradeLevel,
            subjects: List.unmodifiable(item.subjects),
          ),
      ],
      items: [
        for (final (index, item)
            in fixtures.libraryOfStudent(_signedInAccount!.key).indexed)
          LibraryItem(
            id: index + 1,
            type: ContentType.values.byName(item.type.name),
            title: item.title,
            subject: item.subject,
            gradeLevel: item.gradeLevel,
            createdAt: item.createdAt,
            hasFile: item.type != FixtureContentType.exercise,
            mimeType: item.type == FixtureContentType.ebook
                ? 'application/pdf'
                : item.type == FixtureContentType.video
                ? 'video/mp4'
                : null,
            sizeBytes: item.type == FixtureContentType.exercise ? null : 2048,
            pageCount: item.type == FixtureContentType.ebook ? 2 : null,
            durationSeconds: item.type == FixtureContentType.video ? 2 : null,
          ),
      ],
    );
  }

  ParentHomeData _parentHome() => ParentHomeData(
    linkedStudentName: fixtures.linkedStudentNameOf(_signedInAccount!.key),
  );

  int _contentIdOf(String key) =>
      fixtures.content.indexWhere((item) => item.key == key) + 1;

  void _buildLearningFixtures() {
    _teacherContent.clear();
    for (final (index, item) in fixtures.content.indexed) {
      final id = index + 1;
      _teacherContent[id] = TeacherContentItem(
        id: id,
        type: ContentType.values.byName(item.type.name),
        title: item.title,
        subject: item.subject,
        gradeLevel: item.gradeLevel,
        status: ContentStatus.values.byName(item.status.name),
        ingestStatus: IngestStatus.ready,
        originalFileName: item.type == FixtureContentType.exercise
            ? null
            : '${item.key}.${item.type == FixtureContentType.ebook ? 'pdf' : 'mp4'}',
        sizeBytes: item.type == FixtureContentType.exercise ? null : 2048,
        pageCount: item.type == FixtureContentType.ebook ? 2 : null,
        durationSeconds: item.type == FixtureContentType.video ? 2 : null,
        createdAt: item.createdAt,
        classNames: [
          for (final classKey in item.classKeys)
            fixtures.classByKey(classKey).name,
        ],
        exerciseId: item.type == FixtureContentType.exercise ? 1 : null,
      );
    }
    final exerciseContentId = _contentIdOf(FixtureKeys.exerciseFractions);
    final exerciseContent = _teacherContent[exerciseContentId]!;
    _exercises[1] = TeacherExerciseDetail(
      id: 1,
      contentId: exerciseContentId,
      title: exerciseContent.title,
      subject: exerciseContent.subject,
      gradeLevel: exerciseContent.gradeLevel,
      lessonContentId: _contentIdOf(FixtureKeys.ebookFractions),
      updatedAt: exerciseContent.createdAt,
      questions: [
        ExerciseQuestionInput(
          id: 1,
          position: 0,
          stem: '1/2 + 1/4 = ?',
          multiSelect: false,
          options: const ['1/6', '3/4', '2/6', '1/8'],
          correctPositions: const [1],
        ),
        ExerciseQuestionInput(
          id: 2,
          position: 1,
          stem: '2/3 + 1/6 = ?',
          multiSelect: false,
          options: const ['3/9', '5/6', '1/3', '3/6'],
          correctPositions: const [1],
        ),
        ExerciseQuestionInput(
          id: 3,
          position: 2,
          stem: 'Phân số nào bằng 1/2?',
          multiSelect: true,
          options: const ['2/4', '3/6', '2/3', '4/8'],
          correctPositions: const [0, 1, 3],
        ),
      ],
    );
    final class7A = fixtures.classByKey(FixtureKeys.class7A);
    final teacherName = fixtures.account(FixtureKeys.teacherLan).name;
    final now = _clock().toUtc();
    _studentAssignments
      ..clear()
      ..[1] = StudentAssignmentItem(
        id: 1,
        classId: 1,
        className: class7A.name,
        exerciseId: 1,
        contentId: exerciseContentId,
        title: 'Luyện tập: Phép cộng phân số',
        subject: exerciseContent.subject,
        type: AssignmentType.practice,
        dueAt: now.add(const Duration(days: 3)),
        state: StudentAssignmentState.toDo,
        late: false,
        lessonContentId: _contentIdOf(FixtureKeys.ebookFractions),
        lessonTitle: 'Phân số và số thập phân',
      )
      ..[2] = StudentAssignmentItem(
        id: 2,
        classId: 1,
        className: class7A.name,
        exerciseId: 1,
        contentId: exerciseContentId,
        title: 'Kiểm tra nhanh: Phân số',
        subject: exerciseContent.subject,
        type: AssignmentType.test,
        dueAt: now.add(const Duration(days: 5)),
        timeLimitSec: 120,
        state: StudentAssignmentState.toDo,
        late: false,
        lessonContentId: _contentIdOf(FixtureKeys.ebookFractions),
        lessonTitle: 'Phân số và số thập phân',
      );
    _teacherAssignments
      ..clear()
      ..addAll([
        TeacherAssignmentItem(
          id: 1,
          classId: 1,
          className: class7A.name,
          exerciseId: 1,
          exerciseTitle: exerciseContent.title,
          type: AssignmentType.practice,
          title: 'Luyện tập: Phép cộng phân số',
          dueAt: now.add(const Duration(days: 3)),
          submissionCount: 0,
          gradedCount: 0,
          createdAt: now.subtract(const Duration(hours: 1)),
        ),
        TeacherAssignmentItem(
          id: 2,
          classId: 1,
          className: class7A.name,
          exerciseId: 1,
          exerciseTitle: exerciseContent.title,
          type: AssignmentType.test,
          title: 'Kiểm tra nhanh: Phân số',
          dueAt: now.add(const Duration(days: 5)),
          timeLimitSec: 120,
          submissionCount: 0,
          gradedCount: 0,
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
      ]);
    final an = fixtures.account(FixtureKeys.studentAn);
    final chat = TutorChatSummary(
      id: 1,
      subject: 'Toán',
      title: 'Cách cộng hai phân số khác mẫu',
      createdAt: now.subtract(const Duration(days: 1)),
      updatedAt: now.subtract(const Duration(days: 1)),
      messageCount: 2,
      studentName: an.name,
    );
    _tutorChats
      ..clear()
      ..add(chat);
    _tutorDetails.clear();
    _tutorDetails[1] = jsonEncode(
      TutorChatDetail(
        id: 1,
        subject: 'Toán',
        title: chat.title,
        createdAt: chat.createdAt,
        updatedAt: chat.updatedAt,
        studentName: an.name,
        messages: [
          TutorMessage(
            id: 1,
            role: ChatRole.student,
            content: 'Làm sao để cộng 1/2 và 1/4 ạ?',
            createdAt: chat.createdAt,
          ),
          TutorMessage(
            id: 2,
            role: ChatRole.tutor,
            content:
                'Em quy đồng mẫu số: 1/2 = 2/4, rồi cộng 2/4 + 1/4 = 3/4. '
                'Em thử tự làm một ví dụ khác nhé.',
            createdAt: chat.createdAt,
          ),
        ],
      ).toJson(),
    );
    // The teacher picker lists the one exercise.
    _teacherExercises
      ..clear()
      ..add(
        TeacherExerciseSummary(
          id: 1,
          contentId: exerciseContentId,
          title: exerciseContent.title,
          subject: exerciseContent.subject,
          gradeLevel: exerciseContent.gradeLevel,
          questionCount: 3,
          updatedAt: exerciseContent.createdAt,
        ),
      );
    // Keep the unused teacher name read so the seed stays explicit.
    assert(teacherName.isNotEmpty);
  }
}

class _FakeAuth implements AuthRepository {
  _FakeAuth(this.fake);

  final FakeBackend fake;

  static const _maxFailedAttempts = 5;

  @override
  Future<BackendResult<AuthSession>> signIn({
    required String email,
    required String password,
  }) async {
    await fake._wait();
    if (fake.signInError != null) {
      return BackendFailure(fake.signInError!);
    }
    if (!fake.isOnline) {
      return const BackendFailure(BackendUnreachableError());
    }
    final normalized = email.trim().toLowerCase();
    if ((fake._failedSignIns[normalized] ?? 0) >= _maxFailedAttempts) {
      return const BackendFailure(TooManyAttemptsError());
    }
    final account = fake.fixtures.accountByEmail(normalized);
    if (account == null || password != fake.password) {
      fake._failedSignIns[normalized] =
          (fake._failedSignIns[normalized] ?? 0) + 1;
      return const BackendFailure(WrongCredentialsError());
    }
    if (account.blocked) {
      return const BackendFailure(AccountDisabledError());
    }
    fake._failedSignIns.remove(normalized);
    fake._signedInAccount = account;
    fake._touchRefresh();
    fake._snapshotHomes();
    return BackendOk(
      fake.currentSession!,
      cachedAt: fake.lastRefreshAt,
    );
  }

  @override
  Future<BackendResult<AuthSession?>> restoreSession() async {
    await fake._wait();
    if (fake.restoreError != null) {
      return BackendFailure(fake.restoreError!);
    }
    final session = fake.isOnline ? fake.currentSession : fake._sessionSnapshot;
    if (session == null) return const BackendOk(null);
    if (fake.isOnline) fake._sessionSnapshot = session;
    return BackendOk(
      session,
      cachedAt: fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }

  @override
  Future<BackendResult<AuthSession>> refreshProfile() async {
    await fake._wait();
    if (fake.profileError != null) {
      return BackendFailure(fake.profileError!);
    }
    if (!fake.isOnline) {
      return const BackendFailure(BackendUnreachableError());
    }
    if (fake._signedInAccount == null) {
      return const BackendFailure(SessionExpiredError());
    }
    fake._touchRefresh();
    fake._snapshotHomes();
    return BackendOk(
      fake.currentSession!,
      cachedAt: fake.lastRefreshAt,
    );
  }

  @override
  Future<BackendResult<void>> signOut() async {
    await fake._wait();
    if (fake.signOutError != null) {
      return BackendFailure(fake.signOutError!);
    }
    // Sign-out clears the local session even offline; the server call is
    // best effort.
    fake._signedInAccount = null;
    fake._sessionSnapshot = null;
    fake._snapshots.clear();
    return const BackendOk(null);
  }
}

class _FakeProfile implements ProfileRepository {
  _FakeProfile(this.fake);

  final FakeBackend fake;

  @override
  Future<BackendResult<ProfileResult>> me() async {
    await fake._wait();
    if (fake.profileError != null) {
      return BackendFailure(fake.profileError!);
    }
    final session = fake._sessionForCall();
    if (session == null) {
      return const BackendFailure(SessionExpiredError());
    }
    return fake._dataResult('profile', () => session.profileResult);
  }
}

class _FakeClasses implements ClassesRepository {
  _FakeClasses(this.fake);

  final FakeBackend fake;

  @override
  Future<BackendResult<List<ClassSummary>>> mine() async {
    await fake._wait();
    if (fake.classesError != null) {
      return BackendFailure(fake.classesError!);
    }
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    return fake._dataResult('classes', fake._teacherClasses);
  }
}

class _FakeLibrary implements LibraryRepository {
  _FakeLibrary(this.fake);

  final FakeBackend fake;

  @override
  Future<BackendResult<StudentLibrary>> library() async {
    await fake._wait();
    if (fake.libraryError != null) {
      return BackendFailure(fake.libraryError!);
    }
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) return BackendFailure(denial);
    return fake._dataResult('library', fake._studentLibrary);
  }
}

class _FakeContent implements ContentRepository {
  _FakeContent(this.fake);

  final FakeBackend fake;

  @override
  Future<BackendResult<List<TeacherContentItem>>> teacherList() async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    return fake._dataResult('teacherContent', () {
      final items = fake._teacherContent.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    });
  }

  @override
  Future<BackendResult<ContentDetail>> detail(int contentId) async {
    await fake._wait();
    final item = fake._teacherContent[contentId];
    if (item == null) return const BackendFailure(PermissionDeniedError());
    final session = fake._sessionForCall();
    if (session == null) return const BackendFailure(SessionExpiredError());
    if (session.role == UserRole.parent) {
      return const BackendFailure(PermissionDeniedError());
    }
    if (session.role == UserRole.student &&
        !fake._studentLibrary().items.any((entry) => entry.id == contentId)) {
      return const BackendFailure(PermissionDeniedError());
    }
    return BackendOk(
      ContentDetail(
        id: contentId,
        type: item.type,
        title: item.title,
        subject: item.subject,
        gradeLevel: item.gradeLevel,
        hasFile: item.ingestStatus == IngestStatus.ready,
        mimeType: item.type == ContentType.video
            ? 'video/mp4'
            : item.type == ContentType.ebook
            ? 'application/pdf'
            : null,
        sizeBytes: item.sizeBytes,
        pageCount: item.pageCount,
        durationSeconds: item.durationSeconds,
        createdAt: item.createdAt,
        lessonCompleted: fake._completedLessons.contains(contentId),
      ),
      cachedAt: fake.lastRefreshAt,
    );
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
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    if (!fake.isOnline) return const BackendFailure(BackendUnreachableError());
    final id = fake._teacherContent.length + 1;
    final item = TeacherContentItem(
      id: id,
      type: type,
      title: title,
      subject: subject,
      gradeLevel: gradeLevel,
      status: ContentStatus.draft,
      ingestStatus: IngestStatus.ready,
      originalFileName: fileName,
      sizeBytes: bytes.length,
      pageCount: type == ContentType.ebook ? 2 : null,
      durationSeconds: type == ContentType.video ? 2 : null,
      createdAt: fake._clock().toUtc(),
      classNames: [fake.fixtures.classByKey(FixtureKeys.class7A).name],
    );
    fake._teacherContent[id] = item;
    return BackendOk(item, cachedAt: fake._touchRefresh());
  }

  @override
  Future<BackendResult<TeacherContentItem>> approve(int contentId) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    final item = fake._teacherContent[contentId];
    if (item == null) return const BackendFailure(PermissionDeniedError());
    final approved = item.copyWith(status: ContentStatus.approved);
    fake._teacherContent[contentId] = approved;
    return BackendOk(approved, cachedAt: fake._touchRefresh());
  }

  @override
  Future<BackendResult<SignedFileUrl>> fileUrl(int contentId) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null && fake._sessionForCall()?.role != UserRole.teacher) {
      return BackendFailure(denial);
    }
    if (!fake.isOnline) return const BackendFailure(BackendUnreachableError());
    return BackendOk(
      SignedFileUrl(
        url: 'https://example.test/content/$contentId',
        expiresAt: fake._clock().toUtc().add(const Duration(minutes: 20)),
      ),
      cachedAt: fake._touchRefresh(),
    );
  }

  @override
  Future<BackendResult<String>> download(int contentId) async {
    await fake._wait();
    if (!fake.isOnline && !fake._downloaded.contains(contentId)) {
      return const BackendFailure(BackendUnreachableError());
    }
    fake._downloaded.add(contentId);
    final path = fake._downloadPaths[contentId] ?? '/tmp/edubox-$contentId.pdf';
    fake._downloadPaths[contentId] = path;
    return BackendOk(path, cachedAt: fake._touchRefresh());
  }

  @override
  Future<bool> isDownloaded(int contentId) async =>
      fake._downloaded.contains(contentId);

  @override
  Future<String?> localPath(int contentId) async =>
      fake._downloaded.contains(contentId)
      ? fake._downloadPaths[contentId] ?? '/tmp/edubox-$contentId.pdf'
      : null;
}

class _FakeAssignments implements AssignmentRepository {
  _FakeAssignments(this.fake);

  final FakeBackend fake;

  @override
  Future<BackendResult<List<TeacherAssignmentItem>>>
  teacherAssignments() async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    return fake._dataResult(
      'teacherAssignments',
      () => List<TeacherAssignmentItem>.unmodifiable(fake._teacherAssignments),
    );
  }

  @override
  Future<BackendResult<TeacherAssignmentItem>> saveAssignment(
    AssignmentUpsert input,
  ) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    final id = input.id ?? fake._teacherAssignments.length + 1;
    final exercise = fake._exercises[input.exerciseId];
    if (exercise == null) return const BackendFailure(PermissionDeniedError());
    final item = TeacherAssignmentItem(
      id: id,
      classId: input.classId,
      className: fake.fixtures.classByKey(FixtureKeys.class7A).name,
      exerciseId: input.exerciseId,
      exerciseTitle: exercise.title,
      type: input.type,
      title: input.title,
      dueAt: input.dueAt,
      timeLimitSec: input.timeLimitSec,
      submissionCount: 0,
      gradedCount: 0,
      createdAt: fake._clock().toUtc(),
    );
    fake._teacherAssignments.removeWhere((row) => row.id == id);
    fake._teacherAssignments.add(item);
    fake._studentAssignments[id] = StudentAssignmentItem(
      id: id,
      classId: input.classId,
      className: item.className,
      exerciseId: input.exerciseId,
      contentId: exercise.contentId,
      title: input.title,
      subject: exercise.subject,
      type: input.type,
      dueAt: input.dueAt,
      timeLimitSec: input.timeLimitSec,
      state: StudentAssignmentState.toDo,
      late: false,
      lessonContentId: exercise.lessonContentId,
    );
    return BackendOk(item, cachedAt: fake._touchRefresh());
  }

  @override
  Future<BackendResult<void>> deleteAssignment(int assignmentId) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    fake._teacherAssignments.removeWhere((row) => row.id == assignmentId);
    fake._studentAssignments.remove(assignmentId);
    return const BackendOk(null);
  }

  @override
  Future<BackendResult<List<TeacherExerciseSummary>>> teacherExercises() async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    return fake._dataResult(
      'teacherExercises',
      () => List<TeacherExerciseSummary>.unmodifiable(fake._teacherExercises),
    );
  }

  @override
  Future<BackendResult<TeacherExerciseDetail>> teacherExercise(
    int exerciseId,
  ) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    final value = fake._exercises[exerciseId];
    if (value == null) return const BackendFailure(PermissionDeniedError());
    return BackendOk(value, cachedAt: fake.lastRefreshAt);
  }

  @override
  Future<BackendResult<TeacherExerciseDetail>> saveExercise(
    ExerciseUpsert input,
  ) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    final existing = input.contentId == null
        ? null
        : fake._exercises.values.firstWhere(
            (row) => row.contentId == input.contentId,
            orElse: () => fake._exercises[1]!,
          );
    final id = existing?.id ?? fake._exercises.length + 1;
    final contentId =
        input.contentId ?? fake._contentIdOf(FixtureKeys.exerciseFractions);
    final detail = TeacherExerciseDetail(
      id: id,
      contentId: contentId,
      title: input.title,
      subject: input.subject,
      gradeLevel: input.gradeLevel,
      lessonContentId: input.lessonContentId,
      updatedAt: fake._clock().toUtc(),
      questions: input.questions,
    );
    fake._exercises[id] = detail;
    fake._teacherExercises.removeWhere((row) => row.id == id);
    fake._teacherExercises.add(
      TeacherExerciseSummary(
        id: id,
        contentId: contentId,
        title: input.title,
        subject: input.subject,
        gradeLevel: input.gradeLevel,
        questionCount: input.questions.length,
        updatedAt: detail.updatedAt,
      ),
    );
    return BackendOk(detail, cachedAt: fake._touchRefresh());
  }

  @override
  Future<BackendResult<StudentAssignmentList>> studentAssignments() async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) return BackendFailure(denial);
    if (!fake.isOnline && !fake.hasCache) {
      return const BackendFailure(OfflineNoCacheError());
    }
    final items =
        fake._studentAssignments.values
            .map(
              (item) => fake._pendingSubmissions.contains(item.id)
                  ? item.copyWith(state: StudentAssignmentState.submitted)
                  : item,
            )
            .toList()
          ..sort((a, b) => a.id.compareTo(b.id));
    return BackendOk(
      StudentAssignmentList(assignments: items),
      cachedAt: fake.isOnline ? fake._touchRefresh() : fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }

  @override
  Future<BackendResult<StudentAssignmentDetail>> studentAssignment(
    int assignmentId,
  ) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) return BackendFailure(denial);
    final assignment = fake._studentAssignments[assignmentId];
    if (assignment == null) {
      return const BackendFailure(PermissionDeniedError());
    }
    if (!fake.isOnline && !fake.hasCache) {
      return const BackendFailure(OfflineNoCacheError());
    }
    final exercise = fake._exercises[assignment.exerciseId]!;
    return BackendOk(
      StudentAssignmentDetail(
        assignment: assignment,
        exercise: StudentExerciseDetail(
          id: exercise.id,
          contentId: exercise.contentId,
          title: exercise.title,
          subject: exercise.subject,
          gradeLevel: exercise.gradeLevel,
          lessonContentId: exercise.lessonContentId,
          lessonTitle: assignment.lessonTitle,
          questions: [
            for (final (index, question) in exercise.questions.indexed)
              StudentQuestion(
                id: question.id ?? index + 1,
                position: question.position,
                stem: question.stem,
                multiSelect: question.multiSelect,
                options: [
                  for (final (optionIndex, option) in question.options.indexed)
                    StudentOption(
                      id: index * 10 + optionIndex + 1,
                      position: optionIndex,
                      text: option,
                    ),
                ],
              ),
          ],
        ),
        lessonCompleted:
            assignment.lessonContentId != null &&
            fake._completedLessons.contains(assignment.lessonContentId),
      ),
      cachedAt: fake.isOnline ? fake._touchRefresh() : fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }

  @override
  Future<BackendResult<ProgressResult>> markLessonComplete(
    int contentId,
  ) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) return BackendFailure(denial);
    fake._completedLessons.add(contentId);
    return BackendOk(
      ProgressResult(
        contentId: contentId,
        status: 'completed',
        updatedAt: fake._clock().toUtc(),
      ),
      cachedAt: fake._touchRefresh(),
    );
  }

  @override
  Future<BackendResult<SubmissionResult>> submit({
    required int assignmentId,
    required List<SubmittedAnswer> answers,
  }) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) return BackendFailure(denial);
    final assignment = fake._studentAssignments[assignmentId];
    if (assignment == null) {
      return const BackendFailure(PermissionDeniedError());
    }
    final clientId = 'fake-$assignmentId-${fake._submissions.length + 1}';
    if (!fake.isOnline) {
      fake._pendingSubmissions.add(assignmentId);
      fake._studentAssignments[assignmentId] = assignment.copyWith(
        state: StudentAssignmentState.submitted,
      );
      return BackendOk(
        SubmissionResult(
          id: -1,
          assignmentId: assignmentId,
          clientSubmissionId: clientId,
          status: SubmissionStatus.submitted,
          late: false,
          answers: answers,
        ),
        cachedAt: fake._touchRefresh(),
      );
    }
    final result = _grade(assignment, clientId, answers);
    fake._submissions[assignmentId] = result;
    fake._pendingSubmissions.remove(assignmentId);
    fake._studentAssignments[assignmentId] = assignment.copyWith(
      state: StudentAssignmentState.graded,
      score: result.score,
      maxScore: result.maxScore,
      submissionId: result.id,
      clientSubmissionId: clientId,
    );
    for (final item in fake._teacherAssignments) {
      if (item.id == assignmentId) {
        item.submissionCount = 1;
        item.gradedCount = 1;
      }
    }
    return BackendOk(result, cachedAt: fake._touchRefresh());
  }

  SubmissionResult _grade(
    StudentAssignmentItem assignment,
    String clientId,
    List<SubmittedAnswer> answers,
  ) {
    const keys = {
      1: [1],
      2: [1],
      3: [0, 1, 3],
    };
    var correct = 0;
    for (final entry in keys.entries) {
      final selected = answers
          .where((answer) => answer.questionId == entry.key)
          .expand((answer) => answer.selectedPositions)
          .toSet();
      if (selected.length == entry.value.length &&
          selected.containsAll(entry.value)) {
        correct++;
      }
    }
    final score = (correct / keys.length * 10 * 10).round() / 10;
    return SubmissionResult(
      id: fake._submissions.length + 1,
      assignmentId: assignment.id,
      clientSubmissionId: clientId,
      status: SubmissionStatus.graded,
      score: score,
      maxScore: 10,
      late: false,
      submittedAt: fake._clock().toUtc(),
      gradedAt: fake._clock().toUtc(),
      gradedBy: GradedBy.auto,
      answers: answers,
    );
  }

  @override
  Future<BackendResult<SubmissionResult?>> submissionFor(
    int assignmentId,
  ) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) return BackendFailure(denial);
    return BackendOk(
      fake._submissions[assignmentId],
      cachedAt: fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }

  @override
  Future<BackendResult<TestStartResult>> startTest(int assignmentId) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) return BackendFailure(denial);
    if (!fake.isOnline) return const BackendFailure(BackendUnreachableError());
    final assignment = fake._studentAssignments[assignmentId];
    if (assignment == null) {
      return const BackendFailure(PermissionDeniedError());
    }
    final now = fake._clock().toUtc();
    final result = TestStartResult(
      assignmentId: assignmentId,
      submissionId: 0,
      clientSubmissionId: 'fake-test-$assignmentId',
      startedAt: now,
      deadline: now.add(Duration(seconds: assignment.timeLimitSec ?? 120)),
    );
    fake._tests[assignmentId] = result;
    fake._studentAssignments[assignmentId] = assignment.copyWith(
      state: StudentAssignmentState.inProgress,
    );
    return BackendOk(result, cachedAt: fake._touchRefresh());
  }

  @override
  Future<BackendResult<TestStartResult?>> activeTest() async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) return BackendFailure(denial);
    final active = fake._tests.values.isEmpty ? null : fake._tests.values.first;
    return BackendOk(
      active,
      cachedAt: fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }

  @override
  Future<void> saveTestAnswers(
    int assignmentId,
    List<SubmittedAnswer> answers,
  ) async {
    fake._testAnswers[assignmentId] = answers;
  }

  @override
  Future<List<SubmittedAnswer>> loadTestAnswers(int assignmentId) async =>
      fake._testAnswers[assignmentId] ?? const [];

  @override
  Future<void> syncOutbox() async {
    if (!fake.isOnline) return;
    for (final id in fake._pendingSubmissions.toList()) {
      final assignment = fake._studentAssignments[id];
      if (assignment == null) continue;
      final answers = fake._testAnswers[id] ?? const <SubmittedAnswer>[];
      fake._submissions[id] = _grade(
        assignment,
        'fake-sync-$id',
        answers,
      );
      fake._studentAssignments[id] = assignment.copyWith(
        state: StudentAssignmentState.graded,
        score: fake._submissions[id]!.score,
        maxScore: 10,
        submissionId: fake._submissions[id]!.id,
        clientSubmissionId: fake._submissions[id]!.clientSubmissionId,
      );
      fake._pendingSubmissions.remove(id);
    }
  }

  @override
  Future<BackendResult<SubmissionResult>> regrade(int submissionId) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    for (final entry in fake._submissions.entries) {
      if (entry.value.id == submissionId) {
        final assignment = fake._studentAssignments[entry.key]!;
        final result = _grade(
          assignment,
          entry.value.clientSubmissionId,
          entry.value.answers,
        );
        fake._submissions[entry.key] = result;
        return BackendOk(result, cachedAt: fake._touchRefresh());
      }
    }
    return const BackendFailure(OfflineNoCacheError());
  }

  @override
  Future<bool> hasPendingSubmission(int assignmentId) async =>
      fake._pendingSubmissions.contains(assignmentId);

  @override
  Future<BackendResult<ClassResults>> classResults(int classId) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    final assignmentRows = fake._teacherAssignments
        .where((row) => row.classId == classId)
        .toList();
    return BackendOk(
      ClassResults(
        classId: classId,
        className: fake.fixtures.classByKey(FixtureKeys.class7A).name,
        students: [
          ResultStudent(
            id: 1,
            name: fake.fixtures.account(FixtureKeys.studentAn).name,
          ),
        ],
        assignments: [
          for (final assignment in assignmentRows)
            ResultAssignment(
              id: assignment.id,
              title: assignment.title,
              type: assignment.type,
              dueAt: assignment.dueAt,
              timeLimitSec: assignment.timeLimitSec,
            ),
        ],
        cells: [
          for (final assignment in assignmentRows)
            if (fake._submissions[assignment.id] case final submission?)
              ResultCell(
                studentId: 1,
                assignmentId: assignment.id,
                submissionId: submission.id,
                status: submission.status,
                score: submission.score,
                maxScore: submission.maxScore,
                late: submission.late,
                clientSubmissionId: submission.clientSubmissionId,
              ),
        ],
      ),
      cachedAt: fake.isOnline ? fake._touchRefresh() : fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }
}

class _FakeTutor implements TutorRepository {
  _FakeTutor(this.fake);

  final FakeBackend fake;

  @override
  Future<BackendResult<TutorState>> state() async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) return BackendFailure(denial);
    final classes = fake.fixtures.classesOfStudent(FixtureKeys.studentAn);
    return BackendOk(
      TutorState(
        subjects: [
          for (final schoolClass in classes)
            for (final subject in schoolClass.subjects)
              TutorSubject(
                classId: 1,
                className: schoolClass.name,
                subject: subject,
                gradeLevel: schoolClass.gradeLevel,
              ),
        ],
        usedToday: 0,
        dailyLimit: 30,
        remainingToday: 30,
        pausedForTest: fake._tests.isNotEmpty,
      ),
      cachedAt: fake.isOnline ? fake._touchRefresh() : fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }

  @override
  Future<BackendResult<List<TutorChatSummary>>> chats() async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) return BackendFailure(denial);
    return BackendOk(
      List<TutorChatSummary>.unmodifiable(fake._tutorChats),
      cachedAt: fake.isOnline ? fake._touchRefresh() : fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }

  @override
  Future<BackendResult<TutorChatDetail>> chat(int chatId) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) return BackendFailure(denial);
    final raw = fake._tutorDetails[chatId];
    if (raw == null) return const BackendFailure(OfflineNoCacheError());
    return BackendOk(
      TutorChatDetail.fromJson(
        (jsonDecode(raw) as Map).cast<String, dynamic>(),
      ),
      cachedAt: fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }

  @override
  Stream<TutorEvent> ask({
    required String subject,
    required String message,
    int? chatId,
  }) async* {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.student);
    if (denial != null) throw BackendException(denial);
    if (!fake.isOnline) {
      throw const BackendException(BackendUnreachableError());
    }
    final id =
        chatId ?? (fake._tutorChats.isEmpty ? 1 : fake._tutorChats.last.id + 1);
    final now = fake._clock().toUtc();
    final chunks = [
      'Mình cùng xem câu hỏi này nhé. ',
      'Em thử tóm tắt ý chính trước, rồi mình đi từng bước.',
      '\n\nĐây là gợi ý từ gia sư EduBox.',
    ];
    for (final chunk in chunks) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
      yield TutorEvent(type: TutorEventType.delta, chatId: id, delta: chunk);
    }
    fake._tutorChats
      ..removeWhere((row) => row.id == id)
      ..add(
        TutorChatSummary(
          id: id,
          subject: subject,
          title: message,
          createdAt: now,
          updatedAt: now,
          messageCount: 2,
          studentName: fake.fixtures.account(FixtureKeys.studentAn).name,
        ),
      );
    fake._tutorDetails[id] = jsonEncode(
      TutorChatDetail(
        id: id,
        subject: subject,
        title: message,
        createdAt: now,
        updatedAt: now,
        studentName: fake.fixtures.account(FixtureKeys.studentAn).name,
        messages: [
          TutorMessage(
            id: 1,
            role: ChatRole.student,
            content: message,
            createdAt: now,
          ),
          TutorMessage(
            id: 2,
            role: ChatRole.tutor,
            content: chunks.join(),
            createdAt: now,
          ),
        ],
      ).toJson(),
    );
    yield TutorEvent(type: TutorEventType.done, chatId: id);
  }

  @override
  Future<BackendResult<List<TutorChatSummary>>> classChats(
    int studentId,
  ) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    return BackendOk(
      List<TutorChatSummary>.unmodifiable(fake._tutorChats),
      cachedAt: fake.isOnline ? fake._touchRefresh() : fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }

  @override
  Future<BackendResult<TutorChatDetail>> classChat(int chatId) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.teacher);
    if (denial != null) return BackendFailure(denial);
    final raw = fake._tutorDetails[chatId];
    if (raw == null) return const BackendFailure(OfflineNoCacheError());
    return BackendOk(
      TutorChatDetail.fromJson(
        (jsonDecode(raw) as Map).cast<String, dynamic>(),
      ),
      cachedAt: fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }
}

class _FakeParent implements ParentRepository {
  _FakeParent(this.fake);

  final FakeBackend fake;

  @override
  Future<BackendResult<ParentHomeData>> home() async {
    await fake._wait();
    if (fake.parentError != null) {
      return BackendFailure(fake.parentError!);
    }
    final denial = fake._roleFailure(UserRole.parent);
    if (denial != null) return BackendFailure(denial);
    return fake._dataResult('parent', fake._parentHome);
  }

  @override
  Future<BackendResult<ParentSummary>> summary() async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.parent);
    if (denial != null) return BackendFailure(denial);
    final parent = fake._signedInAccount!;
    final linked = parent.linkedStudentKey == null
        ? null
        : fake.fixtures.account(parent.linkedStudentKey!);
    final classes = linked == null
        ? const <ClassFixture>[]
        : fake.fixtures.classesOfStudent(linked.key);
    return BackendOk(
      ParentSummary(
        linkedStudentName: linked?.name,
        className: classes.isEmpty ? null : classes.first.name,
        results: [
          for (final assignment in fake._studentAssignments.values)
            if (fake._submissions[assignment.id] case final submission?)
              ParentResultEntry(
                assignmentId: assignment.id,
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
        chats: List<TutorChatSummary>.unmodifiable(fake._tutorChats),
      ),
      cachedAt: fake.isOnline ? fake._touchRefresh() : fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }

  @override
  Future<BackendResult<List<TutorChatSummary>>> chats() async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.parent);
    if (denial != null) return BackendFailure(denial);
    return BackendOk(
      List<TutorChatSummary>.unmodifiable(fake._tutorChats),
      cachedAt: fake.isOnline ? fake._touchRefresh() : fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }

  @override
  Future<BackendResult<TutorChatDetail>> chat(int chatId) async {
    await fake._wait();
    final denial = fake._roleFailure(UserRole.parent);
    if (denial != null) return BackendFailure(denial);
    final raw = fake._tutorDetails[chatId];
    if (raw == null) return const BackendFailure(OfflineNoCacheError());
    return BackendOk(
      TutorChatDetail.fromJson(
        (jsonDecode(raw) as Map).cast<String, dynamic>(),
      ),
      cachedAt: fake.lastRefreshAt,
      isStale: !fake.isOnline,
    );
  }
}

class _FakeDiagnostics implements DiagnosticsRepository {
  _FakeDiagnostics(this.fake);

  final FakeBackend fake;

  static const total = 3;

  @override
  Stream<PingMessage> pingStream() async* {
    await fake._wait();
    if (fake.pingError != null) {
      throw BackendException(fake.pingError!);
    }
    if (!fake.isOnline) {
      throw const BackendException(BackendUnreachableError());
    }
    final session = fake._sessionForCall();
    if (session == null) {
      throw const BackendException(SessionExpiredError());
    }
    if (session.isNotSetUp) {
      throw const BackendException(NotSetUpError());
    }
    for (var sequence = 1; sequence <= total; sequence++) {
      if (sequence > 1) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
      yield PingMessage(
        sequence: sequence,
        total: total,
        role: session.role!,
        sentAt: DateTime.now().toUtc(),
      );
    }
  }
}
