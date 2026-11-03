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
import '../enums/submission_status.dart' as _ikv3vevs;

abstract class ParentResultEntry
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ParentResultEntry._({
    required this.assignmentId,
    required this.title,
    required this.type,
    this.dueAt,
    this.submittedAt,
    this.status,
    this.score,
    this.maxScore,
    required this.late,
  });

  factory ParentResultEntry({
    required int assignmentId,
    required String title,
    required _ilbj7cyv.AssignmentType type,
    DateTime? dueAt,
    DateTime? submittedAt,
    _ikv3vevs.SubmissionStatus? status,
    double? score,
    double? maxScore,
    required bool late,
  }) = _ParentResultEntryImpl;

  factory ParentResultEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentResultEntry(
      assignmentId: jsonSerialization['assignmentId'] as int,
      title: jsonSerialization['title'] as String,
      type: _ilbj7cyv.AssignmentType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      submittedAt: jsonSerialization['submittedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['submittedAt'],
            ),
      status: jsonSerialization['status'] == null
          ? null
          : _ikv3vevs.SubmissionStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      score: (jsonSerialization['score'] as num?)?.toDouble(),
      maxScore: (jsonSerialization['maxScore'] as num?)?.toDouble(),
      late: _is.BoolJsonExtension.fromJson(jsonSerialization['late']),
    );
  }

  int assignmentId;

  String title;

  _ilbj7cyv.AssignmentType type;

  DateTime? dueAt;

  DateTime? submittedAt;

  _ikv3vevs.SubmissionStatus? status;

  double? score;

  double? maxScore;

  bool late;

  /// Returns a shallow copy of this [ParentResultEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ParentResultEntry copyWith({
    int? assignmentId,
    String? title,
    _ilbj7cyv.AssignmentType? type,
    DateTime? dueAt,
    DateTime? submittedAt,
    _ikv3vevs.SubmissionStatus? status,
    double? score,
    double? maxScore,
    bool? late,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ParentResultEntry',
      'assignmentId': assignmentId,
      'title': title,
      'type': type.toJson(),
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (submittedAt != null) 'submittedAt': submittedAt?.toJson(),
      if (status != null) 'status': status?.toJson(),
      if (score != null) 'score': score,
      if (maxScore != null) 'maxScore': maxScore,
      'late': late,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ParentResultEntry',
      'assignmentId': assignmentId,
      'title': title,
      'type': type.toJson(),
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (submittedAt != null) 'submittedAt': submittedAt?.toJson(),
      if (status != null) 'status': status?.toJson(),
      if (score != null) 'score': score,
      if (maxScore != null) 'maxScore': maxScore,
      'late': late,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ParentResultEntryImpl extends ParentResultEntry {
  _ParentResultEntryImpl({
    required int assignmentId,
    required String title,
    required _ilbj7cyv.AssignmentType type,
    DateTime? dueAt,
    DateTime? submittedAt,
    _ikv3vevs.SubmissionStatus? status,
    double? score,
    double? maxScore,
    required bool late,
  }) : super._(
         assignmentId: assignmentId,
         title: title,
         type: type,
         dueAt: dueAt,
         submittedAt: submittedAt,
         status: status,
         score: score,
         maxScore: maxScore,
         late: late,
       );

  /// Returns a shallow copy of this [ParentResultEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ParentResultEntry copyWith({
    int? assignmentId,
    String? title,
    _ilbj7cyv.AssignmentType? type,
    Object? dueAt = _Undefined,
    Object? submittedAt = _Undefined,
    Object? status = _Undefined,
    Object? score = _Undefined,
    Object? maxScore = _Undefined,
    bool? late,
  }) {
    return ParentResultEntry(
      assignmentId: assignmentId ?? this.assignmentId,
      title: title ?? this.title,
      type: type ?? this.type,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      submittedAt: submittedAt is DateTime? ? submittedAt : this.submittedAt,
      status: status is _ikv3vevs.SubmissionStatus? ? status : this.status,
      score: score is double? ? score : this.score,
      maxScore: maxScore is double? ? maxScore : this.maxScore,
      late: late ?? this.late,
    );
  }
}
