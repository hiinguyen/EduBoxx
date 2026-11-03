/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import '../enums/graded_by.dart' as _ixjnete7;
import '../enums/submission_status.dart' as _ikv3vevs;

abstract class Submission
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Submission._({
    this.id,
    required this.assignmentId,
    required this.studentId,
    required this.clientSubmissionId,
    required this.status,
    required this.answersJson,
    this.answerKeySnapshotJson,
    required this.answerKeyVersion,
    this.score,
    this.maxScore,
    required this.late,
    this.startedAt,
    this.submittedAt,
    this.gradedAt,
    this.gradedBy,
    this.failureReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Submission({
    int? id,
    required int assignmentId,
    required int studentId,
    required String clientSubmissionId,
    required _ikv3vevs.SubmissionStatus status,
    required String answersJson,
    String? answerKeySnapshotJson,
    required int answerKeyVersion,
    double? score,
    double? maxScore,
    required bool late,
    DateTime? startedAt,
    DateTime? submittedAt,
    DateTime? gradedAt,
    _ixjnete7.GradedBy? gradedBy,
    String? failureReason,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SubmissionImpl;

  factory Submission.fromJson(Map<String, dynamic> jsonSerialization) {
    return Submission(
      id: jsonSerialization['id'] as int?,
      assignmentId: jsonSerialization['assignmentId'] as int,
      studentId: jsonSerialization['studentId'] as int,
      clientSubmissionId: jsonSerialization['clientSubmissionId'] as String,
      status: _ikv3vevs.SubmissionStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      answersJson: jsonSerialization['answersJson'] as String,
      answerKeySnapshotJson:
          jsonSerialization['answerKeySnapshotJson'] as String?,
      answerKeyVersion: jsonSerialization['answerKeyVersion'] as int,
      score: (jsonSerialization['score'] as num?)?.toDouble(),
      maxScore: (jsonSerialization['maxScore'] as num?)?.toDouble(),
      late: _is.BoolJsonExtension.fromJson(jsonSerialization['late']),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      submittedAt: jsonSerialization['submittedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['submittedAt'],
            ),
      gradedAt: jsonSerialization['gradedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['gradedAt']),
      gradedBy: jsonSerialization['gradedBy'] == null
          ? null
          : _ixjnete7.GradedBy.fromJson(
              (jsonSerialization['gradedBy'] as String),
            ),
      failureReason: jsonSerialization['failureReason'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = SubmissionTable();

  static const db = SubmissionRepository._();

  @override
  int? id;

  int assignmentId;

  int studentId;

  String clientSubmissionId;

  _ikv3vevs.SubmissionStatus status;

  String answersJson;

  String? answerKeySnapshotJson;

  int answerKeyVersion;

  double? score;

  double? maxScore;

  bool late;

  DateTime? startedAt;

  DateTime? submittedAt;

  DateTime? gradedAt;

  _ixjnete7.GradedBy? gradedBy;

  String? failureReason;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Submission]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Submission copyWith({
    int? id,
    int? assignmentId,
    int? studentId,
    String? clientSubmissionId,
    _ikv3vevs.SubmissionStatus? status,
    String? answersJson,
    String? answerKeySnapshotJson,
    int? answerKeyVersion,
    double? score,
    double? maxScore,
    bool? late,
    DateTime? startedAt,
    DateTime? submittedAt,
    DateTime? gradedAt,
    _ixjnete7.GradedBy? gradedBy,
    String? failureReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Submission',
      if (id != null) 'id': id,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'clientSubmissionId': clientSubmissionId,
      'status': status.toJson(),
      'answersJson': answersJson,
      if (answerKeySnapshotJson != null)
        'answerKeySnapshotJson': answerKeySnapshotJson,
      'answerKeyVersion': answerKeyVersion,
      if (score != null) 'score': score,
      if (maxScore != null) 'maxScore': maxScore,
      'late': late,
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (submittedAt != null) 'submittedAt': submittedAt?.toJson(),
      if (gradedAt != null) 'gradedAt': gradedAt?.toJson(),
      if (gradedBy != null) 'gradedBy': gradedBy?.toJson(),
      if (failureReason != null) 'failureReason': failureReason,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SubmissionInclude include() {
    return SubmissionInclude._();
  }

  static SubmissionIncludeList includeList({
    _is.WhereExpressionBuilder<SubmissionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SubmissionTable>? orderBy,
    _is.OrderByListBuilder<SubmissionTable>? orderByList,
    SubmissionInclude? include,
  }) {
    return SubmissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Submission.t),
      orderByList: orderByList?.call(Submission.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SubmissionImpl extends Submission {
  _SubmissionImpl({
    int? id,
    required int assignmentId,
    required int studentId,
    required String clientSubmissionId,
    required _ikv3vevs.SubmissionStatus status,
    required String answersJson,
    String? answerKeySnapshotJson,
    required int answerKeyVersion,
    double? score,
    double? maxScore,
    required bool late,
    DateTime? startedAt,
    DateTime? submittedAt,
    DateTime? gradedAt,
    _ixjnete7.GradedBy? gradedBy,
    String? failureReason,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         assignmentId: assignmentId,
         studentId: studentId,
         clientSubmissionId: clientSubmissionId,
         status: status,
         answersJson: answersJson,
         answerKeySnapshotJson: answerKeySnapshotJson,
         answerKeyVersion: answerKeyVersion,
         score: score,
         maxScore: maxScore,
         late: late,
         startedAt: startedAt,
         submittedAt: submittedAt,
         gradedAt: gradedAt,
         gradedBy: gradedBy,
         failureReason: failureReason,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Submission]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Submission copyWith({
    Object? id = _Undefined,
    int? assignmentId,
    int? studentId,
    String? clientSubmissionId,
    _ikv3vevs.SubmissionStatus? status,
    String? answersJson,
    Object? answerKeySnapshotJson = _Undefined,
    int? answerKeyVersion,
    Object? score = _Undefined,
    Object? maxScore = _Undefined,
    bool? late,
    Object? startedAt = _Undefined,
    Object? submittedAt = _Undefined,
    Object? gradedAt = _Undefined,
    Object? gradedBy = _Undefined,
    Object? failureReason = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Submission(
      id: id is int? ? id : this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      studentId: studentId ?? this.studentId,
      clientSubmissionId: clientSubmissionId ?? this.clientSubmissionId,
      status: status ?? this.status,
      answersJson: answersJson ?? this.answersJson,
      answerKeySnapshotJson: answerKeySnapshotJson is String?
          ? answerKeySnapshotJson
          : this.answerKeySnapshotJson,
      answerKeyVersion: answerKeyVersion ?? this.answerKeyVersion,
      score: score is double? ? score : this.score,
      maxScore: maxScore is double? ? maxScore : this.maxScore,
      late: late ?? this.late,
      startedAt: startedAt is DateTime? ? startedAt : this.startedAt,
      submittedAt: submittedAt is DateTime? ? submittedAt : this.submittedAt,
      gradedAt: gradedAt is DateTime? ? gradedAt : this.gradedAt,
      gradedBy: gradedBy is _ixjnete7.GradedBy? ? gradedBy : this.gradedBy,
      failureReason: failureReason is String?
          ? failureReason
          : this.failureReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SubmissionUpdateTable extends _is.UpdateTable<SubmissionTable> {
  SubmissionUpdateTable(super.table);

  _is.ColumnValue<int, int> assignmentId(int value) => _is.ColumnValue(
    table.assignmentId,
    value,
  );

  _is.ColumnValue<int, int> studentId(int value) => _is.ColumnValue(
    table.studentId,
    value,
  );

  _is.ColumnValue<String, String> clientSubmissionId(String value) =>
      _is.ColumnValue(
        table.clientSubmissionId,
        value,
      );

  _is.ColumnValue<_ikv3vevs.SubmissionStatus, _ikv3vevs.SubmissionStatus>
  status(_ikv3vevs.SubmissionStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> answersJson(String value) => _is.ColumnValue(
    table.answersJson,
    value,
  );

  _is.ColumnValue<String, String> answerKeySnapshotJson(String? value) =>
      _is.ColumnValue(
        table.answerKeySnapshotJson,
        value,
      );

  _is.ColumnValue<int, int> answerKeyVersion(int value) => _is.ColumnValue(
    table.answerKeyVersion,
    value,
  );

  _is.ColumnValue<double, double> score(double? value) => _is.ColumnValue(
    table.score,
    value,
  );

  _is.ColumnValue<double, double> maxScore(double? value) => _is.ColumnValue(
    table.maxScore,
    value,
  );

  _is.ColumnValue<bool, bool> late(bool value) => _is.ColumnValue(
    table.late,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> startedAt(DateTime? value) =>
      _is.ColumnValue(
        table.startedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> submittedAt(DateTime? value) =>
      _is.ColumnValue(
        table.submittedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> gradedAt(DateTime? value) =>
      _is.ColumnValue(
        table.gradedAt,
        value,
      );

  _is.ColumnValue<_ixjnete7.GradedBy, _ixjnete7.GradedBy> gradedBy(
    _ixjnete7.GradedBy? value,
  ) => _is.ColumnValue(
    table.gradedBy,
    value,
  );

  _is.ColumnValue<String, String> failureReason(String? value) =>
      _is.ColumnValue(
        table.failureReason,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class SubmissionTable extends _is.Table<int?> {
  SubmissionTable({super.tableRelation}) : super(tableName: 'submissions') {
    updateTable = SubmissionUpdateTable(this);
    assignmentId = _is.ColumnInt(
      'assignmentId',
      this,
    );
    studentId = _is.ColumnInt(
      'studentId',
      this,
    );
    clientSubmissionId = _is.ColumnString(
      'clientSubmissionId',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    answersJson = _is.ColumnString(
      'answersJson',
      this,
    );
    answerKeySnapshotJson = _is.ColumnString(
      'answerKeySnapshotJson',
      this,
    );
    answerKeyVersion = _is.ColumnInt(
      'answerKeyVersion',
      this,
    );
    score = _is.ColumnDouble(
      'score',
      this,
    );
    maxScore = _is.ColumnDouble(
      'maxScore',
      this,
    );
    late = _is.ColumnBool(
      'late',
      this,
    );
    startedAt = _is.ColumnDateTime(
      'startedAt',
      this,
    );
    submittedAt = _is.ColumnDateTime(
      'submittedAt',
      this,
    );
    gradedAt = _is.ColumnDateTime(
      'gradedAt',
      this,
    );
    gradedBy = _is.ColumnEnum(
      'gradedBy',
      this,
      _is.EnumSerialization.byName,
    );
    failureReason = _is.ColumnString(
      'failureReason',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final SubmissionUpdateTable updateTable;

  late final _is.ColumnInt assignmentId;

  late final _is.ColumnInt studentId;

  late final _is.ColumnString clientSubmissionId;

  late final _is.ColumnEnum<_ikv3vevs.SubmissionStatus> status;

  late final _is.ColumnString answersJson;

  late final _is.ColumnString answerKeySnapshotJson;

  late final _is.ColumnInt answerKeyVersion;

  late final _is.ColumnDouble score;

  late final _is.ColumnDouble maxScore;

  late final _is.ColumnBool late;

  late final _is.ColumnDateTime startedAt;

  late final _is.ColumnDateTime submittedAt;

  late final _is.ColumnDateTime gradedAt;

  late final _is.ColumnEnum<_ixjnete7.GradedBy> gradedBy;

  late final _is.ColumnString failureReason;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    assignmentId,
    studentId,
    clientSubmissionId,
    status,
    answersJson,
    answerKeySnapshotJson,
    answerKeyVersion,
    score,
    maxScore,
    late,
    startedAt,
    submittedAt,
    gradedAt,
    gradedBy,
    failureReason,
    createdAt,
    updatedAt,
  ];
}

class SubmissionInclude extends _is.IncludeObject {
  SubmissionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Submission.t;
}

class SubmissionIncludeList extends _is.IncludeList {
  SubmissionIncludeList._({
    _is.WhereExpressionBuilder<SubmissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Submission.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Submission.t;
}

class SubmissionRepository {
  const SubmissionRepository._();

  /// Returns a list of [Submission]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Submission>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SubmissionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SubmissionTable>? orderBy,
    _is.OrderByListBuilder<SubmissionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Submission>(
      where: where?.call(Submission.t),
      orderBy: orderBy?.call(Submission.t),
      orderByList: orderByList?.call(Submission.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Submission] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Submission?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SubmissionTable>? where,
    int? offset,
    _is.OrderByBuilder<SubmissionTable>? orderBy,
    _is.OrderByListBuilder<SubmissionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Submission>(
      where: where?.call(Submission.t),
      orderBy: orderBy?.call(Submission.t),
      orderByList: orderByList?.call(Submission.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Submission] by its [id] or null if no such row exists.
  Future<Submission?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Submission>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Submission]s in the list and returns the inserted rows.
  ///
  /// The returned [Submission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Submission>> insert(
    _is.DatabaseSession session,
    List<Submission> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Submission>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Submission] and returns the inserted row.
  ///
  /// The returned [Submission] will have its `id` field set.
  Future<Submission> insertRow(
    _is.DatabaseSession session,
    Submission row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Submission>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Submission]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Submission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Submission>> upsert(
    _is.DatabaseSession session,
    List<Submission> rows, {
    required _is.ColumnSelections<SubmissionTable> conflictColumns,
    _is.ColumnSelections<SubmissionTable>? updateColumns,
    _is.WhereExpressionBuilder<SubmissionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Submission>(
      rows,
      conflictColumns: conflictColumns(Submission.t),
      updateColumns: updateColumns?.call(Submission.t),
      updateWhere: updateWhere?.call(Submission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Submission] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Submission] will have its `id` field set.
  Future<Submission?> upsertRow(
    _is.DatabaseSession session,
    Submission row, {
    required _is.ColumnSelections<SubmissionTable> conflictColumns,
    _is.ColumnSelections<SubmissionTable>? updateColumns,
    _is.WhereExpressionBuilder<SubmissionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Submission>(
      row,
      conflictColumns: conflictColumns(Submission.t),
      updateColumns: updateColumns?.call(Submission.t),
      updateWhere: updateWhere?.call(Submission.t),
      transaction: transaction,
    );
  }

  /// Updates all [Submission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Submission>> update(
    _is.DatabaseSession session,
    List<Submission> rows, {
    _is.ColumnSelections<SubmissionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Submission>(
      rows,
      columns: columns?.call(Submission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Submission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Submission> updateRow(
    _is.DatabaseSession session,
    Submission row, {
    _is.ColumnSelections<SubmissionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Submission>(
      row,
      columns: columns?.call(Submission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Submission] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Submission?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SubmissionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Submission>(
      id,
      columnValues: columnValues(Submission.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Submission]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Submission>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SubmissionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SubmissionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SubmissionTable>? orderBy,
    _is.OrderByListBuilder<SubmissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Submission>(
      columnValues: columnValues(Submission.t.updateTable),
      where: where(Submission.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Submission.t),
      orderByList: orderByList?.call(Submission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Submission]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Submission>> delete(
    _is.DatabaseSession session,
    List<Submission> rows, {
    _is.OrderByBuilder<SubmissionTable>? orderBy,
    _is.OrderByListBuilder<SubmissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Submission>(
      rows,
      orderBy: orderBy?.call(Submission.t),
      orderByList: orderByList?.call(Submission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Submission].
  Future<Submission> deleteRow(
    _is.DatabaseSession session,
    Submission row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Submission>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Submission>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SubmissionTable> where,
    _is.OrderByBuilder<SubmissionTable>? orderBy,
    _is.OrderByListBuilder<SubmissionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Submission>(
      where: where(Submission.t),
      orderBy: orderBy?.call(Submission.t),
      orderByList: orderByList?.call(Submission.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SubmissionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Submission>(
      where: where?.call(Submission.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Submission] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SubmissionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Submission>(
      where: where(Submission.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
