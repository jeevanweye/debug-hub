// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sheet_version_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SheetVersionInfo _$SheetVersionInfoFromJson(Map<String, dynamic> json) {
  return _SheetVersionInfo.fromJson(json);
}

/// @nodoc
mixin _$SheetVersionInfo {
  int? get index => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  int? get sheetId => throw _privateConstructorUsedError;

  /// Serializes this SheetVersionInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SheetVersionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SheetVersionInfoCopyWith<SheetVersionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SheetVersionInfoCopyWith<$Res> {
  factory $SheetVersionInfoCopyWith(
    SheetVersionInfo value,
    $Res Function(SheetVersionInfo) then,
  ) = _$SheetVersionInfoCopyWithImpl<$Res, SheetVersionInfo>;
  @useResult
  $Res call({int? index, String? title, int? sheetId});
}

/// @nodoc
class _$SheetVersionInfoCopyWithImpl<$Res, $Val extends SheetVersionInfo>
    implements $SheetVersionInfoCopyWith<$Res> {
  _$SheetVersionInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SheetVersionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = freezed,
    Object? title = freezed,
    Object? sheetId = freezed,
  }) {
    return _then(
      _value.copyWith(
            index: freezed == index
                ? _value.index
                : index // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            sheetId: freezed == sheetId
                ? _value.sheetId
                : sheetId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SheetVersionInfoImplCopyWith<$Res>
    implements $SheetVersionInfoCopyWith<$Res> {
  factory _$$SheetVersionInfoImplCopyWith(
    _$SheetVersionInfoImpl value,
    $Res Function(_$SheetVersionInfoImpl) then,
  ) = __$$SheetVersionInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? index, String? title, int? sheetId});
}

/// @nodoc
class __$$SheetVersionInfoImplCopyWithImpl<$Res>
    extends _$SheetVersionInfoCopyWithImpl<$Res, _$SheetVersionInfoImpl>
    implements _$$SheetVersionInfoImplCopyWith<$Res> {
  __$$SheetVersionInfoImplCopyWithImpl(
    _$SheetVersionInfoImpl _value,
    $Res Function(_$SheetVersionInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SheetVersionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = freezed,
    Object? title = freezed,
    Object? sheetId = freezed,
  }) {
    return _then(
      _$SheetVersionInfoImpl(
        index: freezed == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        sheetId: freezed == sheetId
            ? _value.sheetId
            : sheetId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SheetVersionInfoImpl implements _SheetVersionInfo {
  const _$SheetVersionInfoImpl({this.index, this.title, this.sheetId});

  factory _$SheetVersionInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SheetVersionInfoImplFromJson(json);

  @override
  final int? index;
  @override
  final String? title;
  @override
  final int? sheetId;

  @override
  String toString() {
    return 'SheetVersionInfo(index: $index, title: $title, sheetId: $sheetId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SheetVersionInfoImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.sheetId, sheetId) || other.sheetId == sheetId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, index, title, sheetId);

  /// Create a copy of SheetVersionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SheetVersionInfoImplCopyWith<_$SheetVersionInfoImpl> get copyWith =>
      __$$SheetVersionInfoImplCopyWithImpl<_$SheetVersionInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SheetVersionInfoImplToJson(this);
  }
}

abstract class _SheetVersionInfo implements SheetVersionInfo {
  const factory _SheetVersionInfo({
    final int? index,
    final String? title,
    final int? sheetId,
  }) = _$SheetVersionInfoImpl;

  factory _SheetVersionInfo.fromJson(Map<String, dynamic> json) =
      _$SheetVersionInfoImpl.fromJson;

  @override
  int? get index;
  @override
  String? get title;
  @override
  int? get sheetId;

  /// Create a copy of SheetVersionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SheetVersionInfoImplCopyWith<_$SheetVersionInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
