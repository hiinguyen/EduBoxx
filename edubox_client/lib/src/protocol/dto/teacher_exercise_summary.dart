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

abstract class TeacherExerciseSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TeacherExerciseSummary._({
    required this.id,
    required this.contentId,
    required this.title,
    required this.subject,
    required this.gradeLevel,
    required this.questionCount,
    required this.updatedAt,
  });

  factory TeacherExerciseSummary({
    required int id,
    required int contentId,
    required String title,
    required String subject,
    required int gradeLevel,
    required int questionCount,
    required DateTime updatedAt,
  }) = _TeacherExerciseSummaryImpl;

  factory TeacherExerciseSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeacherExerciseSummary(
      id: jsonSerialization['id'] as int,
      contentId: jsonSerialization['contentId'] as int,
      title: jsonSerialization['title'] as String,
      subject: jsonSerialization['subject'] as String,
      gradeLevel: jsonSerialization['gradeLevel'] as int,
      questionCount: jsonSerialization['questionCount'] as int,
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  int id;

  int contentId;

  String title;

  String subject;

  int gradeLevel;

  int questionCount;

  DateTime updatedAt;

  /// Returns a shallow copy of this [TeacherExerciseSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TeacherExerciseSummary copyWith({
    int? id,
    int? contentId,
    String? title,
    String? subject,
    int? gradeLevel,
    int? questionCount,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeacherExerciseSummary',
      'id': id,
      'contentId': contentId,
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      'questionCount': questionCount,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeacherExerciseSummary',
      'id': id,
      'contentId': contentId,
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      'questionCount': questionCount,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TeacherExerciseSummaryImpl extends TeacherExerciseSummary {
  _TeacherExerciseSummaryImpl({
    required int id,
    required int contentId,
    required String title,
    required String subject,
    required int gradeLevel,
    required int questionCount,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         contentId: contentId,
         title: title,
         subject: subject,
         gradeLevel: gradeLevel,
         questionCount: questionCount,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [TeacherExerciseSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TeacherExerciseSummary copyWith({
    int? id,
    int? contentId,
    String? title,
    String? subject,
    int? gradeLevel,
    int? questionCount,
    DateTime? updatedAt,
  }) {
    return TeacherExerciseSummary(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      questionCount: questionCount ?? this.questionCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
