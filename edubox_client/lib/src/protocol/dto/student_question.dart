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
import '../dto/student_option.dart' as _iaqc36fg;

abstract class StudentQuestion
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StudentQuestion._({
    required this.id,
    required this.position,
    required this.stem,
    required this.multiSelect,
    this.imageUrl,
    required this.options,
  });

  factory StudentQuestion({
    required int id,
    required int position,
    required String stem,
    required bool multiSelect,
    String? imageUrl,
    required List<_iaqc36fg.StudentOption> options,
  }) = _StudentQuestionImpl;

  factory StudentQuestion.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentQuestion(
      id: jsonSerialization['id'] as int,
      position: jsonSerialization['position'] as int,
      stem: jsonSerialization['stem'] as String,
      multiSelect: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['multiSelect'],
      ),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      options: _ivwnx0wz.Protocol().deserialize<List<_iaqc36fg.StudentOption>>(
        jsonSerialization['options'],
      ),
    );
  }

  int id;

  int position;

  String stem;

  bool multiSelect;

  String? imageUrl;

  List<_iaqc36fg.StudentOption> options;

  /// Returns a shallow copy of this [StudentQuestion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StudentQuestion copyWith({
    int? id,
    int? position,
    String? stem,
    bool? multiSelect,
    String? imageUrl,
    List<_iaqc36fg.StudentOption>? options,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentQuestion',
      'id': id,
      'position': position,
      'stem': stem,
      'multiSelect': multiSelect,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'options': options.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentQuestion',
      'id': id,
      'position': position,
      'stem': stem,
      'multiSelect': multiSelect,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'options': options.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentQuestionImpl extends StudentQuestion {
  _StudentQuestionImpl({
    required int id,
    required int position,
    required String stem,
    required bool multiSelect,
    String? imageUrl,
    required List<_iaqc36fg.StudentOption> options,
  }) : super._(
         id: id,
         position: position,
         stem: stem,
         multiSelect: multiSelect,
         imageUrl: imageUrl,
         options: options,
       );

  /// Returns a shallow copy of this [StudentQuestion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StudentQuestion copyWith({
    int? id,
    int? position,
    String? stem,
    bool? multiSelect,
    Object? imageUrl = _Undefined,
    List<_iaqc36fg.StudentOption>? options,
  }) {
    return StudentQuestion(
      id: id ?? this.id,
      position: position ?? this.position,
      stem: stem ?? this.stem,
      multiSelect: multiSelect ?? this.multiSelect,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      options: options ?? this.options.map((e0) => e0.copyWith()).toList(),
    );
  }
}
