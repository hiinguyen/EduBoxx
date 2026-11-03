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
import '../dto/student_question.dart' as _i04jrp50;

abstract class StudentExerciseDetail
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StudentExerciseDetail._({
    required this.id,
    required this.contentId,
    required this.title,
    required this.subject,
    required this.gradeLevel,
    this.lessonContentId,
    this.lessonTitle,
    required this.questions,
  });

  factory StudentExerciseDetail({
    required int id,
    required int contentId,
    required String title,
    required String subject,
    required int gradeLevel,
    int? lessonContentId,
    String? lessonTitle,
    required List<_i04jrp50.StudentQuestion> questions,
  }) = _StudentExerciseDetailImpl;

  factory StudentExerciseDetail.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return StudentExerciseDetail(
      id: jsonSerialization['id'] as int,
      contentId: jsonSerialization['contentId'] as int,
      title: jsonSerialization['title'] as String,
      subject: jsonSerialization['subject'] as String,
      gradeLevel: jsonSerialization['gradeLevel'] as int,
      lessonContentId: jsonSerialization['lessonContentId'] as int?,
      lessonTitle: jsonSerialization['lessonTitle'] as String?,
      questions: _is7bdeiu.Protocol()
          .deserialize<List<_i04jrp50.StudentQuestion>>(
            jsonSerialization['questions'],
          ),
    );
  }

  int id;

  int contentId;

  String title;

  String subject;

  int gradeLevel;

  int? lessonContentId;

  String? lessonTitle;

  List<_i04jrp50.StudentQuestion> questions;

  /// Returns a shallow copy of this [StudentExerciseDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StudentExerciseDetail copyWith({
    int? id,
    int? contentId,
    String? title,
    String? subject,
    int? gradeLevel,
    int? lessonContentId,
    String? lessonTitle,
    List<_i04jrp50.StudentQuestion>? questions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentExerciseDetail',
      'id': id,
      'contentId': contentId,
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      if (lessonContentId != null) 'lessonContentId': lessonContentId,
      if (lessonTitle != null) 'lessonTitle': lessonTitle,
      'questions': questions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentExerciseDetail',
      'id': id,
      'contentId': contentId,
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      if (lessonContentId != null) 'lessonContentId': lessonContentId,
      if (lessonTitle != null) 'lessonTitle': lessonTitle,
      'questions': questions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentExerciseDetailImpl extends StudentExerciseDetail {
  _StudentExerciseDetailImpl({
    required int id,
    required int contentId,
    required String title,
    required String subject,
    required int gradeLevel,
    int? lessonContentId,
    String? lessonTitle,
    required List<_i04jrp50.StudentQuestion> questions,
  }) : super._(
         id: id,
         contentId: contentId,
         title: title,
         subject: subject,
         gradeLevel: gradeLevel,
         lessonContentId: lessonContentId,
         lessonTitle: lessonTitle,
         questions: questions,
       );

  /// Returns a shallow copy of this [StudentExerciseDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StudentExerciseDetail copyWith({
    int? id,
    int? contentId,
    String? title,
    String? subject,
    int? gradeLevel,
    Object? lessonContentId = _Undefined,
    Object? lessonTitle = _Undefined,
    List<_i04jrp50.StudentQuestion>? questions,
  }) {
    return StudentExerciseDetail(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      lessonContentId: lessonContentId is int?
          ? lessonContentId
          : this.lessonContentId,
      lessonTitle: lessonTitle is String? ? lessonTitle : this.lessonTitle,
      questions:
          questions ?? this.questions.map((e0) => e0.copyWith()).toList(),
    );
  }
}
