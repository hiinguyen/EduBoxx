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
import '../enums/submission_reject_reason.dart' as _ikh41ef8;

abstract class SubmissionRejectedException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  SubmissionRejectedException._({required this.reason});

  factory SubmissionRejectedException({
    required _ikh41ef8.SubmissionRejectReason reason,
  }) = _SubmissionRejectedExceptionImpl;

  factory SubmissionRejectedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SubmissionRejectedException(
      reason: _ikh41ef8.SubmissionRejectReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _ikh41ef8.SubmissionRejectReason reason;

  /// Returns a shallow copy of this [SubmissionRejectedException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SubmissionRejectedException copyWith({
    _ikh41ef8.SubmissionRejectReason? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubmissionRejectedException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SubmissionRejectedException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'SubmissionRejectedException(reason: $reason)';
  }
}

class _SubmissionRejectedExceptionImpl extends SubmissionRejectedException {
  _SubmissionRejectedExceptionImpl({
    required _ikh41ef8.SubmissionRejectReason reason,
  }) : super._(reason: reason);

  /// Returns a shallow copy of this [SubmissionRejectedException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SubmissionRejectedException copyWith({
    _ikh41ef8.SubmissionRejectReason? reason,
  }) {
    return SubmissionRejectedException(reason: reason ?? this.reason);
  }
}
