// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'master_sheet_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MasterSheetInfo _$MasterSheetInfoFromJson(Map<String, dynamic> json) {
  return _MasterSheetInfo.fromJson(json);
}

/// @nodoc
mixin _$MasterSheetInfo {
  @JsonKey(name: 's_n')
  String? get serialNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'package_name')
  String? get packageName => throw _privateConstructorUsedError;
  @JsonKey(name: 'sheet_id')
  String? get sheetId => throw _privateConstructorUsedError;
  @JsonKey(name: 'range')
  String? get range => throw _privateConstructorUsedError;
  @JsonKey(name: 'field')
  String? get field => throw _privateConstructorUsedError;

  /// Serializes this MasterSheetInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MasterSheetInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MasterSheetInfoCopyWith<MasterSheetInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MasterSheetInfoCopyWith<$Res> {
  factory $MasterSheetInfoCopyWith(
    MasterSheetInfo value,
    $Res Function(MasterSheetInfo) then,
  ) = _$MasterSheetInfoCopyWithImpl<$Res, MasterSheetInfo>;
  @useResult
  $Res call({
    @JsonKey(name: 's_n') String? serialNumber,
    @JsonKey(name: 'package_name') String? packageName,
    @JsonKey(name: 'sheet_id') String? sheetId,
    @JsonKey(name: 'range') String? range,
    @JsonKey(name: 'field') String? field,
  });
}

/// @nodoc
class _$MasterSheetInfoCopyWithImpl<$Res, $Val extends MasterSheetInfo>
    implements $MasterSheetInfoCopyWith<$Res> {
  _$MasterSheetInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MasterSheetInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serialNumber = freezed,
    Object? packageName = freezed,
    Object? sheetId = freezed,
    Object? range = freezed,
    Object? field = freezed,
  }) {
    return _then(
      _value.copyWith(
            serialNumber: freezed == serialNumber
                ? _value.serialNumber
                : serialNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            packageName: freezed == packageName
                ? _value.packageName
                : packageName // ignore: cast_nullable_to_non_nullable
                      as String?,
            sheetId: freezed == sheetId
                ? _value.sheetId
                : sheetId // ignore: cast_nullable_to_non_nullable
                      as String?,
            range: freezed == range
                ? _value.range
                : range // ignore: cast_nullable_to_non_nullable
                      as String?,
            field: freezed == field
                ? _value.field
                : field // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MasterSheetInfoImplCopyWith<$Res>
    implements $MasterSheetInfoCopyWith<$Res> {
  factory _$$MasterSheetInfoImplCopyWith(
    _$MasterSheetInfoImpl value,
    $Res Function(_$MasterSheetInfoImpl) then,
  ) = __$$MasterSheetInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 's_n') String? serialNumber,
    @JsonKey(name: 'package_name') String? packageName,
    @JsonKey(name: 'sheet_id') String? sheetId,
    @JsonKey(name: 'range') String? range,
    @JsonKey(name: 'field') String? field,
  });
}

/// @nodoc
class __$$MasterSheetInfoImplCopyWithImpl<$Res>
    extends _$MasterSheetInfoCopyWithImpl<$Res, _$MasterSheetInfoImpl>
    implements _$$MasterSheetInfoImplCopyWith<$Res> {
  __$$MasterSheetInfoImplCopyWithImpl(
    _$MasterSheetInfoImpl _value,
    $Res Function(_$MasterSheetInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MasterSheetInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serialNumber = freezed,
    Object? packageName = freezed,
    Object? sheetId = freezed,
    Object? range = freezed,
    Object? field = freezed,
  }) {
    return _then(
      _$MasterSheetInfoImpl(
        serialNumber: freezed == serialNumber
            ? _value.serialNumber
            : serialNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        packageName: freezed == packageName
            ? _value.packageName
            : packageName // ignore: cast_nullable_to_non_nullable
                  as String?,
        sheetId: freezed == sheetId
            ? _value.sheetId
            : sheetId // ignore: cast_nullable_to_non_nullable
                  as String?,
        range: freezed == range
            ? _value.range
            : range // ignore: cast_nullable_to_non_nullable
                  as String?,
        field: freezed == field
            ? _value.field
            : field // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MasterSheetInfoImpl implements _MasterSheetInfo {
  const _$MasterSheetInfoImpl({
    @JsonKey(name: 's_n') this.serialNumber,
    @JsonKey(name: 'package_name') this.packageName,
    @JsonKey(name: 'sheet_id') this.sheetId,
    @JsonKey(name: 'range') this.range,
    @JsonKey(name: 'field') this.field,
  });

  factory _$MasterSheetInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MasterSheetInfoImplFromJson(json);

  @override
  @JsonKey(name: 's_n')
  final String? serialNumber;
  @override
  @JsonKey(name: 'package_name')
  final String? packageName;
  @override
  @JsonKey(name: 'sheet_id')
  final String? sheetId;
  @override
  @JsonKey(name: 'range')
  final String? range;
  @override
  @JsonKey(name: 'field')
  final String? field;

  @override
  String toString() {
    return 'MasterSheetInfo(serialNumber: $serialNumber, packageName: $packageName, sheetId: $sheetId, range: $range, field: $field)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MasterSheetInfoImpl &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.sheetId, sheetId) || other.sheetId == sheetId) &&
            (identical(other.range, range) || other.range == range) &&
            (identical(other.field, field) || other.field == field));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    serialNumber,
    packageName,
    sheetId,
    range,
    field,
  );

  /// Create a copy of MasterSheetInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MasterSheetInfoImplCopyWith<_$MasterSheetInfoImpl> get copyWith =>
      __$$MasterSheetInfoImplCopyWithImpl<_$MasterSheetInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MasterSheetInfoImplToJson(this);
  }
}

abstract class _MasterSheetInfo implements MasterSheetInfo {
  const factory _MasterSheetInfo({
    @JsonKey(name: 's_n') final String? serialNumber,
    @JsonKey(name: 'package_name') final String? packageName,
    @JsonKey(name: 'sheet_id') final String? sheetId,
    @JsonKey(name: 'range') final String? range,
    @JsonKey(name: 'field') final String? field,
  }) = _$MasterSheetInfoImpl;

  factory _MasterSheetInfo.fromJson(Map<String, dynamic> json) =
      _$MasterSheetInfoImpl.fromJson;

  @override
  @JsonKey(name: 's_n')
  String? get serialNumber;
  @override
  @JsonKey(name: 'package_name')
  String? get packageName;
  @override
  @JsonKey(name: 'sheet_id')
  String? get sheetId;
  @override
  @JsonKey(name: 'range')
  String? get range;
  @override
  @JsonKey(name: 'field')
  String? get field;

  /// Create a copy of MasterSheetInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MasterSheetInfoImplCopyWith<_$MasterSheetInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
