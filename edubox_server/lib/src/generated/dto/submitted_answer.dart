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

abstract class SubmittedAnswer
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SubmittedAnswer._({
    required this.questionId,
    required this.selectedPositions,
  });

  factory SubmittedAnswer({
    required int questionId,
    required List<int> selectedPositions,
  }) = _SubmittedAnswerImpl;

  factory SubmittedAnswer.fromJson(Map<String, dynamic> jsonSerialization) {
    return SubmittedAnswer(
      questionId: jsonSerialization['questionId'] as int,
      selectedPositions: _is7bdeiu.Protocol().deserialize<List<int>>(
        jsonSerialization['selectedPositions'],
      ),
    );
  }

  int questionId;

  List<int> selectedPositions;

  /// Returns a shallow copy of this [SubmittedAnswer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SubmittedAnswer copyWith({
    int? questionId,
    List<int>? selectedPositions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubmittedAnswer',
      'questionId': questionId,
      'selectedPositions': selectedPositions.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SubmittedAnswer',
      'questionId': questionId,
      'selectedPositions': selectedPositions.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SubmittedAnswerImpl extends SubmittedAnswer {
  _SubmittedAnswerImpl({
    required int questionId,
    required List<int> selectedPositions,
  }) : super._(
         questionId: questionId,
         selectedPositions: selectedPositions,
       );

  /// Returns a shallow copy of this [SubmittedAnswer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SubmittedAnswer copyWith({
    int? questionId,
    List<int>? selectedPositions,
  }) {
    return SubmittedAnswer(
      questionId: questionId ?? this.questionId,
      selectedPositions:
          selectedPositions ?? this.selectedPositions.map((e0) => e0).toList(),
    );
  }
}
