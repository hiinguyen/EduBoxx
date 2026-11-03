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

abstract class TutorSubject
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TutorSubject._({
    required this.classId,
    required this.className,
    required this.subject,
    required this.gradeLevel,
  });

  factory TutorSubject({
    required int classId,
    required String className,
    required String subject,
    required int gradeLevel,
  }) = _TutorSubjectImpl;

  factory TutorSubject.fromJson(Map<String, dynamic> jsonSerialization) {
    return TutorSubject(
      classId: jsonSerialization['classId'] as int,
      className: jsonSerialization['className'] as String,
      subject: jsonSerialization['subject'] as String,
      gradeLevel: jsonSerialization['gradeLevel'] as int,
    );
  }

  int classId;

  String className;

  String subject;

  int gradeLevel;

  /// Returns a shallow copy of this [TutorSubject]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TutorSubject copyWith({
    int? classId,
    String? className,
    String? subject,
    int? gradeLevel,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TutorSubject',
      'classId': classId,
      'className': className,
      'subject': subject,
      'gradeLevel': gradeLevel,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TutorSubject',
      'classId': classId,
      'className': className,
      'subject': subject,
      'gradeLevel': gradeLevel,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TutorSubjectImpl extends TutorSubject {
  _TutorSubjectImpl({
    required int classId,
    required String className,
    required String subject,
    required int gradeLevel,
  }) : super._(
         classId: classId,
         className: className,
         subject: subject,
         gradeLevel: gradeLevel,
       );

  /// Returns a shallow copy of this [TutorSubject]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TutorSubject copyWith({
    int? classId,
    String? className,
    String? subject,
    int? gradeLevel,
  }) {
    return TutorSubject(
      classId: classId ?? this.classId,
      className: className ?? this.className,
      subject: subject ?? this.subject,
      gradeLevel: gradeLevel ?? this.gradeLevel,
    );
  }
}
