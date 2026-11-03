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

abstract class TeacherAssignmentItem
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TeacherAssignmentItem._({
    required this.id,
    required this.classId,
    required this.className,
    required this.exerciseId,
    required this.exerciseTitle,
    required this.type,
    required this.title,
    this.dueAt,
    this.timeLimitSec,
    required this.submissionCount,
    required this.gradedCount,
    required this.createdAt,
  });

  factory TeacherAssignmentItem({
    required int id,
    required int classId,
    required String className,
    required int exerciseId,
    required String exerciseTitle,
    required _ilbj7cyv.AssignmentType type,
    required String title,
    DateTime? dueAt,
    int? timeLimitSec,
    required int submissionCount,
    required int gradedCount,
    required DateTime createdAt,
  }) = _TeacherAssignmentItemImpl;

  factory TeacherAssignmentItem.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeacherAssignmentItem(
      id: jsonSerialization['id'] as int,
      classId: jsonSerialization['classId'] as int,
      className: jsonSerialization['className'] as String,
      exerciseId: jsonSerialization['exerciseId'] as int,
      exerciseTitle: jsonSerialization['exerciseTitle'] as String,
      type: _ilbj7cyv.AssignmentType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      title: jsonSerialization['title'] as String,
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      timeLimitSec: jsonSerialization['timeLimitSec'] as int?,
      submissionCount: jsonSerialization['submissionCount'] as int,
      gradedCount: jsonSerialization['gradedCount'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  int classId;

  String className;

  int exerciseId;

  String exerciseTitle;

  _ilbj7cyv.AssignmentType type;

  String title;

  DateTime? dueAt;

  int? timeLimitSec;

  int submissionCount;

  int gradedCount;

  DateTime createdAt;

  /// Returns a shallow copy of this [TeacherAssignmentItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeacherAssignmentItem copyWith({
    int? id,
    int? classId,
    String? className,
    int? exerciseId,
    String? exerciseTitle,
    _ilbj7cyv.AssignmentType? type,
    String? title,
    DateTime? dueAt,
    int? timeLimitSec,
    int? submissionCount,
    int? gradedCount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeacherAssignmentItem',
      'id': id,
      'classId': classId,
      'className': className,
      'exerciseId': exerciseId,
      'exerciseTitle': exerciseTitle,
      'type': type.toJson(),
      'title': title,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (timeLimitSec != null) 'timeLimitSec': timeLimitSec,
      'submissionCount': submissionCount,
      'gradedCount': gradedCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeacherAssignmentItem',
      'id': id,
      'classId': classId,
      'className': className,
      'exerciseId': exerciseId,
      'exerciseTitle': exerciseTitle,
      'type': type.toJson(),
      'title': title,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (timeLimitSec != null) 'timeLimitSec': timeLimitSec,
      'submissionCount': submissionCount,
      'gradedCount': gradedCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeacherAssignmentItemImpl extends TeacherAssignmentItem {
  _TeacherAssignmentItemImpl({
    required int id,
    required int classId,
    required String className,
    required int exerciseId,
    required String exerciseTitle,
    required _ilbj7cyv.AssignmentType type,
    required String title,
    DateTime? dueAt,
    int? timeLimitSec,
    required int submissionCount,
    required int gradedCount,
    required DateTime createdAt,
  }) : super._(
         id: id,
         classId: classId,
         className: className,
         exerciseId: exerciseId,
         exerciseTitle: exerciseTitle,
         type: type,
         title: title,
         dueAt: dueAt,
         timeLimitSec: timeLimitSec,
         submissionCount: submissionCount,
         gradedCount: gradedCount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TeacherAssignmentItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeacherAssignmentItem copyWith({
    int? id,
    int? classId,
    String? className,
    int? exerciseId,
    String? exerciseTitle,
    _ilbj7cyv.AssignmentType? type,
    String? title,
    Object? dueAt = _Undefined,
    Object? timeLimitSec = _Undefined,
    int? submissionCount,
    int? gradedCount,
    DateTime? createdAt,
  }) {
    return TeacherAssignmentItem(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseTitle: exerciseTitle ?? this.exerciseTitle,
      type: type ?? this.type,
      title: title ?? this.title,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      timeLimitSec: timeLimitSec is int? ? timeLimitSec : this.timeLimitSec,
      submissionCount: submissionCount ?? this.submissionCount,
      gradedCount: gradedCount ?? this.gradedCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
