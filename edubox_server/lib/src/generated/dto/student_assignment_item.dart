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
import 'package:serverpod/serverpod.dart' as _is;
import '../enums/assignment_type.dart' as _ilbj7cyv;
import '../enums/student_assignment_state.dart' as _inta0hge;

abstract class StudentAssignmentItem
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StudentAssignmentItem._({
    required this.id,
    required this.classId,
    required this.className,
    required this.exerciseId,
    required this.contentId,
    required this.title,
    required this.subject,
    required this.type,
    this.dueAt,
    this.timeLimitSec,
    required this.state,
    this.score,
    this.maxScore,
    required this.late,
    this.submissionId,
    this.clientSubmissionId,
    this.lessonContentId,
    this.lessonTitle,
  });

  factory StudentAssignmentItem({
    required int id,
    required int classId,
    required String className,
    required int exerciseId,
    required int contentId,
    required String title,
    required String subject,
    required _ilbj7cyv.AssignmentType type,
    DateTime? dueAt,
    int? timeLimitSec,
    required _inta0hge.StudentAssignmentState state,
    double? score,
    double? maxScore,
    required bool late,
    int? submissionId,
    String? clientSubmissionId,
    int? lessonContentId,
    String? lessonTitle,
  }) = _StudentAssignmentItemImpl;

  factory StudentAssignmentItem.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return StudentAssignmentItem(
      id: jsonSerialization['id'] as int,
      classId: jsonSerialization['classId'] as int,
      className: jsonSerialization['className'] as String,
      exerciseId: jsonSerialization['exerciseId'] as int,
      contentId: jsonSerialization['contentId'] as int,
      title: jsonSerialization['title'] as String,
      subject: jsonSerialization['subject'] as String,
      type: _ilbj7cyv.AssignmentType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      timeLimitSec: jsonSerialization['timeLimitSec'] as int?,
      state: _inta0hge.StudentAssignmentState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      score: (jsonSerialization['score'] as num?)?.toDouble(),
      maxScore: (jsonSerialization['maxScore'] as num?)?.toDouble(),
      late: _is.BoolJsonExtension.fromJson(jsonSerialization['late']),
      submissionId: jsonSerialization['submissionId'] as int?,
      clientSubmissionId: jsonSerialization['clientSubmissionId'] as String?,
      lessonContentId: jsonSerialization['lessonContentId'] as int?,
      lessonTitle: jsonSerialization['lessonTitle'] as String?,
    );
  }

  int id;

  int classId;

  String className;

  int exerciseId;

  int contentId;

  String title;

  String subject;

  _ilbj7cyv.AssignmentType type;

  DateTime? dueAt;

  int? timeLimitSec;

  _inta0hge.StudentAssignmentState state;

  double? score;

  double? maxScore;

  bool late;

  int? submissionId;

  String? clientSubmissionId;

  int? lessonContentId;

  String? lessonTitle;

  /// Returns a shallow copy of this [StudentAssignmentItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StudentAssignmentItem copyWith({
    int? id,
    int? classId,
    String? className,
    int? exerciseId,
    int? contentId,
    String? title,
    String? subject,
    _ilbj7cyv.AssignmentType? type,
    DateTime? dueAt,
    int? timeLimitSec,
    _inta0hge.StudentAssignmentState? state,
    double? score,
    double? maxScore,
    bool? late,
    int? submissionId,
    String? clientSubmissionId,
    int? lessonContentId,
    String? lessonTitle,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentAssignmentItem',
      'id': id,
      'classId': classId,
      'className': className,
      'exerciseId': exerciseId,
      'contentId': contentId,
      'title': title,
      'subject': subject,
      'type': type.toJson(),
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (timeLimitSec != null) 'timeLimitSec': timeLimitSec,
      'state': state.toJson(),
      if (score != null) 'score': score,
      if (maxScore != null) 'maxScore': maxScore,
      'late': late,
      if (submissionId != null) 'submissionId': submissionId,
      if (clientSubmissionId != null) 'clientSubmissionId': clientSubmissionId,
      if (lessonContentId != null) 'lessonContentId': lessonContentId,
      if (lessonTitle != null) 'lessonTitle': lessonTitle,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentAssignmentItem',
      'id': id,
      'classId': classId,
      'className': className,
      'exerciseId': exerciseId,
      'contentId': contentId,
      'title': title,
      'subject': subject,
      'type': type.toJson(),
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (timeLimitSec != null) 'timeLimitSec': timeLimitSec,
      'state': state.toJson(),
      if (score != null) 'score': score,
      if (maxScore != null) 'maxScore': maxScore,
      'late': late,
      if (submissionId != null) 'submissionId': submissionId,
      if (clientSubmissionId != null) 'clientSubmissionId': clientSubmissionId,
      if (lessonContentId != null) 'lessonContentId': lessonContentId,
      if (lessonTitle != null) 'lessonTitle': lessonTitle,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentAssignmentItemImpl extends StudentAssignmentItem {
  _StudentAssignmentItemImpl({
    required int id,
    required int classId,
    required String className,
    required int exerciseId,
    required int contentId,
    required String title,
    required String subject,
    required _ilbj7cyv.AssignmentType type,
    DateTime? dueAt,
    int? timeLimitSec,
    required _inta0hge.StudentAssignmentState state,
    double? score,
    double? maxScore,
    required bool late,
    int? submissionId,
    String? clientSubmissionId,
    int? lessonContentId,
    String? lessonTitle,
  }) : super._(
         id: id,
         classId: classId,
         className: className,
         exerciseId: exerciseId,
         contentId: contentId,
         title: title,
         subject: subject,
         type: type,
         dueAt: dueAt,
         timeLimitSec: timeLimitSec,
         state: state,
         score: score,
         maxScore: maxScore,
         late: late,
         submissionId: submissionId,
         clientSubmissionId: clientSubmissionId,
         lessonContentId: lessonContentId,
         lessonTitle: lessonTitle,
       );

  /// Returns a shallow copy of this [StudentAssignmentItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StudentAssignmentItem copyWith({
    int? id,
    int? classId,
    String? className,
    int? exerciseId,
    int? contentId,
    String? title,
    String? subject,
    _ilbj7cyv.AssignmentType? type,
    Object? dueAt = _Undefined,
    Object? timeLimitSec = _Undefined,
    _inta0hge.StudentAssignmentState? state,
    Object? score = _Undefined,
    Object? maxScore = _Undefined,
    bool? late,
    Object? submissionId = _Undefined,
    Object? clientSubmissionId = _Undefined,
    Object? lessonContentId = _Undefined,
    Object? lessonTitle = _Undefined,
  }) {
    return StudentAssignmentItem(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      exerciseId: exerciseId ?? this.exerciseId,
      contentId: contentId ?? this.contentId,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      type: type ?? this.type,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      timeLimitSec: timeLimitSec is int? ? timeLimitSec : this.timeLimitSec,
      state: state ?? this.state,
      score: score is double? ? score : this.score,
      maxScore: maxScore is double? ? maxScore : this.maxScore,
      late: late ?? this.late,
      submissionId: submissionId is int? ? submissionId : this.submissionId,
      clientSubmissionId: clientSubmissionId is String?
          ? clientSubmissionId
          : this.clientSubmissionId,
      lessonContentId: lessonContentId is int?
          ? lessonContentId
          : this.lessonContentId,
      lessonTitle: lessonTitle is String? ? lessonTitle : this.lessonTitle,
    );
  }
}
