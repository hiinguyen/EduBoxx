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

abstract class ProgressResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProgressResult._({
    required this.contentId,
    required this.status,
    required this.updatedAt,
  });

  factory ProgressResult({
    required int contentId,
    required String status,
    required DateTime updatedAt,
  }) = _ProgressResultImpl;

  factory ProgressResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProgressResult(
      contentId: jsonSerialization['contentId'] as int,
      status: jsonSerialization['status'] as String,
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  int contentId;

  String status;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ProgressResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProgressResult copyWith({
    int? contentId,
    String? status,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProgressResult',
      'contentId': contentId,
      'status': status,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProgressResult',
      'contentId': contentId,
      'status': status,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ProgressResultImpl extends ProgressResult {
  _ProgressResultImpl({
    required int contentId,
    required String status,
    required DateTime updatedAt,
  }) : super._(
         contentId: contentId,
         status: status,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProgressResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProgressResult copyWith({
    int? contentId,
    String? status,
    DateTime? updatedAt,
  }) {
    return ProgressResult(
      contentId: contentId ?? this.contentId,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
