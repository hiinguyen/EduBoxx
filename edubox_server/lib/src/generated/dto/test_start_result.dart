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

abstract class TestStartResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TestStartResult._({
    required this.assignmentId,
    required this.submissionId,
    required this.clientSubmissionId,
    required this.startedAt,
    required this.deadline,
  });

  factory TestStartResult({
    required int assignmentId,
    required int submissionId,
    required String clientSubmissionId,
    required DateTime startedAt,
    required DateTime deadline,
  }) = _TestStartResultImpl;

  factory TestStartResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return TestStartResult(
      assignmentId: jsonSerialization['assignmentId'] as int,
      submissionId: jsonSerialization['submissionId'] as int,
      clientSubmissionId: jsonSerialization['clientSubmissionId'] as String,
      startedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      deadline: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['deadline'],
      ),
    );
  }

  int assignmentId;

  int submissionId;

  String clientSubmissionId;

  DateTime startedAt;

  DateTime deadline;

  /// Returns a shallow copy of this [TestStartResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TestStartResult copyWith({
    int? assignmentId,
    int? submissionId,
    String? clientSubmissionId,
    DateTime? startedAt,
    DateTime? deadline,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TestStartResult',
      'assignmentId': assignmentId,
      'submissionId': submissionId,
      'clientSubmissionId': clientSubmissionId,
      'startedAt': startedAt.toJson(),
      'deadline': deadline.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TestStartResult',
      'assignmentId': assignmentId,
      'submissionId': submissionId,
      'clientSubmissionId': clientSubmissionId,
      'startedAt': startedAt.toJson(),
      'deadline': deadline.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TestStartResultImpl extends TestStartResult {
  _TestStartResultImpl({
    required int assignmentId,
    required int submissionId,
    required String clientSubmissionId,
    required DateTime startedAt,
    required DateTime deadline,
  }) : super._(
         assignmentId: assignmentId,
         submissionId: submissionId,
         clientSubmissionId: clientSubmissionId,
         startedAt: startedAt,
         deadline: deadline,
       );

  /// Returns a shallow copy of this [TestStartResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TestStartResult copyWith({
    int? assignmentId,
    int? submissionId,
    String? clientSubmissionId,
    DateTime? startedAt,
    DateTime? deadline,
  }) {
    return TestStartResult(
      assignmentId: assignmentId ?? this.assignmentId,
      submissionId: submissionId ?? this.submissionId,
      clientSubmissionId: clientSubmissionId ?? this.clientSubmissionId,
      startedAt: startedAt ?? this.startedAt,
      deadline: deadline ?? this.deadline,
    );
  }
}
