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
import '../dto/exercise_question_input.dart' as _i8fxap8r;

abstract class TeacherExerciseDetail
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TeacherExerciseDetail._({
    required this.id,
    required this.contentId,
    required this.title,
    required this.subject,
    required this.gradeLevel,
    this.lessonContentId,
    required this.questions,
    required this.updatedAt,
  });

  factory TeacherExerciseDetail({
    required int id,
    required int contentId,
    required String title,
    required String subject,
    required int gradeLevel,
    int? lessonContentId,
    required List<_i8fxap8r.ExerciseQuestionInput> questions,
    required DateTime updatedAt,
  }) = _TeacherExerciseDetailImpl;

  factory TeacherExerciseDetail.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TeacherExerciseDetail(
      id: jsonSerialization['id'] as int,
      contentId: jsonSerialization['contentId'] as int,
      title: jsonSerialization['title'] as String,
      subject: jsonSerialization['subject'] as String,
      gradeLevel: jsonSerialization['gradeLevel'] as int,
      lessonContentId: jsonSerialization['lessonContentId'] as int?,
      questions: _is7bdeiu.Protocol()
          .deserialize<List<_i8fxap8r.ExerciseQuestionInput>>(
            jsonSerialization['questions'],
          ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  int id;

  int contentId;

  String title;

  String subject;

  int gradeLevel;

  int? lessonContentId;

  List<_i8fxap8r.ExerciseQuestionInput> questions;

  DateTime updatedAt;

  /// Returns a shallow copy of this [TeacherExerciseDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TeacherExerciseDetail copyWith({
    int? id,
    int? contentId,
    String? title,
    String? subject,
    int? gradeLevel,
    int? lessonContentId,
    List<_i8fxap8r.ExerciseQuestionInput>? questions,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TeacherExerciseDetail',
      'id': id,
      'contentId': contentId,
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      if (lessonContentId != null) 'lessonContentId': lessonContentId,
      'questions': questions.toJson(valueToJson: (v) => v.toJson()),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TeacherExerciseDetail',
      'id': id,
      'contentId': contentId,
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      if (lessonContentId != null) 'lessonContentId': lessonContentId,
      'questions': questions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeacherExerciseDetailImpl extends TeacherExerciseDetail {
  _TeacherExerciseDetailImpl({
    required int id,
    required int contentId,
    required String title,
    required String subject,
    required int gradeLevel,
    int? lessonContentId,
    required List<_i8fxap8r.ExerciseQuestionInput> questions,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         contentId: contentId,
         title: title,
         subject: subject,
         gradeLevel: gradeLevel,
         lessonContentId: lessonContentId,
         questions: questions,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [TeacherExerciseDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TeacherExerciseDetail copyWith({
    int? id,
    int? contentId,
    String? title,
    String? subject,
    int? gradeLevel,
    Object? lessonContentId = _Undefined,
    List<_i8fxap8r.ExerciseQuestionInput>? questions,
    DateTime? updatedAt,
  }) {
    return TeacherExerciseDetail(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      lessonContentId: lessonContentId is int?
          ? lessonContentId
          : this.lessonContentId,
      questions:
          questions ?? this.questions.map((e0) => e0.copyWith()).toList(),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
