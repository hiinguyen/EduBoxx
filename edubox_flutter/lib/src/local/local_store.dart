import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:edubox_client/edubox_client.dart';

import '../contract/outbox.dart';
import '../contract/session.dart';
import 'local_store_platform_io.dart'
    if (dart.library.js_interop) 'local_store_platform_web.dart';

part 'local_store.g.dart';

/// Marker rows that distinguish "cached empty" from "never cached".
class CachedSnapshots extends Table {
  TextColumn get kind => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {kind};
}

/// The signed-in session and its server-resolved profile/role.
class CachedProfiles extends Table {
  TextColumn get signedInEmail => text()();
  TextColumn get status => text()();
  IntColumn get userId => integer().nullable()();
  TextColumn get role => text().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get linkedStudentName => text().nullable()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {signedInEmail};
}

/// Teacher-home rows (`classes.mine`).
class CachedClasses extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get gradeLevel => integer()();
  TextColumn get subjectsJson => text()();
  IntColumn get studentCount => integer()();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Student-library classes (`content.library.classes`).
class CachedLibraryClasses extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get gradeLevel => integer()();
  TextColumn get subjectsJson => text()();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Student-library items (`content.library.items`).
class CachedLibraryItems extends Table {
  IntColumn get id => integer()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get subject => text()();
  IntColumn get gradeLevel => integer()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get hasFile => boolean().withDefault(const Constant(false))();
  TextColumn get mimeType => text().nullable()();
  IntColumn get sizeBytes => integer().nullable()();
  IntColumn get pageCount => integer().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One parent-home row (kept for the phase 1 shape; phase 6 adds documents).
class CachedParentHomes extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get linkedStudentName => text().nullable()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Generic JSON snapshots for the phase 2-6 read paths (assignment lists,
/// exercise details, tutor transcripts, parent summaries). The payload is the
/// generated DTO's `toJson()` map, so the same cache serves every model.
class CachedDocuments extends Table {
  TextColumn get kind => text()();
  TextColumn get key => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {kind, key};
}

/// Downloaded e-book/video files in the app's content cache.
class DownloadedContents extends Table {
  IntColumn get contentId => integer()();
  TextColumn get localPath => text()();
  TextColumn get title => text()();
  TextColumn get type => text()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get pageCount => integer().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  DateTimeColumn get downloadedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {contentId};
}

/// A timed test the student started, kept on disk so an in-process restart
/// resumes the same attempt and its saved answers.
class TestAttempts extends Table {
  IntColumn get assignmentId => integer()();
  TextColumn get clientSubmissionId => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get deadline => dateTime()();
  TextColumn get answersJson => text()();
  BoolColumn get submitted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {assignmentId};
}

/// The phase 1 outbox table. No phase 1 screen writes through it yet.
class OutboxEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operation => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get state => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
}

@DriftDatabase(
  tables: [
    CachedSnapshots,
    CachedProfiles,
    CachedClasses,
    CachedLibraryClasses,
    CachedLibraryItems,
    CachedParentHomes,
    CachedDocuments,
    DownloadedContents,
    TestAttempts,
    OutboxEntries,
  ],
)
class EduBoxDatabase extends _$EduBoxDatabase {
  EduBoxDatabase(super.e);

  /// A throwaway database for tests and previews. Native-only; on the web it
  /// throws [UnsupportedError].
  factory EduBoxDatabase.inMemory() => EduBoxDatabase(openInMemoryExecutor());

  /// Opens the phase 1 store. Native builds pass a `File`; the web build
  /// passes the browser database name.
  factory EduBoxDatabase.open(DatabaseLocation location) =>
      EduBoxDatabase(openDatabaseExecutor(location));

  @override
  int get schemaVersion => 2;
}

/// A cached value together with the time of the last successful server
/// refresh that produced it. Data repositories surface this time as
/// `BackendOk.cachedAt` (and `isStale` for an offline read).
class CachedValue<T> {
  const CachedValue({required this.value, required this.cachedAt});

  final T value;
  final DateTime cachedAt;
}

/// Read/write access to the phase 1 drift cache.
///
/// The frontend track composes this with the network seam: online calls save
/// snapshots here, offline calls read them, and a missing marker is the
/// "offline without cache" state. The local store is never the source of
/// authorization; it only mirrors the last server answer.
class CachedDataStore {
  CachedDataStore(this.db);

  final EduBoxDatabase db;

  static const _sessionKind = 'session';
  static const _teacherClassesKind = 'teacherClasses';
  static const _studentLibraryKind = 'studentLibrary';
  static const _parentHomeKind = 'parentHome';

  Future<void> saveSession(AuthSession session) async {
    final profile = session.profile;
    final now = DateTime.now().toUtc();
    await db.transaction(() async {
      // One session at a time: a sign-in as another account replaces the row.
      await db.delete(db.cachedProfiles).go();
      await db
          .into(db.cachedProfiles)
          .insertOnConflictUpdate(
            CachedProfilesCompanion.insert(
              signedInEmail: session.signedInEmail,
              status: session.status.name,
              userId: Value(profile?.userId),
              role: Value(profile?.role.name),
              name: Value(profile?.name),
              email: Value(profile?.email),
              linkedStudentName: Value(profile?.linkedStudentName),
              cachedAt: now,
            ),
          );
      await _markSnapshot(_sessionKind, now);
    });
  }

  Future<CachedValue<AuthSession>?> readSession() async {
    final cachedAt = await _snapshotTime(_sessionKind);
    if (cachedAt == null) return null;
    final row = await db.select(db.cachedProfiles).getSingleOrNull();
    if (row == null) return null;
    return CachedValue(
      value: AuthSession(
        signedInEmail: row.signedInEmail,
        profileResult: _profileResultFromRow(row),
      ),
      cachedAt: cachedAt,
    );
  }

  Future<void> clearSession() async {
    await db.transaction(() async {
      await db.delete(db.cachedProfiles).go();
      await _deleteSnapshot(_sessionKind);
    });
  }

  Future<void> saveTeacherClasses(List<ClassSummary> classes) async {
    final now = DateTime.now().toUtc();
    await db.transaction(() async {
      await db.delete(db.cachedClasses).go();
      await db.batch((batch) {
        batch.insertAll(db.cachedClasses, [
          for (final (position, item) in classes.indexed)
            CachedClassesCompanion.insert(
              id: Value(item.id),
              name: item.name,
              gradeLevel: item.gradeLevel,
              subjectsJson: jsonEncode(item.subjects),
              studentCount: item.studentCount,
              position: position,
            ),
        ]);
      });
      await _markSnapshot(_teacherClassesKind, now);
    });
  }

  Future<CachedValue<List<ClassSummary>>?> readTeacherClasses() async {
    final cachedAt = await _snapshotTime(_teacherClassesKind);
    if (cachedAt == null) return null;
    final rows = await (db.select(
      db.cachedClasses,
    )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
    return CachedValue(
      value: [
        for (final row in rows)
          ClassSummary(
            id: row.id,
            name: row.name,
            gradeLevel: row.gradeLevel,
            subjects: _stringList(row.subjectsJson),
            studentCount: row.studentCount,
          ),
      ],
      cachedAt: cachedAt,
    );
  }

  Future<void> saveStudentLibrary(StudentLibrary library) async {
    final now = DateTime.now().toUtc();
    await db.transaction(() async {
      await db.delete(db.cachedLibraryClasses).go();
      await db.delete(db.cachedLibraryItems).go();
      await db.batch((batch) {
        batch.insertAll(db.cachedLibraryClasses, [
          for (final (position, item) in library.classes.indexed)
            CachedLibraryClassesCompanion.insert(
              id: Value(item.id),
              name: item.name,
              gradeLevel: item.gradeLevel,
              subjectsJson: jsonEncode(item.subjects),
              position: position,
            ),
        ]);
        batch.insertAll(db.cachedLibraryItems, [
          for (final (position, item) in library.items.indexed)
            CachedLibraryItemsCompanion.insert(
              id: Value(item.id),
              type: item.type.name,
              title: item.title,
              subject: item.subject,
              gradeLevel: item.gradeLevel,
              createdAt: item.createdAt,
              hasFile: Value(item.hasFile),
              mimeType: Value(item.mimeType),
              sizeBytes: Value(item.sizeBytes),
              pageCount: Value(item.pageCount),
              durationSeconds: Value(item.durationSeconds),
              position: position,
            ),
        ]);
      });
      await _markSnapshot(_studentLibraryKind, now);
    });
  }

  Future<CachedValue<StudentLibrary>?> readStudentLibrary() async {
    final cachedAt = await _snapshotTime(_studentLibraryKind);
    if (cachedAt == null) return null;
    final classRows = await (db.select(
      db.cachedLibraryClasses,
    )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
    final itemRows = await (db.select(
      db.cachedLibraryItems,
    )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
    return CachedValue(
      value: StudentLibrary(
        classes: [
          for (final row in classRows)
            StudentClass(
              id: row.id,
              name: row.name,
              gradeLevel: row.gradeLevel,
              subjects: _stringList(row.subjectsJson),
            ),
        ],
        items: [
          for (final row in itemRows)
            LibraryItem(
              id: row.id,
              type: ContentType.values.byName(row.type),
              title: row.title,
              subject: row.subject,
              gradeLevel: row.gradeLevel,
              createdAt: row.createdAt,
              hasFile: row.hasFile,
              mimeType: row.mimeType,
              sizeBytes: row.sizeBytes,
              pageCount: row.pageCount,
              durationSeconds: row.durationSeconds,
            ),
        ],
      ),
      cachedAt: cachedAt,
    );
  }

  Future<void> saveParentHome(ParentHomeData data) async {
    final now = DateTime.now().toUtc();
    await db.transaction(() async {
      await db
          .into(db.cachedParentHomes)
          .insertOnConflictUpdate(
            CachedParentHomesCompanion.insert(
              id: const Value(0),
              linkedStudentName: Value(data.linkedStudentName),
              cachedAt: now,
            ),
          );
      await _markSnapshot(_parentHomeKind, now);
    });
  }

  Future<CachedValue<ParentHomeData>?> readParentHome() async {
    final cachedAt = await _snapshotTime(_parentHomeKind);
    if (cachedAt == null) return null;
    final row = await db.select(db.cachedParentHomes).getSingleOrNull();
    if (row == null) return null;
    return CachedValue(
      value: ParentHomeData(linkedStudentName: row.linkedStudentName),
      cachedAt: cachedAt,
    );
  }

  /// Saves a generated DTO's `toJson()` under a document kind and key.
  Future<void> saveDocument({
    required String kind,
    required String key,
    required Map<String, Object?> payload,
  }) async {
    final now = DateTime.now().toUtc();
    await db
        .into(db.cachedDocuments)
        .insertOnConflictUpdate(
          CachedDocumentsCompanion.insert(
            kind: kind,
            key: key,
            payloadJson: jsonEncode(payload),
            cachedAt: now,
          ),
        );
  }

  Future<CachedValue<Map<String, Object?>>?> readDocument({
    required String kind,
    required String key,
  }) async {
    final row = await (db.select(
      db.cachedDocuments,
    )..where((t) => t.kind.equals(kind) & t.key.equals(key))).getSingleOrNull();
    if (row == null) return null;
    final decoded = jsonDecode(row.payloadJson);
    if (decoded is! Map<String, Object?>) return null;
    return CachedValue(value: decoded, cachedAt: row.cachedAt);
  }

  Future<List<CachedValue<Map<String, Object?>>>> readDocumentsByKind(
    String kind,
  ) async {
    final rows =
        await (db.select(db.cachedDocuments)
              ..where((t) => t.kind.equals(kind))
              ..orderBy([(t) => OrderingTerm.desc(t.cachedAt)]))
            .get();
    return [
      for (final row in rows)
        if (jsonDecode(row.payloadJson) case final Map<String, Object?> value)
          CachedValue(value: value, cachedAt: row.cachedAt),
    ];
  }

  Future<void> deleteDocuments(String kind) async {
    await (db.delete(
      db.cachedDocuments,
    )..where((t) => t.kind.equals(kind))).go();
  }

  Future<void> saveDownload({
    required int contentId,
    required String localPath,
    required String title,
    required String type,
    String? mimeType,
    int? pageCount,
    int? durationSeconds,
  }) async {
    await db
        .into(db.downloadedContents)
        .insertOnConflictUpdate(
          DownloadedContentsCompanion.insert(
            contentId: Value(contentId),
            localPath: localPath,
            title: title,
            type: type,
            mimeType: Value(mimeType),
            pageCount: Value(pageCount),
            durationSeconds: Value(durationSeconds),
            downloadedAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<StoredDownload?> readDownload(int contentId) async {
    final row = await (db.select(
      db.downloadedContents,
    )..where((t) => t.contentId.equals(contentId))).getSingleOrNull();
    return row == null
        ? null
        : StoredDownload(
            contentId: row.contentId,
            localPath: row.localPath,
            title: row.title,
            type: ContentType.values.byName(row.type),
            mimeType: row.mimeType,
            pageCount: row.pageCount,
            durationSeconds: row.durationSeconds,
            downloadedAt: row.downloadedAt,
          );
  }

  Future<void> deleteDownload(int contentId) async {
    await (db.delete(
      db.downloadedContents,
    )..where((t) => t.contentId.equals(contentId))).go();
  }

  Future<void> saveTestAttempt(StoredTestAttempt attempt) async {
    await db
        .into(db.testAttempts)
        .insertOnConflictUpdate(
          TestAttemptsCompanion.insert(
            assignmentId: Value(attempt.assignmentId),
            clientSubmissionId: attempt.clientSubmissionId,
            startedAt: attempt.startedAt,
            deadline: attempt.deadline,
            answersJson: jsonEncode({
              for (final answer in attempt.answers)
                '${answer.questionId}': answer.selectedPositions,
            }),
            submitted: Value(attempt.submitted),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<void> saveTestAnswers({
    required int assignmentId,
    required List<SubmittedAnswer> answers,
  }) async {
    final row = await (db.select(
      db.testAttempts,
    )..where((t) => t.assignmentId.equals(assignmentId))).getSingleOrNull();
    if (row == null) return;
    await (db.update(
      db.testAttempts,
    )..where((t) => t.assignmentId.equals(assignmentId))).write(
      TestAttemptsCompanion(
        answersJson: Value(
          jsonEncode({
            for (final answer in answers)
              '${answer.questionId}': answer.selectedPositions,
          }),
        ),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<StoredTestAttempt?> readTestAttempt(int assignmentId) async {
    final row = await (db.select(
      db.testAttempts,
    )..where((t) => t.assignmentId.equals(assignmentId))).getSingleOrNull();
    if (row == null) return null;
    final decoded = jsonDecode(row.answersJson);
    final answers = <SubmittedAnswer>[];
    if (decoded is Map<String, Object?>) {
      for (final entry in decoded.entries) {
        final id = int.tryParse(entry.key);
        if (id == null || entry.value is! List) continue;
        answers.add(
          SubmittedAnswer(
            questionId: id,
            selectedPositions: [
              for (final value in entry.value! as List)
                if (value is int) value,
            ],
          ),
        );
      }
    }
    return StoredTestAttempt(
      assignmentId: row.assignmentId,
      clientSubmissionId: row.clientSubmissionId,
      startedAt: row.startedAt,
      deadline: row.deadline,
      answers: answers,
      submitted: row.submitted,
    );
  }

  Future<StoredTestAttempt?> readActiveTest() async {
    final rows =
        await (db.select(db.testAttempts)
              ..where((t) => t.submitted.equals(false))
              ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
            .get();
    if (rows.isEmpty) return null;
    return readTestAttempt(rows.first.assignmentId);
  }

  Future<void> clearTestAttempt(int assignmentId) async {
    await (db.delete(
      db.testAttempts,
    )..where((t) => t.assignmentId.equals(assignmentId))).go();
  }

  Future<void> clearAll() async {
    await db.transaction(() async {
      await db.delete(db.cachedProfiles).go();
      await db.delete(db.cachedClasses).go();
      await db.delete(db.cachedLibraryClasses).go();
      await db.delete(db.cachedLibraryItems).go();
      await db.delete(db.cachedParentHomes).go();
      await db.delete(db.cachedDocuments).go();
      await db.delete(db.downloadedContents).go();
      await db.delete(db.testAttempts).go();
      await db.delete(db.cachedSnapshots).go();
      await db.delete(db.outboxEntries).go();
    });
  }

  Future<void> close() => db.close();

  Future<DateTime?> _snapshotTime(String kind) async {
    final query = db.select(db.cachedSnapshots)
      ..where((t) => t.kind.equals(kind));
    final row = await query.getSingleOrNull();
    return row?.cachedAt;
  }

  Future<void> _markSnapshot(String kind, DateTime cachedAt) async {
    await db
        .into(db.cachedSnapshots)
        .insertOnConflictUpdate(
          CachedSnapshotsCompanion.insert(kind: kind, cachedAt: cachedAt),
        );
  }

  Future<void> _deleteSnapshot(String kind) async {
    await (db.delete(
      db.cachedSnapshots,
    )..where((t) => t.kind.equals(kind))).go();
  }

  static List<String> _stringList(String json) => [
    for (final value in jsonDecode(json) as List<Object?>) value! as String,
  ];

  static ProfileResult _profileResultFromRow(CachedProfile row) {
    final role = row.role == null
        ? null
        : UserRole.values.asNameMap()[row.role];
    if (row.status != ProfileStatus.ready.name ||
        role == null ||
        row.userId == null ||
        row.name == null ||
        row.email == null) {
      return ProfileResult(
        status: ProfileStatus.notSetUp,
        signedInEmail: row.signedInEmail,
      );
    }
    return ProfileResult(
      status: ProfileStatus.ready,
      signedInEmail: row.signedInEmail,
      profile: Profile(
        userId: row.userId!,
        role: role,
        name: row.name!,
        email: row.email!,
        linkedStudentName: row.linkedStudentName,
      ),
    );
  }
}

/// A downloaded file's cached metadata.
class StoredDownload {
  const StoredDownload({
    required this.contentId,
    required this.localPath,
    required this.title,
    required this.type,
    required this.mimeType,
    required this.pageCount,
    required this.durationSeconds,
    required this.downloadedAt,
  });

  final int contentId;
  final String localPath;
  final String title;
  final ContentType type;
  final String? mimeType;
  final int? pageCount;
  final int? durationSeconds;
  final DateTime downloadedAt;
}

/// A test attempt persisted on disk (in-process restart survival).
class StoredTestAttempt {
  const StoredTestAttempt({
    required this.assignmentId,
    required this.clientSubmissionId,
    required this.startedAt,
    required this.deadline,
    required this.answers,
    required this.submitted,
  });

  final int assignmentId;
  final String clientSubmissionId;
  final DateTime startedAt;
  final DateTime deadline;
  final List<SubmittedAnswer> answers;
  final bool submitted;

  Duration remainingAt(DateTime now) {
    final remaining = deadline.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

/// The drift-backed outbox, implementing the phase 1 interface.
class DriftOutbox implements Outbox {
  DriftOutbox(this.db);

  final EduBoxDatabase db;

  @override
  Future<int> enqueue(OutboxWrite write) => db
      .into(db.outboxEntries)
      .insert(
        OutboxEntriesCompanion.insert(
          operation: write.operation,
          payloadJson: jsonEncode(write.payload),
          createdAt: write.createdAt,
          state: write.state.name,
          attempts: Value(write.attempts),
          lastError: Value(write.lastError),
        ),
      );

  @override
  Future<List<OutboxWrite>> pending() async {
    final rows = await _orderedRows(
      (t) => t.state.equals(OutboxState.pending.name),
    );
    return rows.map(_toWrite).toList();
  }

  @override
  Future<List<OutboxWrite>> all() async {
    final rows = await _orderedRows();
    return rows.map(_toWrite).toList();
  }

  @override
  Future<void> markSent(int id) async {
    await (db.delete(db.outboxEntries)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> markFailed(int id, String reason) async {
    final row = await (db.select(
      db.outboxEntries,
    )..where((t) => t.id.equals(id))).getSingle();
    await (db.update(
      db.outboxEntries,
    )..where((t) => t.id.equals(id))).write(
      OutboxEntriesCompanion(
        state: Value(OutboxState.failed.name),
        attempts: Value(row.attempts + 1),
        lastError: Value(reason),
      ),
    );
  }

  @override
  Future<void> retry(int id) async {
    await (db.update(
      db.outboxEntries,
    )..where((t) => t.id.equals(id))).write(
      const OutboxEntriesCompanion(
        state: Value('pending'),
        lastError: Value(null),
      ),
    );
  }

  Future<List<OutboxEntry>> _orderedRows([
    Expression<bool> Function(OutboxEntries table)? where,
  ]) {
    final query = db.select(db.outboxEntries)
      ..orderBy([(t) => OrderingTerm.asc(t.id)]);
    if (where != null) query.where(where);
    return query.get();
  }

  static OutboxWrite _toWrite(OutboxEntry row) => OutboxWrite(
    id: row.id,
    operation: row.operation,
    payload: (jsonDecode(row.payloadJson) as Map<String, dynamic>)
        .cast<String, Object?>(),
    createdAt: row.createdAt,
    state: OutboxState.values.byName(row.state),
    attempts: row.attempts,
    lastError: row.lastError,
  );
}
