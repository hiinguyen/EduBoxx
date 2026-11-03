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
import '../dto/exercise_question_input.dart' as _i8fxap8r;

abstract class ExerciseUpsert
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ExerciseUpsert._({
    this.contentId,
    required this.classId,
    required this.title,
    required this.subject,
    required this.gradeLevel,
    this.lessonContentId,
    required this.questions,
  });

  factory ExerciseUpsert({
    int? contentId,
    required int classId,
    required String title,
    required String subject,
    required int gradeLevel,
    int? lessonContentId,
    required List<_i8fxap8r.ExerciseQuestionInput> questions,
  }) = _ExerciseUpsertImpl;

  factory ExerciseUpsert.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExerciseUpsert(
      contentId: jsonSerialization['contentId'] as int?,
      classId: jsonSerialization['classId'] as int,
      title: jsonSerialization['title'] as String,
      subject: jsonSerialization['subject'] as String,
      gradeLevel: jsonSerialization['gradeLevel'] as int,
      lessonContentId: jsonSerialization['lessonContentId'] as int?,
      questions: _ivwnx0wz.Protocol()
          .deserialize<List<_i8fxap8r.ExerciseQuestionInput>>(
            jsonSerialization['questions'],
          ),
    );
  }

  int? contentId;

  int classId;

  String title;

  String subject;

  int gradeLevel;

  int? lessonContentId;

  List<_i8fxap8r.ExerciseQuestionInput> questions;

  /// Returns a shallow copy of this [ExerciseUpsert]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ExerciseUpsert copyWith({
    int? contentId,
    int? classId,
    String? title,
    String? subject,
    int? gradeLevel,
    int? lessonContentId,
    List<_i8fxap8r.ExerciseQuestionInput>? questions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExerciseUpsert',
      if (contentId != null) 'contentId': contentId,
      'classId': classId,
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      if (lessonContentId != null) 'lessonContentId': lessonContentId,
      'questions': questions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExerciseUpsert',
      if (contentId != null) 'contentId': contentId,
      'classId': classId,
      'title': title,
      'subject': subject,
      'gradeLevel': gradeLevel,
      if (lessonContentId != null) 'lessonContentId': lessonContentId,
      'questions': questions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExerciseUpsertImpl extends ExerciseUpsert {
  _ExerciseUpsertImpl({
    int? contentId,
    required int classId,
    required String title,
    required String subject,
    required int gradeLevel,
    int? lessonContentId,
    required List<_i8fxap8r.ExerciseQuestionInput> questions,
  }) : super._(
         contentId: contentId,
         classId: classId,
         title: title,
         subject: subject,
         gradeLevel: gradeLevel,
         lessonContentId: lessonContentId,
         questions: questions,
       );

  /// Returns a shallow copy of this [ExerciseUpsert]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ExerciseUpsert copyWith({
    Object? contentId = _Undefined,
    int? classId,
    String? title,
    String? subject,
    int? gradeLevel,
    Object? lessonContentId = _Undefined,
    List<_i8fxap8r.ExerciseQuestionInput>? questions,
  }) {
    return ExerciseUpsert(
      contentId: contentId is int? ? contentId : this.contentId,
      classId: classId ?? this.classId,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      lessonContentId: lessonContentId is int?
          ? lessonContentId
          : this.lessonContentId,
      questions:
          questions ?? this.questions.map((e0) => e0.copyWith()).toList(),
    );
  }
}
