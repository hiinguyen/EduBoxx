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
import 'package:edubox_client/src/protocol/protocol.dart' as _ivwnx0wz;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../dto/tutor_message.dart' as _i7gkjhzu;

abstract class TutorChatDetail
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TutorChatDetail._({
    required this.id,
    required this.subject,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.studentName,
    required this.messages,
  });

  factory TutorChatDetail({
    required int id,
    required String subject,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? studentName,
    required List<_i7gkjhzu.TutorMessage> messages,
  }) = _TutorChatDetailImpl;

  factory TutorChatDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return TutorChatDetail(
      id: jsonSerialization['id'] as int,
      subject: jsonSerialization['subject'] as String,
      title: jsonSerialization['title'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      studentName: jsonSerialization['studentName'] as String?,
      messages: _ivwnx0wz.Protocol().deserialize<List<_i7gkjhzu.TutorMessage>>(
        jsonSerialization['messages'],
      ),
    );
  }

  int id;

  String subject;

  String title;

  DateTime createdAt;

  DateTime updatedAt;

  String? studentName;

  List<_i7gkjhzu.TutorMessage> messages;

  /// Returns a shallow copy of this [TutorChatDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TutorChatDetail copyWith({
    int? id,
    String? subject,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? studentName,
    List<_i7gkjhzu.TutorMessage>? messages,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TutorChatDetail',
      'id': id,
      'subject': subject,
      'title': title,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (studentName != null) 'studentName': studentName,
      'messages': messages.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TutorChatDetail',
      'id': id,
      'subject': subject,
      'title': title,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (studentName != null) 'studentName': studentName,
      'messages': messages.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TutorChatDetailImpl extends TutorChatDetail {
  _TutorChatDetailImpl({
    required int id,
    required String subject,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? studentName,
    required List<_i7gkjhzu.TutorMessage> messages,
  }) : super._(
         id: id,
         subject: subject,
         title: title,
         createdAt: createdAt,
         updatedAt: updatedAt,
         studentName: studentName,
         messages: messages,
       );

  /// Returns a shallow copy of this [TutorChatDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TutorChatDetail copyWith({
    int? id,
    String? subject,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? studentName = _Undefined,
    List<_i7gkjhzu.TutorMessage>? messages,
  }) {
    return TutorChatDetail(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      studentName: studentName is String? ? studentName : this.studentName,
      messages: messages ?? this.messages.map((e0) => e0.copyWith()).toList(),
    );
  }
}
