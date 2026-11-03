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
import '../dto/result_assignment.dart' as _i7o4hoxp;
import '../dto/result_cell.dart' as _i8v72t20;
import '../dto/result_student.dart' as _i6148z1n;

abstract class ClassResults
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ClassResults._({
    required this.classId,
    required this.className,
    required this.students,
    required this.assignments,
    required this.cells,
  });

  factory ClassResults({
    required int classId,
    required String className,
    required List<_i6148z1n.ResultStudent> students,
    required List<_i7o4hoxp.ResultAssignment> assignments,
    required List<_i8v72t20.ResultCell> cells,
  }) = _ClassResultsImpl;

  factory ClassResults.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClassResults(
      classId: jsonSerialization['classId'] as int,
      className: jsonSerialization['className'] as String,
      students: _is7bdeiu.Protocol().deserialize<List<_i6148z1n.ResultStudent>>(
        jsonSerialization['students'],
      ),
      assignments: _is7bdeiu.Protocol()
          .deserialize<List<_i7o4hoxp.ResultAssignment>>(
            jsonSerialization['assignments'],
          ),
      cells: _is7bdeiu.Protocol().deserialize<List<_i8v72t20.ResultCell>>(
        jsonSerialization['cells'],
      ),
    );
  }

  int classId;

  String className;

  List<_i6148z1n.ResultStudent> students;

  List<_i7o4hoxp.ResultAssignment> assignments;

  List<_i8v72t20.ResultCell> cells;

  /// Returns a shallow copy of this [ClassResults]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ClassResults copyWith({
    int? classId,
    String? className,
    List<_i6148z1n.ResultStudent>? students,
    List<_i7o4hoxp.ResultAssignment>? assignments,
    List<_i8v72t20.ResultCell>? cells,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ClassResults',
      'classId': classId,
      'className': className,
      'students': students.toJson(valueToJson: (v) => v.toJson()),
      'assignments': assignments.toJson(valueToJson: (v) => v.toJson()),
      'cells': cells.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ClassResults',
      'classId': classId,
      'className': className,
      'students': students.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'assignments': assignments.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'cells': cells.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ClassResultsImpl extends ClassResults {
  _ClassResultsImpl({
    required int classId,
    required String className,
    required List<_i6148z1n.ResultStudent> students,
    required List<_i7o4hoxp.ResultAssignment> assignments,
    required List<_i8v72t20.ResultCell> cells,
  }) : super._(
         classId: classId,
         className: className,
         students: students,
         assignments: assignments,
         cells: cells,
       );

  /// Returns a shallow copy of this [ClassResults]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ClassResults copyWith({
    int? classId,
    String? className,
    List<_i6148z1n.ResultStudent>? students,
    List<_i7o4hoxp.ResultAssignment>? assignments,
    List<_i8v72t20.ResultCell>? cells,
  }) {
    return ClassResults(
      classId: classId ?? this.classId,
      className: className ?? this.className,
      students: students ?? this.students.map((e0) => e0.copyWith()).toList(),
      assignments:
          assignments ?? this.assignments.map((e0) => e0.copyWith()).toList(),
      cells: cells ?? this.cells.map((e0) => e0.copyWith()).toList(),
    );
  }
}
