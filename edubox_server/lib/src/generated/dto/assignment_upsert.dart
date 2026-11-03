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
import '../enums/assignment_type.dart' as _ilbj7cyv;

abstract class AssignmentUpsert
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AssignmentUpsert._({
    this.id,
    required this.classId,
    required this.exerciseId,
    required this.type,
    required this.title,
    this.dueAt,
    this.timeLimitSec,
  });

  factory AssignmentUpsert({
    int? id,
    required int classId,
    required int exerciseId,
    required _ilbj7cyv.AssignmentType type,
    required String title,
    DateTime? dueAt,
    int? timeLimitSec,
  }) = _AssignmentUpsertImpl;

  factory AssignmentUpsert.fromJson(Map<String, dynamic> jsonSerialization) {
    return AssignmentUpsert(
      id: jsonSerialization['id'] as int?,
      classId: jsonSerialization['classId'] as int,
      exerciseId: jsonSerialization['exerciseId'] as int,
      type: _ilbj7cyv.AssignmentType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      title: jsonSerialization['title'] as String,
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      timeLimitSec: jsonSerialization['timeLimitSec'] as int?,
    );
  }

  int? id;

  int classId;

  int exerciseId;

  _ilbj7cyv.AssignmentType type;

  String title;

  DateTime? dueAt;

  int? timeLimitSec;

  /// Returns a shallow copy of this [AssignmentUpsert]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AssignmentUpsert copyWith({
    int? id,
    int? classId,
    int? exerciseId,
    _ilbj7cyv.AssignmentType? type,
    String? title,
    DateTime? dueAt,
    int? timeLimitSec,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AssignmentUpsert',
      if (id != null) 'id': id,
      'classId': classId,
      'exerciseId': exerciseId,
      'type': type.toJson(),
      'title': title,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (timeLimitSec != null) 'timeLimitSec': timeLimitSec,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AssignmentUpsert',
      if (id != null) 'id': id,
      'classId': classId,
      'exerciseId': exerciseId,
      'type': type.toJson(),
      'title': title,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (timeLimitSec != null) 'timeLimitSec': timeLimitSec,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AssignmentUpsertImpl extends AssignmentUpsert {
  _AssignmentUpsertImpl({
    int? id,
    required int classId,
    required int exerciseId,
    required _ilbj7cyv.AssignmentType type,
    required String title,
    DateTime? dueAt,
    int? timeLimitSec,
  }) : super._(
         id: id,
         classId: classId,
         exerciseId: exerciseId,
         type: type,
         title: title,
         dueAt: dueAt,
         timeLimitSec: timeLimitSec,
       );

  /// Returns a shallow copy of this [AssignmentUpsert]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AssignmentUpsert copyWith({
    Object? id = _Undefined,
    int? classId,
    int? exerciseId,
    _ilbj7cyv.AssignmentType? type,
    String? title,
    Object? dueAt = _Undefined,
    Object? timeLimitSec = _Undefined,
  }) {
    return AssignmentUpsert(
      id: id is int? ? id : this.id,
      classId: classId ?? this.classId,
      exerciseId: exerciseId ?? this.exerciseId,
      type: type ?? this.type,
      title: title ?? this.title,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      timeLimitSec: timeLimitSec is int? ? timeLimitSec : this.timeLimitSec,
    );
  }
}
