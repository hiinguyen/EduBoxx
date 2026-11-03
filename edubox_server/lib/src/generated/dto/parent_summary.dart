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
import '../dto/parent_result_entry.dart' as _iaoi94cw;
import '../dto/tutor_chat_summary.dart' as _iziugfky;

abstract class ParentSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ParentSummary._({
    this.linkedStudentName,
    this.className,
    required this.results,
    required this.chats,
  });

  factory ParentSummary({
    String? linkedStudentName,
    String? className,
    required List<_iaoi94cw.ParentResultEntry> results,
    required List<_iziugfky.TutorChatSummary> chats,
  }) = _ParentSummaryImpl;

  factory ParentSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentSummary(
      linkedStudentName: jsonSerialization['linkedStudentName'] as String?,
      className: jsonSerialization['className'] as String?,
      results: _is7bdeiu.Protocol()
          .deserialize<List<_iaoi94cw.ParentResultEntry>>(
            jsonSerialization['results'],
          ),
      chats: _is7bdeiu.Protocol().deserialize<List<_iziugfky.TutorChatSummary>>(
        jsonSerialization['chats'],
      ),
    );
  }

  String? linkedStudentName;

  String? className;

  List<_iaoi94cw.ParentResultEntry> results;

  List<_iziugfky.TutorChatSummary> chats;

  /// Returns a shallow copy of this [ParentSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ParentSummary copyWith({
    String? linkedStudentName,
    String? className,
    List<_iaoi94cw.ParentResultEntry>? results,
    List<_iziugfky.TutorChatSummary>? chats,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ParentSummary',
      if (linkedStudentName != null) 'linkedStudentName': linkedStudentName,
      if (className != null) 'className': className,
      'results': results.toJson(valueToJson: (v) => v.toJson()),
      'chats': chats.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ParentSummary',
      if (linkedStudentName != null) 'linkedStudentName': linkedStudentName,
      if (className != null) 'className': className,
      'results': results.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'chats': chats.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ParentSummaryImpl extends ParentSummary {
  _ParentSummaryImpl({
    String? linkedStudentName,
    String? className,
    required List<_iaoi94cw.ParentResultEntry> results,
    required List<_iziugfky.TutorChatSummary> chats,
  }) : super._(
         linkedStudentName: linkedStudentName,
         className: className,
         results: results,
         chats: chats,
       );

  /// Returns a shallow copy of this [ParentSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ParentSummary copyWith({
    Object? linkedStudentName = _Undefined,
    Object? className = _Undefined,
    List<_iaoi94cw.ParentResultEntry>? results,
    List<_iziugfky.TutorChatSummary>? chats,
  }) {
    return ParentSummary(
      linkedStudentName: linkedStudentName is String?
          ? linkedStudentName
          : this.linkedStudentName,
      className: className is String? ? className : this.className,
      results: results ?? this.results.map((e0) => e0.copyWith()).toList(),
      chats: chats ?? this.chats.map((e0) => e0.copyWith()).toList(),
    );
  }
}
