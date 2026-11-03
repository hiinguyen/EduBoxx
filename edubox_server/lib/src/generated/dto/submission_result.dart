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
import 'package:edubox_server/src/generated/protocol.dart' as _is7bdeiu;
import 'package:serverpod/serverpod.dart' as _is;
import '../dto/submitted_answer.dart' as _iskykr4c;
import '../enums/graded_by.dart' as _ixjnete7;
import '../enums/submission_status.dart' as _ikv3vevs;

abstract class SubmissionResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SubmissionResult._({
    required this.id,
    required this.assignmentId,
    required this.clientSubmissionId,
    required this.status,
    this.score,
    this.maxScore,
    required this.late,
    this.startedAt,
    this.submittedAt,
    this.gradedAt,
    this.gradedBy,
    this.failureReason,
    required this.answers,
  });

  factory SubmissionResult({
    required int id,
    required int assignmentId,
    required String clientSubmissionId,
    required _ikv3vevs.SubmissionStatus status,
    double? score,
    double? maxScore,
    required bool late,
    DateTime? startedAt,
    DateTime? submittedAt,
    DateTime? gradedAt,
    _ixjnete7.GradedBy? gradedBy,
    String? failureReason,
    required List<_iskykr4c.SubmittedAnswer> answers,
  }) = _SubmissionResultImpl;

  factory SubmissionResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SubmissionResult(
      id: jsonSerialization['id'] as int,
      assignmentId: jsonSerialization['assignmentId'] as int,
      clientSubmissionId: jsonSerialization['clientSubmissionId'] as String,
      status: _ikv3vevs.SubmissionStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      score: (jsonSerialization['score'] as num?)?.toDouble(),
      maxScore: (jsonSerialization['maxScore'] as num?)?.toDouble(),
      late: _is.BoolJsonExtension.fromJson(jsonSerialization['late']),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      submittedAt: jsonSerialization['submittedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['submittedAt'],
            ),
      gradedAt: jsonSerialization['gradedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['gradedAt']),
      gradedBy: jsonSerialization['gradedBy'] == null
          ? null
          : _ixjnete7.GradedBy.fromJson(
              (jsonSerialization['gradedBy'] as String),
            ),
      failureReason: jsonSerialization['failureReason'] as String?,
      answers: _is7bdeiu.Protocol()
          .deserialize<List<_iskykr4c.SubmittedAnswer>>(
            jsonSerialization['answers'],
          ),
    );
  }

  int id;

  int assignmentId;

  String clientSubmissionId;

  _ikv3vevs.SubmissionStatus status;

  double? score;

  double? maxScore;

  bool late;

  DateTime? startedAt;

  DateTime? submittedAt;

  DateTime? gradedAt;

  _ixjnete7.GradedBy? gradedBy;

  String? failureReason;

  List<_iskykr4c.SubmittedAnswer> answers;

  /// Returns a shallow copy of this [SubmissionResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SubmissionResult copyWith({
    int? id,
    int? assignmentId,
    String? clientSubmissionId,
    _ikv3vevs.SubmissionStatus? status,
    double? score,
    double? maxScore,
    bool? late,
    DateTime? startedAt,
    DateTime? submittedAt,
    DateTime? gradedAt,
    _ixjnete7.GradedBy? gradedBy,
    String? failureReason,
    List<_iskykr4c.SubmittedAnswer>? answers,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubmissionResult',
      'id': id,
      'assignmentId': assignmentId,
      'clientSubmissionId': clientSubmissionId,
      'status': status.toJson(),
      if (score != null) 'score': score,
      if (maxScore != null) 'maxScore': maxScore,
      'late': late,
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (submittedAt != null) 'submittedAt': submittedAt?.toJson(),
      if (gradedAt != null) 'gradedAt': gradedAt?.toJson(),
      if (gradedBy != null) 'gradedBy': gradedBy?.toJson(),
      if (failureReason != null) 'failureReason': failureReason,
      'answers': answers.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SubmissionResult',
      'id': id,
      'assignmentId': assignmentId,
      'clientSubmissionId': clientSubmissionId,
      'status': status.toJson(),
      if (score != null) 'score': score,
      if (maxScore != null) 'maxScore': maxScore,
      'late': late,
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (submittedAt != null) 'submittedAt': submittedAt?.toJson(),
      if (gradedAt != null) 'gradedAt': gradedAt?.toJson(),
      if (gradedBy != null) 'gradedBy': gradedBy?.toJson(),
      if (failureReason != null) 'failureReason': failureReason,
      'answers': answers.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SubmissionResultImpl extends SubmissionResult {
  _SubmissionResultImpl({
    required int id,
    required int assignmentId,
    required String clientSubmissionId,
    required _ikv3vevs.SubmissionStatus status,
    double? score,
    double? maxScore,
    required bool late,
    DateTime? startedAt,
    DateTime? submittedAt,
    DateTime? gradedAt,
    _ixjnete7.GradedBy? gradedBy,
    String? failureReason,
    required List<_iskykr4c.SubmittedAnswer> answers,
  }) : super._(
         id: id,
         assignmentId: assignmentId,
         clientSubmissionId: clientSubmissionId,
         status: status,
         score: score,
         maxScore: maxScore,
         late: late,
         startedAt: startedAt,
         submittedAt: submittedAt,
         gradedAt: gradedAt,
         gradedBy: gradedBy,
         failureReason: failureReason,
         answers: answers,
       );

  /// Returns a shallow copy of this [SubmissionResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SubmissionResult copyWith({
    int? id,
    int? assignmentId,
    String? clientSubmissionId,
    _ikv3vevs.SubmissionStatus? status,
    Object? score = _Undefined,
    Object? maxScore = _Undefined,
    bool? late,
    Object? startedAt = _Undefined,
    Object? submittedAt = _Undefined,
    Object? gradedAt = _Undefined,
    Object? gradedBy = _Undefined,
    Object? failureReason = _Undefined,
    List<_iskykr4c.SubmittedAnswer>? answers,
  }) {
    return SubmissionResult(
      id: id ?? this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      clientSubmissionId: clientSubmissionId ?? this.clientSubmissionId,
      status: status ?? this.status,
      score: score is double? ? score : this.score,
      maxScore: maxScore is double? ? maxScore : this.maxScore,
      late: late ?? this.late,
      startedAt: startedAt is DateTime? ? startedAt : this.startedAt,
      submittedAt: submittedAt is DateTime? ? submittedAt : this.submittedAt,
      gradedAt: gradedAt is DateTime? ? gradedAt : this.gradedAt,
      gradedBy: gradedBy is _ixjnete7.GradedBy? ? gradedBy : this.gradedBy,
      failureReason: failureReason is String?
          ? failureReason
          : this.failureReason,
      answers: answers ?? this.answers.map((e0) => e0.copyWith()).toList(),
    );
  }
}
