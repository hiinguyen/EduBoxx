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

abstract class Exercise
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Exercise._({
    this.id,
    required this.contentId,
    required this.ownerTeacherId,
    this.lessonContentId,
    required this.answerKeyVersion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Exercise({
    int? id,
    required int contentId,
    required int ownerTeacherId,
    int? lessonContentId,
    required int answerKeyVersion,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ExerciseImpl;

  factory Exercise.fromJson(Map<String, dynamic> jsonSerialization) {
    return Exercise(
      id: jsonSerialization['id'] as int?,
      contentId: jsonSerialization['contentId'] as int,
      ownerTeacherId: jsonSerialization['ownerTeacherId'] as int,
      lessonContentId: jsonSerialization['lessonContentId'] as int?,
      answerKeyVersion: jsonSerialization['answerKeyVersion'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = ExerciseTable();

  static const db = ExerciseRepository._();

  @override
  int? id;

  int contentId;

  int ownerTeacherId;

  int? lessonContentId;

  int answerKeyVersion;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Exercise]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Exercise copyWith({
    int? id,
    int? contentId,
    int? ownerTeacherId,
    int? lessonContentId,
    int? answerKeyVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Exercise',
      if (id != null) 'id': id,
      'contentId': contentId,
      'ownerTeacherId': ownerTeacherId,
      if (lessonContentId != null) 'lessonContentId': lessonContentId,
      'answerKeyVersion': answerKeyVersion,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ExerciseInclude include() {
    return ExerciseInclude._();
  }

  static ExerciseIncludeList includeList({
    _is.WhereExpressionBuilder<ExerciseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseTable>? orderBy,
    _is.OrderByListBuilder<ExerciseTable>? orderByList,
    ExerciseInclude? include,
  }) {
    return ExerciseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Exercise.t),
      orderByList: orderByList?.call(Exercise.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExerciseImpl extends Exercise {
  _ExerciseImpl({
    int? id,
    required int contentId,
    required int ownerTeacherId,
    int? lessonContentId,
    required int answerKeyVersion,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         contentId: contentId,
         ownerTeacherId: ownerTeacherId,
         lessonContentId: lessonContentId,
         answerKeyVersion: answerKeyVersion,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Exercise]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Exercise copyWith({
    Object? id = _Undefined,
    int? contentId,
    int? ownerTeacherId,
    Object? lessonContentId = _Undefined,
    int? answerKeyVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exercise(
      id: id is int? ? id : this.id,
      contentId: contentId ?? this.contentId,
      ownerTeacherId: ownerTeacherId ?? this.ownerTeacherId,
      lessonContentId: lessonContentId is int?
          ? lessonContentId
          : this.lessonContentId,
      answerKeyVersion: answerKeyVersion ?? this.answerKeyVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ExerciseUpdateTable extends _is.UpdateTable<ExerciseTable> {
  ExerciseUpdateTable(super.table);

  _is.ColumnValue<int, int> contentId(int value) => _is.ColumnValue(
    table.contentId,
    value,
  );

  _is.ColumnValue<int, int> ownerTeacherId(int value) => _is.ColumnValue(
    table.ownerTeacherId,
    value,
  );

  _is.ColumnValue<int, int> lessonContentId(int? value) => _is.ColumnValue(
    table.lessonContentId,
    value,
  );

  _is.ColumnValue<int, int> answerKeyVersion(int value) => _is.ColumnValue(
    table.answerKeyVersion,
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

class ExerciseTable extends _is.Table<int?> {
  ExerciseTable({super.tableRelation}) : super(tableName: 'exercises') {
    updateTable = ExerciseUpdateTable(this);
    contentId = _is.ColumnInt(
      'contentId',
      this,
    );
    ownerTeacherId = _is.ColumnInt(
      'ownerTeacherId',
      this,
    );
    lessonContentId = _is.ColumnInt(
      'lessonContentId',
      this,
    );
    answerKeyVersion = _is.ColumnInt(
      'answerKeyVersion',
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

  late final ExerciseUpdateTable updateTable;

  late final _is.ColumnInt contentId;

  late final _is.ColumnInt ownerTeacherId;

  late final _is.ColumnInt lessonContentId;

  late final _is.ColumnInt answerKeyVersion;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    contentId,
    ownerTeacherId,
    lessonContentId,
    answerKeyVersion,
    createdAt,
    updatedAt,
  ];
}

class ExerciseInclude extends _is.IncludeObject {
  ExerciseInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Exercise.t;
}

class ExerciseIncludeList extends _is.IncludeList {
  ExerciseIncludeList._({
    _is.WhereExpressionBuilder<ExerciseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Exercise.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Exercise.t;
}

class ExerciseRepository {
  const ExerciseRepository._();

  /// Returns a list of [Exercise]s matching the given query parameters.
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
  Future<List<Exercise>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseTable>? orderBy,
    _is.OrderByListBuilder<ExerciseTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Exercise>(
      where: where?.call(Exercise.t),
      orderBy: orderBy?.call(Exercise.t),
      orderByList: orderByList?.call(Exercise.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Exercise] matching the given query parameters.
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
  Future<Exercise?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseTable>? where,
    int? offset,
    _is.OrderByBuilder<ExerciseTable>? orderBy,
    _is.OrderByListBuilder<ExerciseTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Exercise>(
      where: where?.call(Exercise.t),
      orderBy: orderBy?.call(Exercise.t),
      orderByList: orderByList?.call(Exercise.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Exercise] by its [id] or null if no such row exists.
  Future<Exercise?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Exercise>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Exercise]s in the list and returns the inserted rows.
  ///
  /// The returned [Exercise]s will have their `id` fields set.
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
  Future<List<Exercise>> insert(
    _is.DatabaseSession session,
    List<Exercise> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Exercise>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Exercise] and returns the inserted row.
  ///
  /// The returned [Exercise] will have its `id` field set.
  Future<Exercise> insertRow(
    _is.DatabaseSession session,
    Exercise row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Exercise>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Exercise]s in the list and returns the resulting rows.
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
  /// The returned [Exercise]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Exercise>> upsert(
    _is.DatabaseSession session,
    List<Exercise> rows, {
    required _is.ColumnSelections<ExerciseTable> conflictColumns,
    _is.ColumnSelections<ExerciseTable>? updateColumns,
    _is.WhereExpressionBuilder<ExerciseTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Exercise>(
      rows,
      conflictColumns: conflictColumns(Exercise.t),
      updateColumns: updateColumns?.call(Exercise.t),
      updateWhere: updateWhere?.call(Exercise.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Exercise] and returns the resulting row.
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
  /// The returned [Exercise] will have its `id` field set.
  Future<Exercise?> upsertRow(
    _is.DatabaseSession session,
    Exercise row, {
    required _is.ColumnSelections<ExerciseTable> conflictColumns,
    _is.ColumnSelections<ExerciseTable>? updateColumns,
    _is.WhereExpressionBuilder<ExerciseTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Exercise>(
      row,
      conflictColumns: conflictColumns(Exercise.t),
      updateColumns: updateColumns?.call(Exercise.t),
      updateWhere: updateWhere?.call(Exercise.t),
      transaction: transaction,
    );
  }

  /// Updates all [Exercise]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Exercise>> update(
    _is.DatabaseSession session,
    List<Exercise> rows, {
    _is.ColumnSelections<ExerciseTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Exercise>(
      rows,
      columns: columns?.call(Exercise.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Exercise]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Exercise> updateRow(
    _is.DatabaseSession session,
    Exercise row, {
    _is.ColumnSelections<ExerciseTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Exercise>(
      row,
      columns: columns?.call(Exercise.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Exercise] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Exercise?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ExerciseUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Exercise>(
      id,
      columnValues: columnValues(Exercise.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Exercise]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Exercise>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ExerciseUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ExerciseTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseTable>? orderBy,
    _is.OrderByListBuilder<ExerciseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Exercise>(
      columnValues: columnValues(Exercise.t.updateTable),
      where: where(Exercise.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Exercise.t),
      orderByList: orderByList?.call(Exercise.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Exercise]s in the list and returns the deleted rows.
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
  Future<List<Exercise>> delete(
    _is.DatabaseSession session,
    List<Exercise> rows, {
    _is.OrderByBuilder<ExerciseTable>? orderBy,
    _is.OrderByListBuilder<ExerciseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Exercise>(
      rows,
      orderBy: orderBy?.call(Exercise.t),
      orderByList: orderByList?.call(Exercise.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Exercise].
  Future<Exercise> deleteRow(
    _is.DatabaseSession session,
    Exercise row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Exercise>(
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
  Future<List<Exercise>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ExerciseTable> where,
    _is.OrderByBuilder<ExerciseTable>? orderBy,
    _is.OrderByListBuilder<ExerciseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Exercise>(
      where: where(Exercise.t),
      orderBy: orderBy?.call(Exercise.t),
      orderByList: orderByList?.call(Exercise.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Exercise>(
      where: where?.call(Exercise.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Exercise] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ExerciseTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Exercise>(
      where: where(Exercise.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
