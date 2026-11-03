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
import '../enums/chat_role.dart' as _iuimk8yo;

abstract class AiMessage
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AiMessage._({
    this.id,
    required this.chatId,
    required this.role,
    required this.content,
    required this.position,
    required this.createdAt,
  });

  factory AiMessage({
    int? id,
    required int chatId,
    required _iuimk8yo.ChatRole role,
    required String content,
    required int position,
    required DateTime createdAt,
  }) = _AiMessageImpl;

  factory AiMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiMessage(
      id: jsonSerialization['id'] as int?,
      chatId: jsonSerialization['chatId'] as int,
      role: _iuimk8yo.ChatRole.fromJson((jsonSerialization['role'] as String)),
      content: jsonSerialization['content'] as String,
      position: jsonSerialization['position'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AiMessageTable();

  static const db = AiMessageRepository._();

  @override
  int? id;

  int chatId;

  _iuimk8yo.ChatRole role;

  String content;

  int position;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AiMessage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AiMessage copyWith({
    int? id,
    int? chatId,
    _iuimk8yo.ChatRole? role,
    String? content,
    int? position,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiMessage',
      if (id != null) 'id': id,
      'chatId': chatId,
      'role': role.toJson(),
      'content': content,
      'position': position,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AiMessageInclude include() {
    return AiMessageInclude._();
  }

  static AiMessageIncludeList includeList({
    _is.WhereExpressionBuilder<AiMessageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiMessageTable>? orderBy,
    _is.OrderByListBuilder<AiMessageTable>? orderByList,
    AiMessageInclude? include,
  }) {
    return AiMessageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiMessage.t),
      orderByList: orderByList?.call(AiMessage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AiMessageImpl extends AiMessage {
  _AiMessageImpl({
    int? id,
    required int chatId,
    required _iuimk8yo.ChatRole role,
    required String content,
    required int position,
    required DateTime createdAt,
  }) : super._(
         id: id,
         chatId: chatId,
         role: role,
         content: content,
         position: position,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AiMessage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AiMessage copyWith({
    Object? id = _Undefined,
    int? chatId,
    _iuimk8yo.ChatRole? role,
    String? content,
    int? position,
    DateTime? createdAt,
  }) {
    return AiMessage(
      id: id is int? ? id : this.id,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      content: content ?? this.content,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AiMessageUpdateTable extends _is.UpdateTable<AiMessageTable> {
  AiMessageUpdateTable(super.table);

  _is.ColumnValue<int, int> chatId(int value) => _is.ColumnValue(
    table.chatId,
    value,
  );

  _is.ColumnValue<_iuimk8yo.ChatRole, _iuimk8yo.ChatRole> role(
    _iuimk8yo.ChatRole value,
  ) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<String, String> content(String value) => _is.ColumnValue(
    table.content,
    value,
  );

  _is.ColumnValue<int, int> position(int value) => _is.ColumnValue(
    table.position,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AiMessageTable extends _is.Table<int?> {
  AiMessageTable({super.tableRelation}) : super(tableName: 'ai_messages') {
    updateTable = AiMessageUpdateTable(this);
    chatId = _is.ColumnInt(
      'chatId',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
    );
    content = _is.ColumnString(
      'content',
      this,
    );
    position = _is.ColumnInt(
      'position',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AiMessageUpdateTable updateTable;

  late final _is.ColumnInt chatId;

  late final _is.ColumnEnum<_iuimk8yo.ChatRole> role;

  late final _is.ColumnString content;

  late final _is.ColumnInt position;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    chatId,
    role,
    content,
    position,
    createdAt,
  ];
}

class AiMessageInclude extends _is.IncludeObject {
  AiMessageInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AiMessage.t;
}

class AiMessageIncludeList extends _is.IncludeList {
  AiMessageIncludeList._({
    _is.WhereExpressionBuilder<AiMessageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AiMessage.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AiMessage.t;
}

class AiMessageRepository {
  const AiMessageRepository._();

  /// Returns a list of [AiMessage]s matching the given query parameters.
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
  Future<List<AiMessage>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiMessageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiMessageTable>? orderBy,
    _is.OrderByListBuilder<AiMessageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AiMessage>(
      where: where?.call(AiMessage.t),
      orderBy: orderBy?.call(AiMessage.t),
      orderByList: orderByList?.call(AiMessage.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AiMessage] matching the given query parameters.
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
  Future<AiMessage?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiMessageTable>? where,
    int? offset,
    _is.OrderByBuilder<AiMessageTable>? orderBy,
    _is.OrderByListBuilder<AiMessageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AiMessage>(
      where: where?.call(AiMessage.t),
      orderBy: orderBy?.call(AiMessage.t),
      orderByList: orderByList?.call(AiMessage.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AiMessage] by its [id] or null if no such row exists.
  Future<AiMessage?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AiMessage>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AiMessage]s in the list and returns the inserted rows.
  ///
  /// The returned [AiMessage]s will have their `id` fields set.
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
  Future<List<AiMessage>> insert(
    _is.DatabaseSession session,
    List<AiMessage> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AiMessage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AiMessage] and returns the inserted row.
  ///
  /// The returned [AiMessage] will have its `id` field set.
  Future<AiMessage> insertRow(
    _is.DatabaseSession session,
    AiMessage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AiMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AiMessage]s in the list and returns the resulting rows.
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
  /// The returned [AiMessage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiMessage>> upsert(
    _is.DatabaseSession session,
    List<AiMessage> rows, {
    required _is.ColumnSelections<AiMessageTable> conflictColumns,
    _is.ColumnSelections<AiMessageTable>? updateColumns,
    _is.WhereExpressionBuilder<AiMessageTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AiMessage>(
      rows,
      conflictColumns: conflictColumns(AiMessage.t),
      updateColumns: updateColumns?.call(AiMessage.t),
      updateWhere: updateWhere?.call(AiMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AiMessage] and returns the resulting row.
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
  /// The returned [AiMessage] will have its `id` field set.
  Future<AiMessage?> upsertRow(
    _is.DatabaseSession session,
    AiMessage row, {
    required _is.ColumnSelections<AiMessageTable> conflictColumns,
    _is.ColumnSelections<AiMessageTable>? updateColumns,
    _is.WhereExpressionBuilder<AiMessageTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AiMessage>(
      row,
      conflictColumns: conflictColumns(AiMessage.t),
      updateColumns: updateColumns?.call(AiMessage.t),
      updateWhere: updateWhere?.call(AiMessage.t),
      transaction: transaction,
    );
  }

  /// Updates all [AiMessage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiMessage>> update(
    _is.DatabaseSession session,
    List<AiMessage> rows, {
    _is.ColumnSelections<AiMessageTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AiMessage>(
      rows,
      columns: columns?.call(AiMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AiMessage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AiMessage> updateRow(
    _is.DatabaseSession session,
    AiMessage row, {
    _is.ColumnSelections<AiMessageTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AiMessage>(
      row,
      columns: columns?.call(AiMessage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AiMessage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AiMessage?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AiMessageUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AiMessage>(
      id,
      columnValues: columnValues(AiMessage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AiMessage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AiMessage>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AiMessageUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AiMessageTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AiMessageTable>? orderBy,
    _is.OrderByListBuilder<AiMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AiMessage>(
      columnValues: columnValues(AiMessage.t.updateTable),
      where: where(AiMessage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AiMessage.t),
      orderByList: orderByList?.call(AiMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AiMessage]s in the list and returns the deleted rows.
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
  Future<List<AiMessage>> delete(
    _is.DatabaseSession session,
    List<AiMessage> rows, {
    _is.OrderByBuilder<AiMessageTable>? orderBy,
    _is.OrderByListBuilder<AiMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AiMessage>(
      rows,
      orderBy: orderBy?.call(AiMessage.t),
      orderByList: orderByList?.call(AiMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AiMessage].
  Future<AiMessage> deleteRow(
    _is.DatabaseSession session,
    AiMessage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AiMessage>(
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
  Future<List<AiMessage>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiMessageTable> where,
    _is.OrderByBuilder<AiMessageTable>? orderBy,
    _is.OrderByListBuilder<AiMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AiMessage>(
      where: where(AiMessage.t),
      orderBy: orderBy?.call(AiMessage.t),
      orderByList: orderByList?.call(AiMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AiMessageTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AiMessage>(
      where: where?.call(AiMessage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AiMessage] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AiMessageTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AiMessage>(
      where: where(AiMessage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
