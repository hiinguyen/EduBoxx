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

abstract class ResultStudent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ResultStudent._({
    required this.id,
    required this.name,
  });

  factory ResultStudent({
    required int id,
    required String name,
  }) = _ResultStudentImpl;

  factory ResultStudent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResultStudent(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
    );
  }

  int id;

  String name;

  /// Returns a shallow copy of this [ResultStudent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ResultStudent copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResultStudent',
      'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResultStudent',
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ResultStudentImpl extends ResultStudent {
  _ResultStudentImpl({
    required int id,
    required String name,
  }) : super._(
         id: id,
         name: name,
       );

  /// Returns a shallow copy of this [ResultStudent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ResultStudent copyWith({
    int? id,
    String? name,
  }) {
    return ResultStudent(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
