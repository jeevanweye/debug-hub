// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sheet_event_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SheetEventInfo _$SheetEventInfoFromJson(Map<String, dynamic> json) {
  return _SheetEventInfo.fromJson(json);
}

/// @nodoc
mixin _$SheetEventInfo {
  @JsonKey(name: 'sn')
  String? get serialNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_name')
  String? get eventName => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_action')
  String? get eventAction => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_category')
  String? get eventCategory => throw _privateConstructorUsedError;
  @JsonKey(name: 'screen_name')
  String? get screenName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_id')
  String? get vehicleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity')
  String? get entity => throw _privateConstructorUsedError;
  @JsonKey(name: 'miscellaneous')
  String? get miscellaneous => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_product')
  String? get targetProduct => throw _privateConstructorUsedError;

  /// Serializes this SheetEventInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SheetEventInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SheetEventInfoCopyWith<SheetEventInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SheetEventInfoCopyWith<$Res> {
  factory $SheetEventInfoCopyWith(
    SheetEventInfo value,
    $Res Function(SheetEventInfo) then,
  ) = _$SheetEventInfoCopyWithImpl<$Res, SheetEventInfo>;
  @useResult
  $Res call({
    @JsonKey(name: 'sn') String? serialNumber,
    @JsonKey(name: 'event_name') String? eventName,
    @JsonKey(name: 'event_action') String? eventAction,
    @JsonKey(name: 'event_category') String? eventCategory,
    @JsonKey(name: 'screen_name') String? screenName,
    @JsonKey(name: 'vehicle_id') String? vehicleId,
    @JsonKey(name: 'entity') String? entity,
    @JsonKey(name: 'miscellaneous') String? miscellaneous,
    @JsonKey(name: 'target_product') String? targetProduct,
  });
}

/// @nodoc
class _$SheetEventInfoCopyWithImpl<$Res, $Val extends SheetEventInfo>
    implements $SheetEventInfoCopyWith<$Res> {
  _$SheetEventInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SheetEventInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serialNumber = freezed,
    Object? eventName = freezed,
    Object? eventAction = freezed,
    Object? eventCategory = freezed,
    Object? screenName = freezed,
    Object? vehicleId = freezed,
    Object? entity = freezed,
    Object? miscellaneous = freezed,
    Object? targetProduct = freezed,
  }) {
    return _then(
      _value.copyWith(
            serialNumber: freezed == serialNumber
                ? _value.serialNumber
                : serialNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventName: freezed == eventName
                ? _value.eventName
                : eventName // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventAction: freezed == eventAction
                ? _value.eventAction
                : eventAction // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventCategory: freezed == eventCategory
                ? _value.eventCategory
                : eventCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            screenName: freezed == screenName
                ? _value.screenName
                : screenName // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleId: freezed == vehicleId
                ? _value.vehicleId
                : vehicleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            entity: freezed == entity
                ? _value.entity
                : entity // ignore: cast_nullable_to_non_nullable
                      as String?,
            miscellaneous: freezed == miscellaneous
                ? _value.miscellaneous
                : miscellaneous // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetProduct: freezed == targetProduct
                ? _value.targetProduct
                : targetProduct // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SheetEventInfoImplCopyWith<$Res>
    implements $SheetEventInfoCopyWith<$Res> {
  factory _$$SheetEventInfoImplCopyWith(
    _$SheetEventInfoImpl value,
    $Res Function(_$SheetEventInfoImpl) then,
  ) = __$$SheetEventInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'sn') String? serialNumber,
    @JsonKey(name: 'event_name') String? eventName,
    @JsonKey(name: 'event_action') String? eventAction,
    @JsonKey(name: 'event_category') String? eventCategory,
    @JsonKey(name: 'screen_name') String? screenName,
    @JsonKey(name: 'vehicle_id') String? vehicleId,
    @JsonKey(name: 'entity') String? entity,
    @JsonKey(name: 'miscellaneous') String? miscellaneous,
    @JsonKey(name: 'target_product') String? targetProduct,
  });
}

/// @nodoc
class __$$SheetEventInfoImplCopyWithImpl<$Res>
    extends _$SheetEventInfoCopyWithImpl<$Res, _$SheetEventInfoImpl>
    implements _$$SheetEventInfoImplCopyWith<$Res> {
  __$$SheetEventInfoImplCopyWithImpl(
    _$SheetEventInfoImpl _value,
    $Res Function(_$SheetEventInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SheetEventInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serialNumber = freezed,
    Object? eventName = freezed,
    Object? eventAction = freezed,
    Object? eventCategory = freezed,
    Object? screenName = freezed,
    Object? vehicleId = freezed,
    Object? entity = freezed,
    Object? miscellaneous = freezed,
    Object? targetProduct = freezed,
  }) {
    return _then(
      _$SheetEventInfoImpl(
        serialNumber: freezed == serialNumber
            ? _value.serialNumber
            : serialNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventName: freezed == eventName
            ? _value.eventName
            : eventName // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventAction: freezed == eventAction
            ? _value.eventAction
            : eventAction // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventCategory: freezed == eventCategory
            ? _value.eventCategory
            : eventCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        screenName: freezed == screenName
            ? _value.screenName
            : screenName // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleId: freezed == vehicleId
            ? _value.vehicleId
            : vehicleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        entity: freezed == entity
            ? _value.entity
            : entity // ignore: cast_nullable_to_non_nullable
                  as String?,
        miscellaneous: freezed == miscellaneous
            ? _value.miscellaneous
            : miscellaneous // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetProduct: freezed == targetProduct
            ? _value.targetProduct
            : targetProduct // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SheetEventInfoImpl implements _SheetEventInfo {
  const _$SheetEventInfoImpl({
    @JsonKey(name: 'sn') this.serialNumber,
    @JsonKey(name: 'event_name') this.eventName,
    @JsonKey(name: 'event_action') this.eventAction,
    @JsonKey(name: 'event_category') this.eventCategory,
    @JsonKey(name: 'screen_name') this.screenName,
    @JsonKey(name: 'vehicle_id') this.vehicleId,
    @JsonKey(name: 'entity') this.entity,
    @JsonKey(name: 'miscellaneous') this.miscellaneous,
    @JsonKey(name: 'target_product') this.targetProduct,
  });

  factory _$SheetEventInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SheetEventInfoImplFromJson(json);

  @override
  @JsonKey(name: 'sn')
  final String? serialNumber;
  @override
  @JsonKey(name: 'event_name')
  final String? eventName;
  @override
  @JsonKey(name: 'event_action')
  final String? eventAction;
  @override
  @JsonKey(name: 'event_category')
  final String? eventCategory;
  @override
  @JsonKey(name: 'screen_name')
  final String? screenName;
  @override
  @JsonKey(name: 'vehicle_id')
  final String? vehicleId;
  @override
  @JsonKey(name: 'entity')
  final String? entity;
  @override
  @JsonKey(name: 'miscellaneous')
  final String? miscellaneous;
  @override
  @JsonKey(name: 'target_product')
  final String? targetProduct;

  @override
  String toString() {
    return 'SheetEventInfo(serialNumber: $serialNumber, eventName: $eventName, eventAction: $eventAction, eventCategory: $eventCategory, screenName: $screenName, vehicleId: $vehicleId, entity: $entity, miscellaneous: $miscellaneous, targetProduct: $targetProduct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SheetEventInfoImpl &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.eventAction, eventAction) ||
                other.eventAction == eventAction) &&
            (identical(other.eventCategory, eventCategory) ||
                other.eventCategory == eventCategory) &&
            (identical(other.screenName, screenName) ||
                other.screenName == screenName) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.entity, entity) || other.entity == entity) &&
            (identical(other.miscellaneous, miscellaneous) ||
                other.miscellaneous == miscellaneous) &&
            (identical(other.targetProduct, targetProduct) ||
                other.targetProduct == targetProduct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    serialNumber,
    eventName,
    eventAction,
    eventCategory,
    screenName,
    vehicleId,
    entity,
    miscellaneous,
    targetProduct,
  );

  /// Create a copy of SheetEventInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SheetEventInfoImplCopyWith<_$SheetEventInfoImpl> get copyWith =>
      __$$SheetEventInfoImplCopyWithImpl<_$SheetEventInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SheetEventInfoImplToJson(this);
  }
}

abstract class _SheetEventInfo implements SheetEventInfo {
  const factory _SheetEventInfo({
    @JsonKey(name: 'sn') final String? serialNumber,
    @JsonKey(name: 'event_name') final String? eventName,
    @JsonKey(name: 'event_action') final String? eventAction,
    @JsonKey(name: 'event_category') final String? eventCategory,
    @JsonKey(name: 'screen_name') final String? screenName,
    @JsonKey(name: 'vehicle_id') final String? vehicleId,
    @JsonKey(name: 'entity') final String? entity,
    @JsonKey(name: 'miscellaneous') final String? miscellaneous,
    @JsonKey(name: 'target_product') final String? targetProduct,
  }) = _$SheetEventInfoImpl;

  factory _SheetEventInfo.fromJson(Map<String, dynamic> json) =
      _$SheetEventInfoImpl.fromJson;

  @override
  @JsonKey(name: 'sn')
  String? get serialNumber;
  @override
  @JsonKey(name: 'event_name')
  String? get eventName;
  @override
  @JsonKey(name: 'event_action')
  String? get eventAction;
  @override
  @JsonKey(name: 'event_category')
  String? get eventCategory;
  @override
  @JsonKey(name: 'screen_name')
  String? get screenName;
  @override
  @JsonKey(name: 'vehicle_id')
  String? get vehicleId;
  @override
  @JsonKey(name: 'entity')
  String? get entity;
  @override
  @JsonKey(name: 'miscellaneous')
  String? get miscellaneous;
  @override
  @JsonKey(name: 'target_product')
  String? get targetProduct;

  /// Create a copy of SheetEventInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SheetEventInfoImplCopyWith<_$SheetEventInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
