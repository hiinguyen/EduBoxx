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

abstract class ExerciseQuestion
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ExerciseQuestion._({
    this.id,
    required this.exerciseId,
    required this.position,
    required this.stem,
    required this.multiSelect,
    this.imagePath,
  });

  factory ExerciseQuestion({
    int? id,
    required int exerciseId,
    required int position,
    required String stem,
    required bool multiSelect,
    String? imagePath,
  }) = _ExerciseQuestionImpl;

  factory ExerciseQuestion.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExerciseQuestion(
      id: jsonSerialization['id'] as int?,
      exerciseId: jsonSerialization['exerciseId'] as int,
      position: jsonSerialization['position'] as int,
      stem: jsonSerialization['stem'] as String,
      multiSelect: _is.BoolJsonExtension.fromJson(
        jsonSerialization['multiSelect'],
      ),
      imagePath: jsonSerialization['imagePath'] as String?,
    );
  }

  static final t = ExerciseQuestionTable();

  static const db = ExerciseQuestionRepository._();

  @override
  int? id;

  int exerciseId;

  int position;

  String stem;

  bool multiSelect;

  String? imagePath;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ExerciseQuestion]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ExerciseQuestion copyWith({
    int? id,
    int? exerciseId,
    int? position,
    String? stem,
    bool? multiSelect,
    String? imagePath,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExerciseQuestion',
      if (id != null) 'id': id,
      'exerciseId': exerciseId,
      'position': position,
      'stem': stem,
      'multiSelect': multiSelect,
      if (imagePath != null) 'imagePath': imagePath,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ExerciseQuestionInclude include() {
    return ExerciseQuestionInclude._();
  }

  static ExerciseQuestionIncludeList includeList({
    _is.WhereExpressionBuilder<ExerciseQuestionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseQuestionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseQuestionTable>? orderByList,
    ExerciseQuestionInclude? include,
  }) {
    return ExerciseQuestionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExerciseQuestion.t),
      orderByList: orderByList?.call(ExerciseQuestion.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExerciseQuestionImpl extends ExerciseQuestion {
  _ExerciseQuestionImpl({
    int? id,
    required int exerciseId,
    required int position,
    required String stem,
    required bool multiSelect,
    String? imagePath,
  }) : super._(
         id: id,
         exerciseId: exerciseId,
         position: position,
         stem: stem,
         multiSelect: multiSelect,
         imagePath: imagePath,
       );

  /// Returns a shallow copy of this [ExerciseQuestion]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ExerciseQuestion copyWith({
    Object? id = _Undefined,
    int? exerciseId,
    int? position,
    String? stem,
    bool? multiSelect,
    Object? imagePath = _Undefined,
  }) {
    return ExerciseQuestion(
      id: id is int? ? id : this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      position: position ?? this.position,
      stem: stem ?? this.stem,
      multiSelect: multiSelect ?? this.multiSelect,
      imagePath: imagePath is String? ? imagePath : this.imagePath,
    );
  }
}

class ExerciseQuestionUpdateTable
    extends _is.UpdateTable<ExerciseQuestionTable> {
  ExerciseQuestionUpdateTable(super.table);

  _is.ColumnValue<int, int> exerciseId(int value) => _is.ColumnValue(
    table.exerciseId,
    value,
  );

  _is.ColumnValue<int, int> position(int value) => _is.ColumnValue(
    table.position,
    value,
  );

  _is.ColumnValue<String, String> stem(String value) => _is.ColumnValue(
    table.stem,
    value,
  );

  _is.ColumnValue<bool, bool> multiSelect(bool value) => _is.ColumnValue(
    table.multiSelect,
    value,
  );

  _is.ColumnValue<String, String> imagePath(String? value) => _is.ColumnValue(
    table.imagePath,
    value,
  );
}

class ExerciseQuestionTable extends _is.Table<int?> {
  ExerciseQuestionTable({super.tableRelation})
    : super(tableName: 'exercise_questions') {
    updateTable = ExerciseQuestionUpdateTable(this);
    exerciseId = _is.ColumnInt(
      'exerciseId',
      this,
    );
    position = _is.ColumnInt(
      'position',
      this,
    );
    stem = _is.ColumnString(
      'stem',
      this,
    );
    multiSelect = _is.ColumnBool(
      'multiSelect',
      this,
    );
    imagePath = _is.ColumnString(
      'imagePath',
      this,
    );
  }

  late final ExerciseQuestionUpdateTable updateTable;

  late final _is.ColumnInt exerciseId;

  late final _is.ColumnInt position;

  late final _is.ColumnString stem;

  late final _is.ColumnBool multiSelect;

  late final _is.ColumnString imagePath;

  @override
  List<_is.Column> get columns => [
    id,
    exerciseId,
    position,
    stem,
    multiSelect,
    imagePath,
  ];
}

class ExerciseQuestionInclude extends _is.IncludeObject {
  ExerciseQuestionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ExerciseQuestion.t;
}

class ExerciseQuestionIncludeList extends _is.IncludeList {
  ExerciseQuestionIncludeList._({
    _is.WhereExpressionBuilder<ExerciseQuestionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ExerciseQuestion.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ExerciseQuestion.t;
}

class ExerciseQuestionRepository {
  const ExerciseQuestionRepository._();

  /// Returns a list of [ExerciseQuestion]s matching the given query parameters.
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
  Future<List<ExerciseQuestion>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseQuestionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseQuestionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseQuestionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ExerciseQuestion>(
      where: where?.call(ExerciseQuestion.t),
      orderBy: orderBy?.call(ExerciseQuestion.t),
      orderByList: orderByList?.call(ExerciseQuestion.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ExerciseQuestion] matching the given query parameters.
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
  Future<ExerciseQuestion?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseQuestionTable>? where,
    int? offset,
    _is.OrderByBuilder<ExerciseQuestionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseQuestionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ExerciseQuestion>(
      where: where?.call(ExerciseQuestion.t),
      orderBy: orderBy?.call(ExerciseQuestion.t),
      orderByList: orderByList?.call(ExerciseQuestion.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ExerciseQuestion] by its [id] or null if no such row exists.
  Future<ExerciseQuestion?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ExerciseQuestion>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ExerciseQuestion]s in the list and returns the inserted rows.
  ///
  /// The returned [ExerciseQuestion]s will have their `id` fields set.
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
  Future<List<ExerciseQuestion>> insert(
    _is.DatabaseSession session,
    List<ExerciseQuestion> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ExerciseQuestion>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ExerciseQuestion] and returns the inserted row.
  ///
  /// The returned [ExerciseQuestion] will have its `id` field set.
  Future<ExerciseQuestion> insertRow(
    _is.DatabaseSession session,
    ExerciseQuestion row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ExerciseQuestion>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ExerciseQuestion]s in the list and returns the resulting rows.
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
  /// The returned [ExerciseQuestion]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExerciseQuestion>> upsert(
    _is.DatabaseSession session,
    List<ExerciseQuestion> rows, {
    required _is.ColumnSelections<ExerciseQuestionTable> conflictColumns,
    _is.ColumnSelections<ExerciseQuestionTable>? updateColumns,
    _is.WhereExpressionBuilder<ExerciseQuestionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ExerciseQuestion>(
      rows,
      conflictColumns: conflictColumns(ExerciseQuestion.t),
      updateColumns: updateColumns?.call(ExerciseQuestion.t),
      updateWhere: updateWhere?.call(ExerciseQuestion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ExerciseQuestion] and returns the resulting row.
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
  /// The returned [ExerciseQuestion] will have its `id` field set.
  Future<ExerciseQuestion?> upsertRow(
    _is.DatabaseSession session,
    ExerciseQuestion row, {
    required _is.ColumnSelections<ExerciseQuestionTable> conflictColumns,
    _is.ColumnSelections<ExerciseQuestionTable>? updateColumns,
    _is.WhereExpressionBuilder<ExerciseQuestionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ExerciseQuestion>(
      row,
      conflictColumns: conflictColumns(ExerciseQuestion.t),
      updateColumns: updateColumns?.call(ExerciseQuestion.t),
      updateWhere: updateWhere?.call(ExerciseQuestion.t),
      transaction: transaction,
    );
  }

  /// Updates all [ExerciseQuestion]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExerciseQuestion>> update(
    _is.DatabaseSession session,
    List<ExerciseQuestion> rows, {
    _is.ColumnSelections<ExerciseQuestionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ExerciseQuestion>(
      rows,
      columns: columns?.call(ExerciseQuestion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ExerciseQuestion]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ExerciseQuestion> updateRow(
    _is.DatabaseSession session,
    ExerciseQuestion row, {
    _is.ColumnSelections<ExerciseQuestionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ExerciseQuestion>(
      row,
      columns: columns?.call(ExerciseQuestion.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ExerciseQuestion] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ExerciseQuestion?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ExerciseQuestionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ExerciseQuestion>(
      id,
      columnValues: columnValues(ExerciseQuestion.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ExerciseQuestion]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ExerciseQuestion>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ExerciseQuestionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ExerciseQuestionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ExerciseQuestionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseQuestionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ExerciseQuestion>(
      columnValues: columnValues(ExerciseQuestion.t.updateTable),
      where: where(ExerciseQuestion.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExerciseQuestion.t),
      orderByList: orderByList?.call(ExerciseQuestion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ExerciseQuestion]s in the list and returns the deleted rows.
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
  Future<List<ExerciseQuestion>> delete(
    _is.DatabaseSession session,
    List<ExerciseQuestion> rows, {
    _is.OrderByBuilder<ExerciseQuestionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseQuestionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ExerciseQuestion>(
      rows,
      orderBy: orderBy?.call(ExerciseQuestion.t),
      orderByList: orderByList?.call(ExerciseQuestion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ExerciseQuestion].
  Future<ExerciseQuestion> deleteRow(
    _is.DatabaseSession session,
    ExerciseQuestion row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ExerciseQuestion>(
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
  Future<List<ExerciseQuestion>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ExerciseQuestionTable> where,
    _is.OrderByBuilder<ExerciseQuestionTable>? orderBy,
    _is.OrderByListBuilder<ExerciseQuestionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ExerciseQuestion>(
      where: where(ExerciseQuestion.t),
      orderBy: orderBy?.call(ExerciseQuestion.t),
      orderByList: orderByList?.call(ExerciseQuestion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ExerciseQuestionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ExerciseQuestion>(
      where: where?.call(ExerciseQuestion.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ExerciseQuestion] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ExerciseQuestionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ExerciseQuestion>(
      where: where(ExerciseQuestion.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
