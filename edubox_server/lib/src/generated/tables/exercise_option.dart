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

abstract class ExerciseOption
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ExerciseOption._({
    this.id,
    required this.questionId,
    required this.position,
    required this.text,
  });

  factory ExerciseOption({
    int? id,
    required int questionId,
    required int position,
    required String text,
  }) = _ExerciseOptionImpl;

  factory ExerciseOption.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExerciseOption(
      id: jsonSerialization['id'] as int?,
      questionId: jsonSerialization['questionId'] as int,
      position: jsonSerialization['position'] as int,
      text: jsonSerialization['text'] as String,
    );
  }

  static final t = ExerciseOptionTable();

  static const db = ExerciseOptionRepository._();

  @override
  int? id;

  int questionId;

  int position;

  String text;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ExerciseOption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ExerciseOption copyWith({
    int? id,
    int? questionId,
    int? position,
    String? text,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExerciseOption',
      if (id != null) 'id': id,
      'questionId': questionId,
      'position': position,
      'text': text,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ExerciseOptionInclude include() {
    return ExerciseOptionInclude._();
  }

  static ExerciseOptionIncludeList includeList({
    _is.WhereExpressionBuilder<ExerciseOptionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseOptionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseOptionTable>? orderByList,
    ExerciseOptionInclude? include,
  }) {
    return ExerciseOptionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExerciseOption.t),
      orderByList: orderByList?.call(ExerciseOption.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExerciseOptionImpl extends ExerciseOption {
  _ExerciseOptionImpl({
    int? id,
    required int questionId,
    required int position,
    required String text,
  }) : super._(
         id: id,
         questionId: questionId,
         position: position,
         text: text,
       );

  /// Returns a shallow copy of this [ExerciseOption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ExerciseOption copyWith({
    Object? id = _Undefined,
    int? questionId,
    int? position,
    String? text,
  }) {
    return ExerciseOption(
      id: id is int? ? id : this.id,
      questionId: questionId ?? this.questionId,
      position: position ?? this.position,
      text: text ?? this.text,
    );
  }
}

class ExerciseOptionUpdateTable extends _is.UpdateTable<ExerciseOptionTable> {
  ExerciseOptionUpdateTable(super.table);

  _is.ColumnValue<int, int> questionId(int value) => _is.ColumnValue(
    table.questionId,
    value,
  );

  _is.ColumnValue<int, int> position(int value) => _is.ColumnValue(
    table.position,
    value,
  );

  _is.ColumnValue<String, String> text(String value) => _is.ColumnValue(
    table.text,
    value,
  );
}

class ExerciseOptionTable extends _is.Table<int?> {
  ExerciseOptionTable({super.tableRelation})
    : super(tableName: 'exercise_options') {
    updateTable = ExerciseOptionUpdateTable(this);
    questionId = _is.ColumnInt(
      'questionId',
      this,
    );
    position = _is.ColumnInt(
      'position',
      this,
    );
    text = _is.ColumnString(
      'text',
      this,
    );
  }

  late final ExerciseOptionUpdateTable updateTable;

  late final _is.ColumnInt questionId;

  late final _is.ColumnInt position;

  late final _is.ColumnString text;

  @override
  List<_is.Column> get columns => [
    id,
    questionId,
    position,
    text,
  ];
}

class ExerciseOptionInclude extends _is.IncludeObject {
  ExerciseOptionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ExerciseOption.t;
}

class ExerciseOptionIncludeList extends _is.IncludeList {
  ExerciseOptionIncludeList._({
    _is.WhereExpressionBuilder<ExerciseOptionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ExerciseOption.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ExerciseOption.t;
}

class ExerciseOptionRepository {
  const ExerciseOptionRepository._();

  /// Returns a list of [ExerciseOption]s matching the given query parameters.
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
  Future<List<ExerciseOption>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseOptionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseOptionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseOptionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ExerciseOption>(
      where: where?.call(ExerciseOption.t),
      orderBy: orderBy?.call(ExerciseOption.t),
      orderByList: orderByList?.call(ExerciseOption.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ExerciseOption] matching the given query parameters.
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
  Future<ExerciseOption?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseOptionTable>? where,
    int? offset,
    _is.OrderByBuilder<ExerciseOptionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseOptionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ExerciseOption>(
      where: where?.call(ExerciseOption.t),
      orderBy: orderBy?.call(ExerciseOption.t),
      orderByList: orderByList?.call(ExerciseOption.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ExerciseOption] by its [id] or null if no such row exists.
  Future<ExerciseOption?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ExerciseOption>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ExerciseOption]s in the list and returns the inserted rows.
  ///
  /// The returned [ExerciseOption]s will have their `id` fields set.
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
  Future<List<ExerciseOption>> insert(
    _is.DatabaseSession session,
    List<ExerciseOption> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ExerciseOption>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ExerciseOption] and returns the inserted row.
  ///
  /// The returned [ExerciseOption] will have its `id` field set.
  Future<ExerciseOption> insertRow(
    _is.DatabaseSession session,
    ExerciseOption row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ExerciseOption>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ExerciseOption]s in the list and returns the resulting rows.
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
  /// The returned [ExerciseOption]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExerciseOption>> upsert(
    _is.DatabaseSession session,
    List<ExerciseOption> rows, {
    required _is.ColumnSelections<ExerciseOptionTable> conflictColumns,
    _is.ColumnSelections<ExerciseOptionTable>? updateColumns,
    _is.WhereExpressionBuilder<ExerciseOptionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ExerciseOption>(
      rows,
      conflictColumns: conflictColumns(ExerciseOption.t),
      updateColumns: updateColumns?.call(ExerciseOption.t),
      updateWhere: updateWhere?.call(ExerciseOption.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ExerciseOption] and returns the resulting row.
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
  /// The returned [ExerciseOption] will have its `id` field set.
  Future<ExerciseOption?> upsertRow(
    _is.DatabaseSession session,
    ExerciseOption row, {
    required _is.ColumnSelections<ExerciseOptionTable> conflictColumns,
    _is.ColumnSelections<ExerciseOptionTable>? updateColumns,
    _is.WhereExpressionBuilder<ExerciseOptionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ExerciseOption>(
      row,
      conflictColumns: conflictColumns(ExerciseOption.t),
      updateColumns: updateColumns?.call(ExerciseOption.t),
      updateWhere: updateWhere?.call(ExerciseOption.t),
      transaction: transaction,
    );
  }

  /// Updates all [ExerciseOption]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExerciseOption>> update(
    _is.DatabaseSession session,
    List<ExerciseOption> rows, {
    _is.ColumnSelections<ExerciseOptionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ExerciseOption>(
      rows,
      columns: columns?.call(ExerciseOption.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ExerciseOption]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ExerciseOption> updateRow(
    _is.DatabaseSession session,
    ExerciseOption row, {
    _is.ColumnSelections<ExerciseOptionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ExerciseOption>(
      row,
      columns: columns?.call(ExerciseOption.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ExerciseOption] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ExerciseOption?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ExerciseOptionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ExerciseOption>(
      id,
      columnValues: columnValues(ExerciseOption.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ExerciseOption]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExerciseOption>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ExerciseOptionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ExerciseOptionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseOptionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseOptionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ExerciseOption>(
      columnValues: columnValues(ExerciseOption.t.updateTable),
      where: where(ExerciseOption.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExerciseOption.t),
      orderByList: orderByList?.call(ExerciseOption.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ExerciseOption]s in the list and returns the deleted rows.
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
  Future<List<ExerciseOption>> delete(
    _is.DatabaseSession session,
    List<ExerciseOption> rows, {
    _is.OrderByBuilder<ExerciseOptionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseOptionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ExerciseOption>(
      rows,
      orderBy: orderBy?.call(ExerciseOption.t),
      orderByList: orderByList?.call(ExerciseOption.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ExerciseOption].
  Future<ExerciseOption> deleteRow(
    _is.DatabaseSession session,
    ExerciseOption row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ExerciseOption>(
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
  Future<List<ExerciseOption>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ExerciseOptionTable> where,
    _is.OrderByBuilder<ExerciseOptionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseOptionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ExerciseOption>(
      where: where(ExerciseOption.t),
      orderBy: orderBy?.call(ExerciseOption.t),
      orderByList: orderByList?.call(ExerciseOption.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseOptionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ExerciseOption>(
      where: where?.call(ExerciseOption.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ExerciseOption] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ExerciseOptionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ExerciseOption>(
      where: where(ExerciseOption.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
