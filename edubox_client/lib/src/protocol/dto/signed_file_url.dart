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

abstract class SignedFileUrl
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SignedFileUrl._({
    required this.url,
    required this.expiresAt,
  });

  factory SignedFileUrl({
    required String url,
    required DateTime expiresAt,
  }) = _SignedFileUrlImpl;

  factory SignedFileUrl.fromJson(Map<String, dynamic> jsonSerialization) {
    return SignedFileUrl(
      url: jsonSerialization['url'] as String,
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  String url;

  DateTime expiresAt;

  /// Returns a shallow copy of this [SignedFileUrl]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SignedFileUrl copyWith({
    String? url,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SignedFileUrl',
      'url': url,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SignedFileUrl',
      'url': url,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SignedFileUrlImpl extends SignedFileUrl {
  _SignedFileUrlImpl({
    required String url,
    required DateTime expiresAt,
  }) : super._(
         url: url,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [SignedFileUrl]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SignedFileUrl copyWith({
    String? url,
    DateTime? expiresAt,
  }) {
    return SignedFileUrl(
      url: url ?? this.url,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
