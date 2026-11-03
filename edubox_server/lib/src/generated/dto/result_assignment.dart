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

abstract class ResultAssignment
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ResultAssignment._({
    required this.id,
    required this.title,
    required this.type,
    this.dueAt,
    this.timeLimitSec,
  });

  factory ResultAssignment({
    required int id,
    required String title,
    required _ilbj7cyv.AssignmentType type,
    DateTime? dueAt,
    int? timeLimitSec,
  }) = _ResultAssignmentImpl;

  factory ResultAssignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResultAssignment(
      id: jsonSerialization['id'] as int,
      title: jsonSerialization['title'] as String,
      type: _ilbj7cyv.AssignmentType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      timeLimitSec: jsonSerialization['timeLimitSec'] as int?,
    );
  }

  int id;

  String title;

  _ilbj7cyv.AssignmentType type;

  DateTime? dueAt;

  int? timeLimitSec;

  /// Returns a shallow copy of this [ResultAssignment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ResultAssignment copyWith({
    int? id,
    String? title,
    _ilbj7cyv.AssignmentType? type,
    DateTime? dueAt,
    int? timeLimitSec,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResultAssignment',
      'id': id,
      'title': title,
      'type': type.toJson(),
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (timeLimitSec != null) 'timeLimitSec': timeLimitSec,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResultAssignment',
      'id': id,
      'title': title,
      'type': type.toJson(),
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

class _ResultAssignmentImpl extends ResultAssignment {
  _ResultAssignmentImpl({
    required int id,
    required String title,
    required _ilbj7cyv.AssignmentType type,
    DateTime? dueAt,
    int? timeLimitSec,
  }) : super._(
         id: id,
         title: title,
         type: type,
         dueAt: dueAt,
         timeLimitSec: timeLimitSec,
       );

  /// Returns a shallow copy of this [ResultAssignment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ResultAssignment copyWith({
    int? id,
    String? title,
    _ilbj7cyv.AssignmentType? type,
    Object? dueAt = _Undefined,
    Object? timeLimitSec = _Undefined,
  }) {
    return ResultAssignment(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      timeLimitSec: timeLimitSec is int? ? timeLimitSec : this.timeLimitSec,
    );
  }
}
