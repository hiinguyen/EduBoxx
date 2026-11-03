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

abstract class TutorChatSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TutorChatSummary._({
    required this.id,
    required this.subject,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messageCount,
    this.studentName,
  });

  factory TutorChatSummary({
    required int id,
    required String subject,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int messageCount,
    String? studentName,
  }) = _TutorChatSummaryImpl;

  factory TutorChatSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return TutorChatSummary(
      id: jsonSerialization['id'] as int,
      subject: jsonSerialization['subject'] as String,
      title: jsonSerialization['title'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      messageCount: jsonSerialization['messageCount'] as int,
      studentName: jsonSerialization['studentName'] as String?,
    );
  }

  int id;

  String subject;

  String title;

  DateTime createdAt;

  DateTime updatedAt;

  int messageCount;

  String? studentName;

  /// Returns a shallow copy of this [TutorChatSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TutorChatSummary copyWith({
    int? id,
    String? subject,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? messageCount,
    String? studentName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TutorChatSummary',
      'id': id,
      'subject': subject,
      'title': title,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'messageCount': messageCount,
      if (studentName != null) 'studentName': studentName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TutorChatSummary',
      'id': id,
      'subject': subject,
      'title': title,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'messageCount': messageCount,
      if (studentName != null) 'studentName': studentName,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TutorChatSummaryImpl extends TutorChatSummary {
  _TutorChatSummaryImpl({
    required int id,
    required String subject,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int messageCount,
    String? studentName,
  }) : super._(
         id: id,
         subject: subject,
         title: title,
         createdAt: createdAt,
         updatedAt: updatedAt,
         messageCount: messageCount,
         studentName: studentName,
       );

  /// Returns a shallow copy of this [TutorChatSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TutorChatSummary copyWith({
    int? id,
    String? subject,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? messageCount,
    Object? studentName = _Undefined,
  }) {
    return TutorChatSummary(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageCount: messageCount ?? this.messageCount,
      studentName: studentName is String? ? studentName : this.studentName,
    );
  }
}
