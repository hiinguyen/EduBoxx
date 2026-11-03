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

abstract class StudentAssignmentList
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StudentAssignmentList._({required this.assignments});

  factory StudentAssignmentList({
    required List<_i0gwjrdv.StudentAssignmentItem> assignments,
  }) = _StudentAssignmentListImpl;

  factory StudentAssignmentList.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return StudentAssignmentList(
      assignments: _ivwnx0wz.Protocol()
          .deserialize<List<_i0gwjrdv.StudentAssignmentItem>>(
            jsonSerialization['assignments'],
          ),
    );
  }

  List<_i0gwjrdv.StudentAssignmentItem> assignments;

  /// Returns a shallow copy of this [StudentAssignmentList]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StudentAssignmentList copyWith({
    List<_i0gwjrdv.StudentAssignmentItem>? assignments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentAssignmentList',
      'assignments': assignments.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentAssignmentList',
      'assignments': assignments.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _StudentAssignmentListImpl extends StudentAssignmentList {
  _StudentAssignmentListImpl({
    required List<_i0gwjrdv.StudentAssignmentItem> assignments,
  }) : super._(assignments: assignments);

  /// Returns a shallow copy of this [StudentAssignmentList]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StudentAssignmentList copyWith({
    List<_i0gwjrdv.StudentAssignmentItem>? assignments,
  }) {
    return StudentAssignmentList(
      assignments:
          assignments ?? this.assignments.map((e0) => e0.copyWith()).toList(),
    );
  }
}
