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
import '../enums/tutor_error_code.dart' as _i8p86l0y;
import '../enums/tutor_event_type.dart' as _igd3hu26;

abstract class TutorEvent
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TutorEvent._({
    required this.type,
    this.chatId,
    this.delta,
    this.errorCode,
    this.messageId,
  });

  factory TutorEvent({
    required _igd3hu26.TutorEventType type,
    int? chatId,
    String? delta,
    _i8p86l0y.TutorErrorCode? errorCode,
    int? messageId,
  }) = _TutorEventImpl;

  factory TutorEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return TutorEvent(
      type: _igd3hu26.TutorEventType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      chatId: jsonSerialization['chatId'] as int?,
      delta: jsonSerialization['delta'] as String?,
      errorCode: jsonSerialization['errorCode'] == null
          ? null
          : _i8p86l0y.TutorErrorCode.fromJson(
              (jsonSerialization['errorCode'] as String),
            ),
      messageId: jsonSerialization['messageId'] as int?,
    );
  }

  _igd3hu26.TutorEventType type;

  int? chatId;

  String? delta;

  _i8p86l0y.TutorErrorCode? errorCode;

  int? messageId;

  /// Returns a shallow copy of this [TutorEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TutorEvent copyWith({
    _igd3hu26.TutorEventType? type,
    int? chatId,
    String? delta,
    _i8p86l0y.TutorErrorCode? errorCode,
    int? messageId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TutorEvent',
      'type': type.toJson(),
      if (chatId != null) 'chatId': chatId,
      if (delta != null) 'delta': delta,
      if (errorCode != null) 'errorCode': errorCode?.toJson(),
      if (messageId != null) 'messageId': messageId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TutorEvent',
      'type': type.toJson(),
      if (chatId != null) 'chatId': chatId,
      if (delta != null) 'delta': delta,
      if (errorCode != null) 'errorCode': errorCode?.toJson(),
      if (messageId != null) 'messageId': messageId,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TutorEventImpl extends TutorEvent {
  _TutorEventImpl({
    required _igd3hu26.TutorEventType type,
    int? chatId,
    String? delta,
    _i8p86l0y.TutorErrorCode? errorCode,
    int? messageId,
  }) : super._(
         type: type,
         chatId: chatId,
         delta: delta,
         errorCode: errorCode,
         messageId: messageId,
       );

  /// Returns a shallow copy of this [TutorEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TutorEvent copyWith({
    _igd3hu26.TutorEventType? type,
    Object? chatId = _Undefined,
    Object? delta = _Undefined,
    Object? errorCode = _Undefined,
    Object? messageId = _Undefined,
  }) {
    return TutorEvent(
      type: type ?? this.type,
      chatId: chatId is int? ? chatId : this.chatId,
      delta: delta is String? ? delta : this.delta,
      errorCode: errorCode is _i8p86l0y.TutorErrorCode?
          ? errorCode
          : this.errorCode,
      messageId: messageId is int? ? messageId : this.messageId,
    );
  }
}
