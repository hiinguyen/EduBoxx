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

abstract class ProgressEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ProgressEntry._({
    this.id,
    required this.studentId,
    required this.contentId,
    required this.status,
    required this.updatedAt,
  });

  factory ProgressEntry({
    int? id,
    required int studentId,
    required int contentId,
    required String status,
    required DateTime updatedAt,
  }) = _ProgressEntryImpl;

  factory ProgressEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProgressEntry(
      id: jsonSerialization['id'] as int?,
      studentId: jsonSerialization['studentId'] as int,
      contentId: jsonSerialization['contentId'] as int,
      status: jsonSerialization['status'] as String,
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = ProgressEntryTable();

  static const db = ProgressEntryRepository._();

  @override
  int? id;

  int studentId;

  int contentId;

  String status;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ProgressEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProgressEntry copyWith({
    int? id,
    int? studentId,
    int? contentId,
    String? status,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProgressEntry',
      if (id != null) 'id': id,
      'studentId': studentId,
      'contentId': contentId,
      'status': status,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ProgressEntryInclude include() {
    return ProgressEntryInclude._();
  }

  static ProgressEntryIncludeList includeList({
    _is.WhereExpressionBuilder<ProgressEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProgressEntryTable>? orderBy,
    _is.OrderByListBuilder<ProgressEntryTable>? orderByList,
    ProgressEntryInclude? include,
  }) {
    return ProgressEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProgressEntry.t),
      orderByList: orderByList?.call(ProgressEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProgressEntryImpl extends ProgressEntry {
  _ProgressEntryImpl({
    int? id,
    required int studentId,
    required int contentId,
    required String status,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         studentId: studentId,
         contentId: contentId,
         status: status,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProgressEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProgressEntry copyWith({
    Object? id = _Undefined,
    int? studentId,
    int? contentId,
    String? status,
    DateTime? updatedAt,
  }) {
    return ProgressEntry(
      id: id is int? ? id : this.id,
      studentId: studentId ?? this.studentId,
      contentId: contentId ?? this.contentId,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProgressEntryUpdateTable extends _is.UpdateTable<ProgressEntryTable> {
  ProgressEntryUpdateTable(super.table);

  _is.ColumnValue<int, int> studentId(int value) => _is.ColumnValue(
    table.studentId,
    value,
  );

  _is.ColumnValue<int, int> contentId(int value) => _is.ColumnValue(
    table.contentId,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ProgressEntryTable extends _is.Table<int?> {
  ProgressEntryTable({super.tableRelation}) : super(tableName: 'progress') {
    updateTable = ProgressEntryUpdateTable(this);
    studentId = _is.ColumnInt(
      'studentId',
      this,
    );
    contentId = _is.ColumnInt(
      'contentId',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final ProgressEntryUpdateTable updateTable;

  late final _is.ColumnInt studentId;

  late final _is.ColumnInt contentId;

  late final _is.ColumnString status;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    studentId,
    contentId,
    status,
    updatedAt,
  ];
}

class ProgressEntryInclude extends _is.IncludeObject {
  ProgressEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ProgressEntry.t;
}

class ProgressEntryIncludeList extends _is.IncludeList {
  ProgressEntryIncludeList._({
    _is.WhereExpressionBuilder<ProgressEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProgressEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ProgressEntry.t;
}

class ProgressEntryRepository {
  const ProgressEntryRepository._();

  /// Returns a list of [ProgressEntry]s matching the given query parameters.
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
  Future<List<ProgressEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProgressEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProgressEntryTable>? orderBy,
    _is.OrderByListBuilder<ProgressEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProgressEntry>(
      where: where?.call(ProgressEntry.t),
      orderBy: orderBy?.call(ProgressEntry.t),
      orderByList: orderByList?.call(ProgressEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProgressEntry] matching the given query parameters.
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
  Future<ProgressEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProgressEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<ProgressEntryTable>? orderBy,
    _is.OrderByListBuilder<ProgressEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProgressEntry>(
      where: where?.call(ProgressEntry.t),
      orderBy: orderBy?.call(ProgressEntry.t),
      orderByList: orderByList?.call(ProgressEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProgressEntry] by its [id] or null if no such row exists.
  Future<ProgressEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProgressEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProgressEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [ProgressEntry]s will have their `id` fields set.
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
  Future<List<ProgressEntry>> insert(
    _is.DatabaseSession session,
    List<ProgressEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProgressEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProgressEntry] and returns the inserted row.
  ///
  /// The returned [ProgressEntry] will have its `id` field set.
  Future<ProgressEntry> insertRow(
    _is.DatabaseSession session,
    ProgressEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProgressEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProgressEntry]s in the list and returns the resulting rows.
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
  /// The returned [ProgressEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProgressEntry>> upsert(
    _is.DatabaseSession session,
    List<ProgressEntry> rows, {
    required _is.ColumnSelections<ProgressEntryTable> conflictColumns,
    _is.ColumnSelections<ProgressEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<ProgressEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProgressEntry>(
      rows,
      conflictColumns: conflictColumns(ProgressEntry.t),
      updateColumns: updateColumns?.call(ProgressEntry.t),
      updateWhere: updateWhere?.call(ProgressEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProgressEntry] and returns the resulting row.
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
  /// The returned [ProgressEntry] will have its `id` field set.
  Future<ProgressEntry?> upsertRow(
    _is.DatabaseSession session,
    ProgressEntry row, {
    required _is.ColumnSelections<ProgressEntryTable> conflictColumns,
    _is.ColumnSelections<ProgressEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<ProgressEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProgressEntry>(
      row,
      conflictColumns: conflictColumns(ProgressEntry.t),
      updateColumns: updateColumns?.call(ProgressEntry.t),
      updateWhere: updateWhere?.call(ProgressEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProgressEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProgressEntry>> update(
    _is.DatabaseSession session,
    List<ProgressEntry> rows, {
    _is.ColumnSelections<ProgressEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProgressEntry>(
      rows,
      columns: columns?.call(ProgressEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProgressEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProgressEntry> updateRow(
    _is.DatabaseSession session,
    ProgressEntry row, {
    _is.ColumnSelections<ProgressEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProgressEntry>(
      row,
      columns: columns?.call(ProgressEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProgressEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProgressEntry?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ProgressEntryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProgressEntry>(
      id,
      columnValues: columnValues(ProgressEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProgressEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProgressEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProgressEntryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProgressEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProgressEntryTable>? orderBy,
    _is.OrderByListBuilder<ProgressEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProgressEntry>(
      columnValues: columnValues(ProgressEntry.t.updateTable),
      where: where(ProgressEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProgressEntry.t),
      orderByList: orderByList?.call(ProgressEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProgressEntry]s in the list and returns the deleted rows.
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
  Future<List<ProgressEntry>> delete(
    _is.DatabaseSession session,
    List<ProgressEntry> rows, {
    _is.OrderByBuilder<ProgressEntryTable>? orderBy,
    _is.OrderByListBuilder<ProgressEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProgressEntry>(
      rows,
      orderBy: orderBy?.call(ProgressEntry.t),
      orderByList: orderByList?.call(ProgressEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProgressEntry].
  Future<ProgressEntry> deleteRow(
    _is.DatabaseSession session,
    ProgressEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProgressEntry>(
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
  Future<List<ProgressEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProgressEntryTable> where,
    _is.OrderByBuilder<ProgressEntryTable>? orderBy,
    _is.OrderByListBuilder<ProgressEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProgressEntry>(
      where: where(ProgressEntry.t),
      orderBy: orderBy?.call(ProgressEntry.t),
      orderByList: orderByList?.call(ProgressEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProgressEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProgressEntry>(
      where: where?.call(ProgressEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProgressEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProgressEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProgressEntry>(
      where: where(ProgressEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
