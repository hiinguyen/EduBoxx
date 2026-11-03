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

abstract class AiChat implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AiChat._({
    this.id,
    required this.studentId,
    required this.subject,
    this.classId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AiChat({
    int? id,
    required int studentId,
    required String subject,
    int? classId,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AiChatImpl;

  factory AiChat.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiChat(
      id: jsonSerialization['id'] as int?,
      studentId: jsonSerialization['studentId'] as int,
      subject: jsonSerialization['subject'] as String,
      classId: jsonSerialization['classId'] as int?,
      title: jsonSerialization['title'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = AiChatTable();

  static const db = AiChatRepository._();

  @override
  int? id;

  int studentId;

  String subject;

  int? classId;

  String title;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AiChat]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiChat copyWith({
    int? id,
    int? studentId,
    String? subject,
    int? classId,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiChat',
      if (id != null) 'id': id,
      'studentId': studentId,
      'subject': subject,
      if (classId != null) 'classId': classId,
      'title': title,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AiChatInclude include() {
    return AiChatInclude._();
  }

  static AiChatIncludeList includeList({
    _is.WhereExpressionBuilder<AiChatTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiChatTable>? orderBy,
    _is.OrderByListBuilder<AiChatTable>? orderByList,
    AiChatInclude? include,
  }) {
    return AiChatIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiChat.t),
      orderByList: orderByList?.call(AiChat.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiChatImpl extends AiChat {
  _AiChatImpl({
    int? id,
    required int studentId,
    required String subject,
    int? classId,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         studentId: studentId,
         subject: subject,
         classId: classId,
         title: title,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AiChat]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiChat copyWith({
    Object? id = _Undefined,
    int? studentId,
    String? subject,
    Object? classId = _Undefined,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AiChat(
      id: id is int? ? id : this.id,
      studentId: studentId ?? this.studentId,
      subject: subject ?? this.subject,
      classId: classId is int? ? classId : this.classId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AiChatUpdateTable extends _is.UpdateTable<AiChatTable> {
  AiChatUpdateTable(super.table);

  _is.ColumnValue<int, int> studentId(int value) => _is.ColumnValue(
    table.studentId,
    value,
  );

  _is.ColumnValue<String, String> subject(String value) => _is.ColumnValue(
    table.subject,
    value,
  );

  _is.ColumnValue<int, int> classId(int? value) => _is.ColumnValue(
    table.classId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
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

class AiChatTable extends _is.Table<int?> {
  AiChatTable({super.tableRelation}) : super(tableName: 'ai_chats') {
    updateTable = AiChatUpdateTable(this);
    studentId = _is.ColumnInt(
      'studentId',
      this,
    );
    subject = _is.ColumnString(
      'subject',
      this,
    );
    classId = _is.ColumnInt(
      'classId',
      this,
    );
    title = _is.ColumnString(
      'title',
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

  late final AiChatUpdateTable updateTable;

  late final _is.ColumnInt studentId;

  late final _is.ColumnString subject;

  late final _is.ColumnInt classId;

  late final _is.ColumnString title;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    studentId,
    subject,
    classId,
    title,
    createdAt,
    updatedAt,
  ];
}

class AiChatInclude extends _is.IncludeObject {
  AiChatInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AiChat.t;
}

class AiChatIncludeList extends _is.IncludeList {
  AiChatIncludeList._({
    _is.WhereExpressionBuilder<AiChatTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AiChat.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AiChat.t;
}

class AiChatRepository {
  const AiChatRepository._();

  /// Returns a list of [AiChat]s matching the given query parameters.
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
  Future<List<AiChat>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiChatTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiChatTable>? orderBy,
    _is.OrderByListBuilder<AiChatTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AiChat>(
      where: where?.call(AiChat.t),
      orderBy: orderBy?.call(AiChat.t),
      orderByList: orderByList?.call(AiChat.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AiChat] matching the given query parameters.
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
  Future<AiChat?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiChatTable>? where,
    int? offset,
    _is.OrderByBuilder<AiChatTable>? orderBy,
    _is.OrderByListBuilder<AiChatTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AiChat>(
      where: where?.call(AiChat.t),
      orderBy: orderBy?.call(AiChat.t),
      orderByList: orderByList?.call(AiChat.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AiChat] by its [id] or null if no such row exists.
  Future<AiChat?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AiChat>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AiChat]s in the list and returns the inserted rows.
  ///
  /// The returned [AiChat]s will have their `id` fields set.
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
  Future<List<AiChat>> insert(
    _is.DatabaseSession session,
    List<AiChat> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AiChat>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AiChat] and returns the inserted row.
  ///
  /// The returned [AiChat] will have its `id` field set.
  Future<AiChat> insertRow(
    _is.DatabaseSession session,
    AiChat row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AiChat>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AiChat]s in the list and returns the resulting rows.
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
  /// The returned [AiChat]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiChat>> upsert(
    _is.DatabaseSession session,
    List<AiChat> rows, {
    required _is.ColumnSelections<AiChatTable> conflictColumns,
    _is.ColumnSelections<AiChatTable>? updateColumns,
    _is.WhereExpressionBuilder<AiChatTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AiChat>(
      rows,
      conflictColumns: conflictColumns(AiChat.t),
      updateColumns: updateColumns?.call(AiChat.t),
      updateWhere: updateWhere?.call(AiChat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AiChat] and returns the resulting row.
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
  /// The returned [AiChat] will have its `id` field set.
  Future<AiChat?> upsertRow(
    _is.DatabaseSession session,
    AiChat row, {
    required _is.ColumnSelections<AiChatTable> conflictColumns,
    _is.ColumnSelections<AiChatTable>? updateColumns,
    _is.WhereExpressionBuilder<AiChatTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AiChat>(
      row,
      conflictColumns: conflictColumns(AiChat.t),
      updateColumns: updateColumns?.call(AiChat.t),
      updateWhere: updateWhere?.call(AiChat.t),
      transaction: transaction,
    );
  }

  /// Updates all [AiChat]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiChat>> update(
    _is.DatabaseSession session,
    List<AiChat> rows, {
    _is.ColumnSelections<AiChatTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AiChat>(
      rows,
      columns: columns?.call(AiChat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AiChat]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AiChat> updateRow(
    _is.DatabaseSession session,
    AiChat row, {
    _is.ColumnSelections<AiChatTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AiChat>(
      row,
      columns: columns?.call(AiChat.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AiChat] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AiChat?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AiChatUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AiChat>(
      id,
      columnValues: columnValues(AiChat.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AiChat]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiChat>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AiChatUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AiChatTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiChatTable>? orderBy,
    _is.OrderByListBuilder<AiChatTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AiChat>(
      columnValues: columnValues(AiChat.t.updateTable),
      where: where(AiChat.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiChat.t),
      orderByList: orderByList?.call(AiChat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AiChat]s in the list and returns the deleted rows.
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
  Future<List<AiChat>> delete(
    _is.DatabaseSession session,
    List<AiChat> rows, {
    _is.OrderByBuilder<AiChatTable>? orderBy,
    _is.OrderByListBuilder<AiChatTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AiChat>(
      rows,
      orderBy: orderBy?.call(AiChat.t),
      orderByList: orderByList?.call(AiChat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AiChat].
  Future<AiChat> deleteRow(
    _is.DatabaseSession session,
    AiChat row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AiChat>(
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
  Future<List<AiChat>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiChatTable> where,
    _is.OrderByBuilder<AiChatTable>? orderBy,
    _is.OrderByListBuilder<AiChatTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AiChat>(
      where: where(AiChat.t),
      orderBy: orderBy?.call(AiChat.t),
      orderByList: orderByList?.call(AiChat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiChatTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AiChat>(
      where: where?.call(AiChat.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AiChat] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiChatTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AiChat>(
      where: where(AiChat.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
