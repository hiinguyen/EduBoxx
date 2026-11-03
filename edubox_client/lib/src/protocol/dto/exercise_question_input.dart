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

abstract class ExerciseQuestionInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ExerciseQuestionInput._({
    this.id,
    required this.position,
    required this.stem,
    required this.multiSelect,
    this.imagePath,
    required this.options,
    required this.correctPositions,
  });

  factory ExerciseQuestionInput({
    int? id,
    required int position,
    required String stem,
    required bool multiSelect,
    String? imagePath,
    required List<String> options,
    required List<int> correctPositions,
  }) = _ExerciseQuestionInputImpl;

  factory ExerciseQuestionInput.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ExerciseQuestionInput(
      id: jsonSerialization['id'] as int?,
      position: jsonSerialization['position'] as int,
      stem: jsonSerialization['stem'] as String,
      multiSelect: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['multiSelect'],
      ),
      imagePath: jsonSerialization['imagePath'] as String?,
      options: _ivwnx0wz.Protocol().deserialize<List<String>>(
        jsonSerialization['options'],
      ),
      correctPositions: _ivwnx0wz.Protocol().deserialize<List<int>>(
        jsonSerialization['correctPositions'],
      ),
    );
  }

  int? id;

  int position;

  String stem;

  bool multiSelect;

  String? imagePath;

  List<String> options;

  List<int> correctPositions;

  /// Returns a shallow copy of this [ExerciseQuestionInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ExerciseQuestionInput copyWith({
    int? id,
    int? position,
    String? stem,
    bool? multiSelect,
    String? imagePath,
    List<String>? options,
    List<int>? correctPositions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExerciseQuestionInput',
      if (id != null) 'id': id,
      'position': position,
      'stem': stem,
      'multiSelect': multiSelect,
      if (imagePath != null) 'imagePath': imagePath,
      'options': options.toJson(),
      'correctPositions': correctPositions.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExerciseQuestionInput',
      if (id != null) 'id': id,
      'position': position,
      'stem': stem,
      'multiSelect': multiSelect,
      if (imagePath != null) 'imagePath': imagePath,
      'options': options.toJson(),
      'correctPositions': correctPositions.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExerciseQuestionInputImpl extends ExerciseQuestionInput {
  _ExerciseQuestionInputImpl({
    int? id,
    required int position,
    required String stem,
    required bool multiSelect,
    String? imagePath,
    required List<String> options,
    required List<int> correctPositions,
  }) : super._(
         id: id,
         position: position,
         stem: stem,
         multiSelect: multiSelect,
         imagePath: imagePath,
         options: options,
         correctPositions: correctPositions,
       );

  /// Returns a shallow copy of this [ExerciseQuestionInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ExerciseQuestionInput copyWith({
    Object? id = _Undefined,
    int? position,
    String? stem,
    bool? multiSelect,
    Object? imagePath = _Undefined,
    List<String>? options,
    List<int>? correctPositions,
  }) {
    return ExerciseQuestionInput(
      id: id is int? ? id : this.id,
      position: position ?? this.position,
      stem: stem ?? this.stem,
      multiSelect: multiSelect ?? this.multiSelect,
      imagePath: imagePath is String? ? imagePath : this.imagePath,
      options: options ?? this.options.map((e0) => e0).toList(),
      correctPositions:
          correctPositions ?? this.correctPositions.map((e0) => e0).toList(),
    );
  }
}
