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
import '../enums/chat_role.dart' as _iuimk8yo;

abstract class TutorMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TutorMessage._({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory TutorMessage({
    required int id,
    required _iuimk8yo.ChatRole role,
    required String content,
    required DateTime createdAt,
  }) = _TutorMessageImpl;

  factory TutorMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return TutorMessage(
      id: jsonSerialization['id'] as int,
      role: _iuimk8yo.ChatRole.fromJson((jsonSerialization['role'] as String)),
      content: jsonSerialization['content'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  _iuimk8yo.ChatRole role;

  String content;

  DateTime createdAt;

  /// Returns a shallow copy of this [TutorMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TutorMessage copyWith({
    int? id,
    _iuimk8yo.ChatRole? role,
    String? content,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TutorMessage',
      'id': id,
      'role': role.toJson(),
      'content': content,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TutorMessage',
      'id': id,
      'role': role.toJson(),
      'content': content,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TutorMessageImpl extends TutorMessage {
  _TutorMessageImpl({
    required int id,
    required _iuimk8yo.ChatRole role,
    required String content,
    required DateTime createdAt,
  }) : super._(
         id: id,
         role: role,
         content: content,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TutorMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TutorMessage copyWith({
    int? id,
    _iuimk8yo.ChatRole? role,
    String? content,
    DateTime? createdAt,
  }) {
    return TutorMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
