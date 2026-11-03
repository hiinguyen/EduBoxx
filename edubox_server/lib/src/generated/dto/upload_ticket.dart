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

abstract class UploadTicket
    implements _is.SerializableModel, _is.ProtocolSerialization {
  UploadTicket._({
    required this.contentId,
    required this.url,
    required this.method,
    required this.headers,
    required this.expiresAt,
  });

  factory UploadTicket({
    required int contentId,
    required String url,
    required String method,
    required Map<String, String> headers,
    required DateTime expiresAt,
  }) = _UploadTicketImpl;

  factory UploadTicket.fromJson(Map<String, dynamic> jsonSerialization) {
    return UploadTicket(
      contentId: jsonSerialization['contentId'] as int,
      url: jsonSerialization['url'] as String,
      method: jsonSerialization['method'] as String,
      headers: _is7bdeiu.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['headers'],
      ),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  int contentId;

  String url;

  String method;

  Map<String, String> headers;

  DateTime expiresAt;

  /// Returns a shallow copy of this [UploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UploadTicket copyWith({
    int? contentId,
    String? url,
    String? method,
    Map<String, String>? headers,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UploadTicket',
      'contentId': contentId,
      'url': url,
      'method': method,
      'headers': headers.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UploadTicket',
      'contentId': contentId,
      'url': url,
      'method': method,
      'headers': headers.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UploadTicketImpl extends UploadTicket {
  _UploadTicketImpl({
    required int contentId,
    required String url,
    required String method,
    required Map<String, String> headers,
    required DateTime expiresAt,
  }) : super._(
         contentId: contentId,
         url: url,
         method: method,
         headers: headers,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [UploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UploadTicket copyWith({
    int? contentId,
    String? url,
    String? method,
    Map<String, String>? headers,
    DateTime? expiresAt,
  }) {
    return UploadTicket(
      contentId: contentId ?? this.contentId,
      url: url ?? this.url,
      method: method ?? this.method,
      headers:
          headers ??
          this.headers.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
