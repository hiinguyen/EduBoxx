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

abstract class StudentOption
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StudentOption._({
    required this.id,
    required this.position,
    required this.text,
  });

  factory StudentOption({
    required int id,
    required int position,
    required String text,
  }) = _StudentOptionImpl;

  factory StudentOption.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentOption(
      id: jsonSerialization['id'] as int,
      position: jsonSerialization['position'] as int,
      text: jsonSerialization['text'] as String,
    );
  }

  int id;

  int position;

  String text;

  /// Returns a shallow copy of this [StudentOption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StudentOption copyWith({
    int? id,
    int? position,
    String? text,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentOption',
      'id': id,
      'position': position,
      'text': text,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentOption',
      'id': id,
      'position': position,
      'text': text,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _StudentOptionImpl extends StudentOption {
  _StudentOptionImpl({
    required int id,
    required int position,
    required String text,
  }) : super._(
         id: id,
         position: position,
         text: text,
       );

  /// Returns a shallow copy of this [StudentOption]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StudentOption copyWith({
    int? id,
    int? position,
    String? text,
  }) {
    return StudentOption(
      id: id ?? this.id,
      position: position ?? this.position,
      text: text ?? this.text,
    );
  }
}
