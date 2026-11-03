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

abstract class ExerciseAnswerKey
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ExerciseAnswerKey._({
    this.id,
    required this.questionId,
    required this.correctPosition,
  });

  factory ExerciseAnswerKey({
    int? id,
    required int questionId,
    required int correctPosition,
  }) = _ExerciseAnswerKeyImpl;

  factory ExerciseAnswerKey.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExerciseAnswerKey(
      id: jsonSerialization['id'] as int?,
      questionId: jsonSerialization['questionId'] as int,
      correctPosition: jsonSerialization['correctPosition'] as int,
    );
  }

  static final t = ExerciseAnswerKeyTable();

  static const db = ExerciseAnswerKeyRepository._();

  @override
  int? id;

  int questionId;

  int correctPosition;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ExerciseAnswerKey]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ExerciseAnswerKey copyWith({
    int? id,
    int? questionId,
    int? correctPosition,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExerciseAnswerKey',
      if (id != null) 'id': id,
      'questionId': questionId,
      'correctPosition': correctPosition,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ExerciseAnswerKeyInclude include() {
    return ExerciseAnswerKeyInclude._();
  }

  static ExerciseAnswerKeyIncludeList includeList({
    _is.WhereExpressionBuilder<ExerciseAnswerKeyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseAnswerKeyTable>? orderBy,
    _is.OrderByListBuilder<ExerciseAnswerKeyTable>? orderByList,
    ExerciseAnswerKeyInclude? include,
  }) {
    return ExerciseAnswerKeyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExerciseAnswerKey.t),
      orderByList: orderByList?.call(ExerciseAnswerKey.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExerciseAnswerKeyImpl extends ExerciseAnswerKey {
  _ExerciseAnswerKeyImpl({
    int? id,
    required int questionId,
    required int correctPosition,
  }) : super._(
         id: id,
         questionId: questionId,
         correctPosition: correctPosition,
       );

  /// Returns a shallow copy of this [ExerciseAnswerKey]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ExerciseAnswerKey copyWith({
    Object? id = _Undefined,
    int? questionId,
    int? correctPosition,
  }) {
    return ExerciseAnswerKey(
      id: id is int? ? id : this.id,
      questionId: questionId ?? this.questionId,
      correctPosition: correctPosition ?? this.correctPosition,
    );
  }
}

class ExerciseAnswerKeyUpdateTable
    extends _is.UpdateTable<ExerciseAnswerKeyTable> {
  ExerciseAnswerKeyUpdateTable(super.table);

  _is.ColumnValue<int, int> questionId(int value) => _is.ColumnValue(
    table.questionId,
    value,
  );

  _is.ColumnValue<int, int> correctPosition(int value) => _is.ColumnValue(
    table.correctPosition,
    value,
  );
}

class ExerciseAnswerKeyTable extends _is.Table<int?> {
  ExerciseAnswerKeyTable({super.tableRelation})
    : super(tableName: 'exercise_answer_keys') {
    updateTable = ExerciseAnswerKeyUpdateTable(this);
    questionId = _is.ColumnInt(
      'questionId',
      this,
    );
    correctPosition = _is.ColumnInt(
      'correctPosition',
      this,
    );
  }

  late final ExerciseAnswerKeyUpdateTable updateTable;

  late final _is.ColumnInt questionId;

  late final _is.ColumnInt correctPosition;

  @override
  List<_is.Column> get columns => [
    id,
    questionId,
    correctPosition,
  ];
}

class ExerciseAnswerKeyInclude extends _is.IncludeObject {
  ExerciseAnswerKeyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ExerciseAnswerKey.t;
}

class ExerciseAnswerKeyIncludeList extends _is.IncludeList {
  ExerciseAnswerKeyIncludeList._({
    _is.WhereExpressionBuilder<ExerciseAnswerKeyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ExerciseAnswerKey.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ExerciseAnswerKey.t;
}

class ExerciseAnswerKeyRepository {
  const ExerciseAnswerKeyRepository._();

  /// Returns a list of [ExerciseAnswerKey]s matching the given query parameters.
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
  Future<List<ExerciseAnswerKey>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseAnswerKeyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseAnswerKeyTable>? orderBy,
    _is.OrderByListBuilder<ExerciseAnswerKeyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ExerciseAnswerKey>(
      where: where?.call(ExerciseAnswerKey.t),
      orderBy: orderBy?.call(ExerciseAnswerKey.t),
      orderByList: orderByList?.call(ExerciseAnswerKey.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ExerciseAnswerKey] matching the given query parameters.
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
  Future<ExerciseAnswerKey?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseAnswerKeyTable>? where,
    int? offset,
    _is.OrderByBuilder<ExerciseAnswerKeyTable>? orderBy,
    _is.OrderByListBuilder<ExerciseAnswerKeyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ExerciseAnswerKey>(
      where: where?.call(ExerciseAnswerKey.t),
      orderBy: orderBy?.call(ExerciseAnswerKey.t),
      orderByList: orderByList?.call(ExerciseAnswerKey.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ExerciseAnswerKey] by its [id] or null if no such row exists.
  Future<ExerciseAnswerKey?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ExerciseAnswerKey>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ExerciseAnswerKey]s in the list and returns the inserted rows.
  ///
  /// The returned [ExerciseAnswerKey]s will have their `id` fields set.
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
  Future<List<ExerciseAnswerKey>> insert(
    _is.DatabaseSession session,
    List<ExerciseAnswerKey> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ExerciseAnswerKey>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ExerciseAnswerKey] and returns the inserted row.
  ///
  /// The returned [ExerciseAnswerKey] will have its `id` field set.
  Future<ExerciseAnswerKey> insertRow(
    _is.DatabaseSession session,
    ExerciseAnswerKey row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ExerciseAnswerKey>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ExerciseAnswerKey]s in the list and returns the resulting rows.
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
  /// The returned [ExerciseAnswerKey]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExerciseAnswerKey>> upsert(
    _is.DatabaseSession session,
    List<ExerciseAnswerKey> rows, {
    required _is.ColumnSelections<ExerciseAnswerKeyTable> conflictColumns,
    _is.ColumnSelections<ExerciseAnswerKeyTable>? updateColumns,
    _is.WhereExpressionBuilder<ExerciseAnswerKeyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ExerciseAnswerKey>(
      rows,
      conflictColumns: conflictColumns(ExerciseAnswerKey.t),
      updateColumns: updateColumns?.call(ExerciseAnswerKey.t),
      updateWhere: updateWhere?.call(ExerciseAnswerKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ExerciseAnswerKey] and returns the resulting row.
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
  /// The returned [ExerciseAnswerKey] will have its `id` field set.
  Future<ExerciseAnswerKey?> upsertRow(
    _is.DatabaseSession session,
    ExerciseAnswerKey row, {
    required _is.ColumnSelections<ExerciseAnswerKeyTable> conflictColumns,
    _is.ColumnSelections<ExerciseAnswerKeyTable>? updateColumns,
    _is.WhereExpressionBuilder<ExerciseAnswerKeyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ExerciseAnswerKey>(
      row,
      conflictColumns: conflictColumns(ExerciseAnswerKey.t),
      updateColumns: updateColumns?.call(ExerciseAnswerKey.t),
      updateWhere: updateWhere?.call(ExerciseAnswerKey.t),
      transaction: transaction,
    );
  }

  /// Updates all [ExerciseAnswerKey]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExerciseAnswerKey>> update(
    _is.DatabaseSession session,
    List<ExerciseAnswerKey> rows, {
    _is.ColumnSelections<ExerciseAnswerKeyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ExerciseAnswerKey>(
      rows,
      columns: columns?.call(ExerciseAnswerKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ExerciseAnswerKey]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ExerciseAnswerKey> updateRow(
    _is.DatabaseSession session,
    ExerciseAnswerKey row, {
    _is.ColumnSelections<ExerciseAnswerKeyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ExerciseAnswerKey>(
      row,
      columns: columns?.call(ExerciseAnswerKey.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ExerciseAnswerKey] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ExerciseAnswerKey?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ExerciseAnswerKeyUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ExerciseAnswerKey>(
      id,
      columnValues: columnValues(ExerciseAnswerKey.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ExerciseAnswerKey]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExerciseAnswerKey>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ExerciseAnswerKeyUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ExerciseAnswerKeyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseAnswerKeyTable>? orderBy,
    _is.OrderByListBuilder<ExerciseAnswerKeyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ExerciseAnswerKey>(
      columnValues: columnValues(ExerciseAnswerKey.t.updateTable),
      where: where(ExerciseAnswerKey.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExerciseAnswerKey.t),
      orderByList: orderByList?.call(ExerciseAnswerKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ExerciseAnswerKey]s in the list and returns the deleted rows.
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
  Future<List<ExerciseAnswerKey>> delete(
    _is.DatabaseSession session,
    List<ExerciseAnswerKey> rows, {
    _is.OrderByBuilder<ExerciseAnswerKeyTable>? orderBy,
    _is.OrderByListBuilder<ExerciseAnswerKeyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ExerciseAnswerKey>(
      rows,
      orderBy: orderBy?.call(ExerciseAnswerKey.t),
      orderByList: orderByList?.call(ExerciseAnswerKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ExerciseAnswerKey].
  Future<ExerciseAnswerKey> deleteRow(
    _is.DatabaseSession session,
    ExerciseAnswerKey row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ExerciseAnswerKey>(
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
  Future<List<ExerciseAnswerKey>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ExerciseAnswerKeyTable> where,
    _is.OrderByBuilder<ExerciseAnswerKeyTable>? orderBy,
    _is.OrderByListBuilder<ExerciseAnswerKeyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ExerciseAnswerKey>(
      where: where(ExerciseAnswerKey.t),
      orderBy: orderBy?.call(ExerciseAnswerKey.t),
      orderByList: orderByList?.call(ExerciseAnswerKey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseAnswerKeyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ExerciseAnswerKey>(
      where: where?.call(ExerciseAnswerKey.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ExerciseAnswerKey] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ExerciseAnswerKeyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ExerciseAnswerKey>(
      where: where(ExerciseAnswerKey.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
