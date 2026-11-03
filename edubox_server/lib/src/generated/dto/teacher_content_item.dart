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
import '../enums/content_status.dart' as _inhfue1l;
import '../enums/content_type.dart' as _iqkq9d0y;
import '../enums/ingest_status.dart' as _ixfes7ab;

abstract class TeacherContentItem
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TeacherContentItem._({
    required this.id,
    required this.type,
    required this.title,
    required this.subject,
    required this.gradeLevel,
    required this.status,
    required this.ingestStatus,
    this.ingestReason,
    this.originalFileName,
    this.mimeType,
    this.sizeBytes,
    this.pageCount,
    this.durationSeconds,
    required this.createdAt,
    required this.classNames,
    this.exerciseId,
  });

  factory TeacherContentItem({
    required int id,
    required _iqkq9d0y.ContentType type,
    required String title,
    required String subject,
    required int gradeLevel,
    required _inhfue1l.ContentStatus status,
    required _ixfes7ab.IngestStatus ingestStatus,
    String? ingestReason,
    String? originalFileName,
    String? mimeType,
    int? sizeBytes,
    int? pageCount,
    int? durationSeconds,
    required DateTime createdAt,
    required List<String> classNames,
    int? exerciseId,
  }) = _TeacherContentItemImpl;

  factory TeacherContentItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return TeacherContentItem(
      id: jsonSerialization['id'] as int,
      type: _iqkq9d0y.ContentType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      title: jsonSerialization['title'] as String,
      subject: jsonSerialization['subject'] as String,
      gradeLevel: jsonSerialization['gradeLevel'] as int,
      status: _inhfue1l.ContentStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      ingestStatus: _ixfes7ab.IngestStatus.fromJson(
        (jsonSerialization['ingestStatus'] as String),
      ),
      ingestReason: jsonSerialization['ingestReason'] as String?,
      originalFileName: jsonSerialization['originalFileName'] as String?,
      mimeType: jsonSerialization['mimeType'] as String?,
      sizeBytes: jsonSerialization['sizeBytes'] as int?,
      pageCount: jsonSerialization['pageCount'] as int?,
      durationSeconds: jsonSerialization['durationSeconds'] as int?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      classNames: _is7bdeiu.Protocol().deserialize<List<String>>(
        jsonSerialization['classNames'],
      ),
      exerciseId: jsonSerialization['exerciseId'] as int?,
    );
  }

  int id;

  _iqkq9d0y.ContentType type;

  String title;

  String subject;

  int gradeLevel;

  _inhfue1l.ContentStatus status;

  _ixfes7ab.IngestStatus ingestStatus;

  String? ingestReason;

  String? originalFileName;

  String? mimeType;

  int? sizeBytes;

  int? pageCount;

  int? durationSeconds;

  DateTime createdAt;

  List<String> classNames;

  int? exerciseId;

  /// Returns a shallow copy of this [TeacherContentItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeacherContentItem copyWith({
    int? id,
    _iqkq9d0y.ContentType? type,
    String? title,
    String? subject,
    int? gradeLevel,
    _inhfue1l.ContentStatus? status,
    _ixfes7ab.IngestStatus? ingestStatus,
    String? ingestReason,
    String? originalFileName,
    String? mimeType,
    int? sizeBytes,
    int? pageCount,
    int? durationSeconds,
    DateTime? createdAt,
    List<String>? classNames,
    int? exerciseId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeacherContentItem',
      'id': id,
      'type': type.toJson(),
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      'status': status.toJson(),
      'ingestStatus': ingestStatus.toJson(),
      if (ingestReason != null) 'ingestReason': ingestReason,
      if (originalFileName != null) 'originalFileName': originalFileName,
      if (mimeType != null) 'mimeType': mimeType,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (pageCount != null) 'pageCount': pageCount,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      'createdAt': createdAt.toJson(),
      'classNames': classNames.toJson(),
      if (exerciseId != null) 'exerciseId': exerciseId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeacherContentItem',
      'id': id,
      'type': type.toJson(),
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      'status': status.toJson(),
      'ingestStatus': ingestStatus.toJson(),
      if (ingestReason != null) 'ingestReason': ingestReason,
      if (originalFileName != null) 'originalFileName': originalFileName,
      if (mimeType != null) 'mimeType': mimeType,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (pageCount != null) 'pageCount': pageCount,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      'createdAt': createdAt.toJson(),
      'classNames': classNames.toJson(),
      if (exerciseId != null) 'exerciseId': exerciseId,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeacherContentItemImpl extends TeacherContentItem {
  _TeacherContentItemImpl({
    required int id,
    required _iqkq9d0y.ContentType type,
    required String title,
    required String subject,
    required int gradeLevel,
    required _inhfue1l.ContentStatus status,
    required _ixfes7ab.IngestStatus ingestStatus,
    String? ingestReason,
    String? originalFileName,
    String? mimeType,
    int? sizeBytes,
    int? pageCount,
    int? durationSeconds,
    required DateTime createdAt,
    required List<String> classNames,
    int? exerciseId,
  }) : super._(
         id: id,
         type: type,
         title: title,
         subject: subject,
         gradeLevel: gradeLevel,
         status: status,
         ingestStatus: ingestStatus,
         ingestReason: ingestReason,
         originalFileName: originalFileName,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         pageCount: pageCount,
         durationSeconds: durationSeconds,
         createdAt: createdAt,
         classNames: classNames,
         exerciseId: exerciseId,
       );

  /// Returns a shallow copy of this [TeacherContentItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeacherContentItem copyWith({
    int? id,
    _iqkq9d0y.ContentType? type,
    String? title,
    String? subject,
    int? gradeLevel,
    _inhfue1l.ContentStatus? status,
    _ixfes7ab.IngestStatus? ingestStatus,
    Object? ingestReason = _Undefined,
    Object? originalFileName = _Undefined,
    Object? mimeType = _Undefined,
    Object? sizeBytes = _Undefined,
    Object? pageCount = _Undefined,
    Object? durationSeconds = _Undefined,
    DateTime? createdAt,
    List<String>? classNames,
    Object? exerciseId = _Undefined,
  }) {
    return TeacherContentItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      status: status ?? this.status,
      ingestStatus: ingestStatus ?? this.ingestStatus,
      ingestReason: ingestReason is String? ? ingestReason : this.ingestReason,
      originalFileName: originalFileName is String?
          ? originalFileName
          : this.originalFileName,
      mimeType: mimeType is String? ? mimeType : this.mimeType,
      sizeBytes: sizeBytes is int? ? sizeBytes : this.sizeBytes,
      pageCount: pageCount is int? ? pageCount : this.pageCount,
      durationSeconds: durationSeconds is int?
          ? durationSeconds
          : this.durationSeconds,
      createdAt: createdAt ?? this.createdAt,
      classNames: classNames ?? this.classNames.map((e0) => e0).toList(),
      exerciseId: exerciseId is int? ? exerciseId : this.exerciseId,
    );
  }
}
