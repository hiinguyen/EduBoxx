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
import '../enums/content_type.dart' as _iqkq9d0y;

abstract class ContentDetail
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ContentDetail._({
    required this.id,
    required this.type,
    required this.title,
    required this.subject,
    required this.gradeLevel,
    required this.hasFile,
    this.mimeType,
    this.sizeBytes,
    this.pageCount,
    this.durationSeconds,
    required this.createdAt,
    required this.lessonCompleted,
  });

  factory ContentDetail({
    required int id,
    required _iqkq9d0y.ContentType type,
    required String title,
    required String subject,
    required int gradeLevel,
    required bool hasFile,
    String? mimeType,
    int? sizeBytes,
    int? pageCount,
    int? durationSeconds,
    required DateTime createdAt,
    required bool lessonCompleted,
  }) = _ContentDetailImpl;

  factory ContentDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return ContentDetail(
      id: jsonSerialization['id'] as int,
      type: _iqkq9d0y.ContentType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      title: jsonSerialization['title'] as String,
      subject: jsonSerialization['subject'] as String,
      gradeLevel: jsonSerialization['gradeLevel'] as int,
      hasFile: _isc.BoolJsonExtension.fromJson(jsonSerialization['hasFile']),
      mimeType: jsonSerialization['mimeType'] as String?,
      sizeBytes: jsonSerialization['sizeBytes'] as int?,
      pageCount: jsonSerialization['pageCount'] as int?,
      durationSeconds: jsonSerialization['durationSeconds'] as int?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lessonCompleted: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['lessonCompleted'],
      ),
    );
  }

  int id;

  _iqkq9d0y.ContentType type;

  String title;

  String subject;

  int gradeLevel;

  bool hasFile;

  String? mimeType;

  int? sizeBytes;

  int? pageCount;

  int? durationSeconds;

  DateTime createdAt;

  bool lessonCompleted;

  /// Returns a shallow copy of this [ContentDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ContentDetail copyWith({
    int? id,
    _iqkq9d0y.ContentType? type,
    String? title,
    String? subject,
    int? gradeLevel,
    bool? hasFile,
    String? mimeType,
    int? sizeBytes,
    int? pageCount,
    int? durationSeconds,
    DateTime? createdAt,
    bool? lessonCompleted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ContentDetail',
      'id': id,
      'type': type.toJson(),
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      'hasFile': hasFile,
      if (mimeType != null) 'mimeType': mimeType,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (pageCount != null) 'pageCount': pageCount,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      'createdAt': createdAt.toJson(),
      'lessonCompleted': lessonCompleted,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ContentDetail',
      'id': id,
      'type': type.toJson(),
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      'hasFile': hasFile,
      if (mimeType != null) 'mimeType': mimeType,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (pageCount != null) 'pageCount': pageCount,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      'createdAt': createdAt.toJson(),
      'lessonCompleted': lessonCompleted,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ContentDetailImpl extends ContentDetail {
  _ContentDetailImpl({
    required int id,
    required _iqkq9d0y.ContentType type,
    required String title,
    required String subject,
    required int gradeLevel,
    required bool hasFile,
    String? mimeType,
    int? sizeBytes,
    int? pageCount,
    int? durationSeconds,
    required DateTime createdAt,
    required bool lessonCompleted,
  }) : super._(
         id: id,
         type: type,
         title: title,
         subject: subject,
         gradeLevel: gradeLevel,
         hasFile: hasFile,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         pageCount: pageCount,
         durationSeconds: durationSeconds,
         createdAt: createdAt,
         lessonCompleted: lessonCompleted,
       );

  /// Returns a shallow copy of this [ContentDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ContentDetail copyWith({
    int? id,
    _iqkq9d0y.ContentType? type,
    String? title,
    String? subject,
    int? gradeLevel,
    bool? hasFile,
    Object? mimeType = _Undefined,
    Object? sizeBytes = _Undefined,
    Object? pageCount = _Undefined,
    Object? durationSeconds = _Undefined,
    DateTime? createdAt,
    bool? lessonCompleted,
  }) {
    return ContentDetail(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      hasFile: hasFile ?? this.hasFile,
      mimeType: mimeType is String? ? mimeType : this.mimeType,
      sizeBytes: sizeBytes is int? ? sizeBytes : this.sizeBytes,
      pageCount: pageCount is int? ? pageCount : this.pageCount,
      durationSeconds: durationSeconds is int?
          ? durationSeconds
          : this.durationSeconds,
      createdAt: createdAt ?? this.createdAt,
      lessonCompleted: lessonCompleted ?? this.lessonCompleted,
    );
  }
}
