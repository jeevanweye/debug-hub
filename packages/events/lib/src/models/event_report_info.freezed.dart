// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_report_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventReportInfo _$EventReportInfoFromJson(Map<String, dynamic> json) {
  return _EventReportInfo.fromJson(json);
}

/// @nodoc
mixin _$EventReportInfo {
  /// Event from Google Sheet
  SheetEventInfo? get sheetEvent => throw _privateConstructorUsedError;

  /// Event from device logs
  SheetEventInfo? get devEvent => throw _privateConstructorUsedError;

  /// Whether the event was found in device logs
  bool get isFound => throw _privateConstructorUsedError;

  /// Whether the event matches exactly
  bool get isCorrect => throw _privateConstructorUsedError;

  /// Serializes this EventReportInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventReportInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventReportInfoCopyWith<EventReportInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventReportInfoCopyWith<$Res> {
  factory $EventReportInfoCopyWith(
    EventReportInfo value,
    $Res Function(EventReportInfo) then,
  ) = _$EventReportInfoCopyWithImpl<$Res, EventReportInfo>;
  @useResult
  $Res call({
    SheetEventInfo? sheetEvent,
    SheetEventInfo? devEvent,
    bool isFound,
    bool isCorrect,
  });

  $SheetEventInfoCopyWith<$Res>? get sheetEvent;
  $SheetEventInfoCopyWith<$Res>? get devEvent;
}

/// @nodoc
class _$EventReportInfoCopyWithImpl<$Res, $Val extends EventReportInfo>
    implements $EventReportInfoCopyWith<$Res> {
  _$EventReportInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventReportInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sheetEvent = freezed,
    Object? devEvent = freezed,
    Object? isFound = null,
    Object? isCorrect = null,
  }) {
    return _then(
      _value.copyWith(
            sheetEvent: freezed == sheetEvent
                ? _value.sheetEvent
                : sheetEvent // ignore: cast_nullable_to_non_nullable
                      as SheetEventInfo?,
            devEvent: freezed == devEvent
                ? _value.devEvent
                : devEvent // ignore: cast_nullable_to_non_nullable
                      as SheetEventInfo?,
            isFound: null == isFound
                ? _value.isFound
                : isFound // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCorrect: null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of EventReportInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SheetEventInfoCopyWith<$Res>? get sheetEvent {
    if (_value.sheetEvent == null) {
      return null;
    }

    return $SheetEventInfoCopyWith<$Res>(_value.sheetEvent!, (value) {
      return _then(_value.copyWith(sheetEvent: value) as $Val);
    });
  }

  /// Create a copy of EventReportInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SheetEventInfoCopyWith<$Res>? get devEvent {
    if (_value.devEvent == null) {
      return null;
    }

    return $SheetEventInfoCopyWith<$Res>(_value.devEvent!, (value) {
      return _then(_value.copyWith(devEvent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventReportInfoImplCopyWith<$Res>
    implements $EventReportInfoCopyWith<$Res> {
  factory _$$EventReportInfoImplCopyWith(
    _$EventReportInfoImpl value,
    $Res Function(_$EventReportInfoImpl) then,
  ) = __$$EventReportInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SheetEventInfo? sheetEvent,
    SheetEventInfo? devEvent,
    bool isFound,
    bool isCorrect,
  });

  @override
  $SheetEventInfoCopyWith<$Res>? get sheetEvent;
  @override
  $SheetEventInfoCopyWith<$Res>? get devEvent;
}

/// @nodoc
class __$$EventReportInfoImplCopyWithImpl<$Res>
    extends _$EventReportInfoCopyWithImpl<$Res, _$EventReportInfoImpl>
    implements _$$EventReportInfoImplCopyWith<$Res> {
  __$$EventReportInfoImplCopyWithImpl(
    _$EventReportInfoImpl _value,
    $Res Function(_$EventReportInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventReportInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sheetEvent = freezed,
    Object? devEvent = freezed,
    Object? isFound = null,
    Object? isCorrect = null,
  }) {
    return _then(
      _$EventReportInfoImpl(
        sheetEvent: freezed == sheetEvent
            ? _value.sheetEvent
            : sheetEvent // ignore: cast_nullable_to_non_nullable
                  as SheetEventInfo?,
        devEvent: freezed == devEvent
            ? _value.devEvent
            : devEvent // ignore: cast_nullable_to_non_nullable
                  as SheetEventInfo?,
        isFound: null == isFound
            ? _value.isFound
            : isFound // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCorrect: null == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventReportInfoImpl implements _EventReportInfo {
  const _$EventReportInfoImpl({
    this.sheetEvent,
    this.devEvent,
    this.isFound = false,
    this.isCorrect = false,
  });

  factory _$EventReportInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventReportInfoImplFromJson(json);

  /// Event from Google Sheet
  @override
  final SheetEventInfo? sheetEvent;

  /// Event from device logs
  @override
  final SheetEventInfo? devEvent;

  /// Whether the event was found in device logs
  @override
  @JsonKey()
  final bool isFound;

  /// Whether the event matches exactly
  @override
  @JsonKey()
  final bool isCorrect;

  @override
  String toString() {
    return 'EventReportInfo(sheetEvent: $sheetEvent, devEvent: $devEvent, isFound: $isFound, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventReportInfoImpl &&
            (identical(other.sheetEvent, sheetEvent) ||
                other.sheetEvent == sheetEvent) &&
            (identical(other.devEvent, devEvent) ||
                other.devEvent == devEvent) &&
            (identical(other.isFound, isFound) || other.isFound == isFound) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, sheetEvent, devEvent, isFound, isCorrect);

  /// Create a copy of EventReportInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventReportInfoImplCopyWith<_$EventReportInfoImpl> get copyWith =>
      __$$EventReportInfoImplCopyWithImpl<_$EventReportInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EventReportInfoImplToJson(this);
  }
}

abstract class _EventReportInfo implements EventReportInfo {
  const factory _EventReportInfo({
    final SheetEventInfo? sheetEvent,
    final SheetEventInfo? devEvent,
    final bool isFound,
    final bool isCorrect,
  }) = _$EventReportInfoImpl;

  factory _EventReportInfo.fromJson(Map<String, dynamic> json) =
      _$EventReportInfoImpl.fromJson;

  /// Event from Google Sheet
  @override
  SheetEventInfo? get sheetEvent;

  /// Event from device logs
  @override
  SheetEventInfo? get devEvent;

  /// Whether the event was found in device logs
  @override
  bool get isFound;

  /// Whether the event matches exactly
  @override
  bool get isCorrect;

  /// Create a copy of EventReportInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventReportInfoImplCopyWith<_$EventReportInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
