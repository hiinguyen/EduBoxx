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
import '../dto/tutor_subject.dart' as _ilsqcaq1;

abstract class TutorState
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TutorState._({
    required this.subjects,
    required this.usedToday,
    required this.dailyLimit,
    required this.remainingToday,
    required this.pausedForTest,
    this.activeTestAssignmentId,
  });

  factory TutorState({
    required List<_ilsqcaq1.TutorSubject> subjects,
    required int usedToday,
    required int dailyLimit,
    required int remainingToday,
    required bool pausedForTest,
    int? activeTestAssignmentId,
  }) = _TutorStateImpl;

  factory TutorState.fromJson(Map<String, dynamic> jsonSerialization) {
    return TutorState(
      subjects: _ivwnx0wz.Protocol().deserialize<List<_ilsqcaq1.TutorSubject>>(
        jsonSerialization['subjects'],
      ),
      usedToday: jsonSerialization['usedToday'] as int,
      dailyLimit: jsonSerialization['dailyLimit'] as int,
      remainingToday: jsonSerialization['remainingToday'] as int,
      pausedForTest: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['pausedForTest'],
      ),
      activeTestAssignmentId:
          jsonSerialization['activeTestAssignmentId'] as int?,
    );
  }

  List<_ilsqcaq1.TutorSubject> subjects;

  int usedToday;

  int dailyLimit;

  int remainingToday;

  bool pausedForTest;

  int? activeTestAssignmentId;

  /// Returns a shallow copy of this [TutorState]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TutorState copyWith({
    List<_ilsqcaq1.TutorSubject>? subjects,
    int? usedToday,
    int? dailyLimit,
    int? remainingToday,
    bool? pausedForTest,
    int? activeTestAssignmentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TutorState',
      'subjects': subjects.toJson(valueToJson: (v) => v.toJson()),
      'usedToday': usedToday,
      'dailyLimit': dailyLimit,
      'remainingToday': remainingToday,
      'pausedForTest': pausedForTest,
      if (activeTestAssignmentId != null)
        'activeTestAssignmentId': activeTestAssignmentId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TutorState',
      'subjects': subjects.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'usedToday': usedToday,
      'dailyLimit': dailyLimit,
      'remainingToday': remainingToday,
      'pausedForTest': pausedForTest,
      if (activeTestAssignmentId != null)
        'activeTestAssignmentId': activeTestAssignmentId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TutorStateImpl extends TutorState {
  _TutorStateImpl({
    required List<_ilsqcaq1.TutorSubject> subjects,
    required int usedToday,
    required int dailyLimit,
    required int remainingToday,
    required bool pausedForTest,
    int? activeTestAssignmentId,
  }) : super._(
         subjects: subjects,
         usedToday: usedToday,
         dailyLimit: dailyLimit,
         remainingToday: remainingToday,
         pausedForTest: pausedForTest,
         activeTestAssignmentId: activeTestAssignmentId,
       );

  /// Returns a shallow copy of this [TutorState]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TutorState copyWith({
    List<_ilsqcaq1.TutorSubject>? subjects,
    int? usedToday,
    int? dailyLimit,
    int? remainingToday,
    bool? pausedForTest,
    Object? activeTestAssignmentId = _Undefined,
  }) {
    return TutorState(
      subjects: subjects ?? this.subjects.map((e0) => e0.copyWith()).toList(),
      usedToday: usedToday ?? this.usedToday,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      remainingToday: remainingToday ?? this.remainingToday,
      pausedForTest: pausedForTest ?? this.pausedForTest,
      activeTestAssignmentId: activeTestAssignmentId is int?
          ? activeTestAssignmentId
          : this.activeTestAssignmentId,
    );
  }
}
