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
import '../dto/student_assignment_item.dart' as _i0gwjrdv;
import '../dto/student_exercise_detail.dart' as _ilhuf5v6;

abstract class StudentAssignmentDetail
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StudentAssignmentDetail._({
    required this.assignment,
    required this.exercise,
    required this.lessonCompleted,
  });

  factory StudentAssignmentDetail({
    required _i0gwjrdv.StudentAssignmentItem assignment,
    required _ilhuf5v6.StudentExerciseDetail exercise,
    required bool lessonCompleted,
  }) = _StudentAssignmentDetailImpl;

  factory StudentAssignmentDetail.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return StudentAssignmentDetail(
      assignment: _ivwnx0wz.Protocol()
          .deserialize<_i0gwjrdv.StudentAssignmentItem>(
            jsonSerialization['assignment'],
          ),
      exercise: _ivwnx0wz.Protocol()
          .deserialize<_ilhuf5v6.StudentExerciseDetail>(
            jsonSerialization['exercise'],
          ),
      lessonCompleted: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['lessonCompleted'],
      ),
    );
  }

  _i0gwjrdv.StudentAssignmentItem assignment;

  _ilhuf5v6.StudentExerciseDetail exercise;

  bool lessonCompleted;

  /// Returns a shallow copy of this [StudentAssignmentDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StudentAssignmentDetail copyWith({
    _i0gwjrdv.StudentAssignmentItem? assignment,
    _ilhuf5v6.StudentExerciseDetail? exercise,
    bool? lessonCompleted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentAssignmentDetail',
      'assignment': assignment.toJson(),
      'exercise': exercise.toJson(),
      'lessonCompleted': lessonCompleted,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentAssignmentDetail',
      'assignment': assignment.toJsonForProtocol(),
      'exercise': exercise.toJsonForProtocol(),
      'lessonCompleted': lessonCompleted,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _StudentAssignmentDetailImpl extends StudentAssignmentDetail {
  _StudentAssignmentDetailImpl({
    required _i0gwjrdv.StudentAssignmentItem assignment,
    required _ilhuf5v6.StudentExerciseDetail exercise,
    required bool lessonCompleted,
  }) : super._(
         assignment: assignment,
         exercise: exercise,
         lessonCompleted: lessonCompleted,
       );

  /// Returns a shallow copy of this [StudentAssignmentDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StudentAssignmentDetail copyWith({
    _i0gwjrdv.StudentAssignmentItem? assignment,
    _ilhuf5v6.StudentExerciseDetail? exercise,
    bool? lessonCompleted,
  }) {
    return StudentAssignmentDetail(
      assignment: assignment ?? this.assignment.copyWith(),
      exercise: exercise ?? this.exercise.copyWith(),
      lessonCompleted: lessonCompleted ?? this.lessonCompleted,
    );
  }
}
