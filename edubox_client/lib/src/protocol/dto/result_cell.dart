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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../enums/submission_status.dart' as _ikv3vevs;

abstract class ResultCell
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ResultCell._({
    required this.studentId,
    required this.assignmentId,
    this.submissionId,
    this.status,
    this.score,
    this.maxScore,
    required this.late,
    this.clientSubmissionId,
  });

  factory ResultCell({
    required int studentId,
    required int assignmentId,
    int? submissionId,
    _ikv3vevs.SubmissionStatus? status,
    double? score,
    double? maxScore,
    required bool late,
    String? clientSubmissionId,
  }) = _ResultCellImpl;

  factory ResultCell.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResultCell(
      studentId: jsonSerialization['studentId'] as int,
      assignmentId: jsonSerialization['assignmentId'] as int,
      submissionId: jsonSerialization['submissionId'] as int?,
      status: jsonSerialization['status'] == null
          ? null
          : _ikv3vevs.SubmissionStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      score: (jsonSerialization['score'] as num?)?.toDouble(),
      maxScore: (jsonSerialization['maxScore'] as num?)?.toDouble(),
      late: _isc.BoolJsonExtension.fromJson(jsonSerialization['late']),
      clientSubmissionId: jsonSerialization['clientSubmissionId'] as String?,
    );
  }

  int studentId;

  int assignmentId;

  int? submissionId;

  _ikv3vevs.SubmissionStatus? status;

  double? score;

  double? maxScore;

  bool late;

  String? clientSubmissionId;

  /// Returns a shallow copy of this [ResultCell]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ResultCell copyWith({
    int? studentId,
    int? assignmentId,
    int? submissionId,
    _ikv3vevs.SubmissionStatus? status,
    double? score,
    double? maxScore,
    bool? late,
    String? clientSubmissionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResultCell',
      'studentId': studentId,
      'assignmentId': assignmentId,
      if (submissionId != null) 'submissionId': submissionId,
      if (status != null) 'status': status?.toJson(),
      if (score != null) 'score': score,
      if (maxScore != null) 'maxScore': maxScore,
      'late': late,
      if (clientSubmissionId != null) 'clientSubmissionId': clientSubmissionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResultCell',
      'studentId': studentId,
      'assignmentId': assignmentId,
      if (submissionId != null) 'submissionId': submissionId,
      if (status != null) 'status': status?.toJson(),
      if (score != null) 'score': score,
      if (maxScore != null) 'maxScore': maxScore,
      'late': late,
      if (clientSubmissionId != null) 'clientSubmissionId': clientSubmissionId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResultCellImpl extends ResultCell {
  _ResultCellImpl({
    required int studentId,
    required int assignmentId,
    int? submissionId,
    _ikv3vevs.SubmissionStatus? status,
    double? score,
    double? maxScore,
    required bool late,
    String? clientSubmissionId,
  }) : super._(
         studentId: studentId,
         assignmentId: assignmentId,
         submissionId: submissionId,
         status: status,
         score: score,
         maxScore: maxScore,
         late: late,
         clientSubmissionId: clientSubmissionId,
       );

  /// Returns a shallow copy of this [ResultCell]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ResultCell copyWith({
    int? studentId,
    int? assignmentId,
    Object? submissionId = _Undefined,
    Object? status = _Undefined,
    Object? score = _Undefined,
    Object? maxScore = _Undefined,
    bool? late,
    Object? clientSubmissionId = _Undefined,
  }) {
    return ResultCell(
      studentId: studentId ?? this.studentId,
      assignmentId: assignmentId ?? this.assignmentId,
      submissionId: submissionId is int? ? submissionId : this.submissionId,
      status: status is _ikv3vevs.SubmissionStatus? ? status : this.status,
      score: score is double? ? score : this.score,
      maxScore: maxScore is double? ? maxScore : this.maxScore,
      late: late ?? this.late,
      clientSubmissionId: clientSubmissionId is String?
          ? clientSubmissionId
          : this.clientSubmissionId,
    );
  }
}
