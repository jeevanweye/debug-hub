// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MemorySnapshot _$MemorySnapshotFromJson(Map<String, dynamic> json) {
  return _MemorySnapshot.fromJson(json);
}

/// @nodoc
mixin _$MemorySnapshot {
  DateTime get timestamp => throw _privateConstructorUsedError; // App memory
  int get usedMemoryMB => throw _privateConstructorUsedError;
  int get freeMemoryMB => throw _privateConstructorUsedError;
  int get totalMemoryMB => throw _privateConstructorUsedError;
  double get usagePercentage => throw _privateConstructorUsedError;
  int get dartHeapMB => throw _privateConstructorUsedError;
  int get dartHeapCapacityMB => throw _privateConstructorUsedError;
  int get externalMemoryMB =>
      throw _privateConstructorUsedError; // Device memory (optional - may not be available on all platforms)
  int? get deviceTotalRAMMB => throw _privateConstructorUsedError;
  int? get deviceAvailableRAMMB => throw _privateConstructorUsedError;
  int? get deviceUsedRAMMB => throw _privateConstructorUsedError;
  double? get deviceMemoryUsagePercentage => throw _privateConstructorUsedError;

  /// Serializes this MemorySnapshot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemorySnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemorySnapshotCopyWith<MemorySnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemorySnapshotCopyWith<$Res> {
  factory $MemorySnapshotCopyWith(
          MemorySnapshot value, $Res Function(MemorySnapshot) then) =
      _$MemorySnapshotCopyWithImpl<$Res, MemorySnapshot>;
  @useResult
  $Res call(
      {DateTime timestamp,
      int usedMemoryMB,
      int freeMemoryMB,
      int totalMemoryMB,
      double usagePercentage,
      int dartHeapMB,
      int dartHeapCapacityMB,
      int externalMemoryMB,
      int? deviceTotalRAMMB,
      int? deviceAvailableRAMMB,
      int? deviceUsedRAMMB,
      double? deviceMemoryUsagePercentage});
}

/// @nodoc
class _$MemorySnapshotCopyWithImpl<$Res, $Val extends MemorySnapshot>
    implements $MemorySnapshotCopyWith<$Res> {
  _$MemorySnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemorySnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? usedMemoryMB = null,
    Object? freeMemoryMB = null,
    Object? totalMemoryMB = null,
    Object? usagePercentage = null,
    Object? dartHeapMB = null,
    Object? dartHeapCapacityMB = null,
    Object? externalMemoryMB = null,
    Object? deviceTotalRAMMB = freezed,
    Object? deviceAvailableRAMMB = freezed,
    Object? deviceUsedRAMMB = freezed,
    Object? deviceMemoryUsagePercentage = freezed,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usedMemoryMB: null == usedMemoryMB
          ? _value.usedMemoryMB
          : usedMemoryMB // ignore: cast_nullable_to_non_nullable
              as int,
      freeMemoryMB: null == freeMemoryMB
          ? _value.freeMemoryMB
          : freeMemoryMB // ignore: cast_nullable_to_non_nullable
              as int,
      totalMemoryMB: null == totalMemoryMB
          ? _value.totalMemoryMB
          : totalMemoryMB // ignore: cast_nullable_to_non_nullable
              as int,
      usagePercentage: null == usagePercentage
          ? _value.usagePercentage
          : usagePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      dartHeapMB: null == dartHeapMB
          ? _value.dartHeapMB
          : dartHeapMB // ignore: cast_nullable_to_non_nullable
              as int,
      dartHeapCapacityMB: null == dartHeapCapacityMB
          ? _value.dartHeapCapacityMB
          : dartHeapCapacityMB // ignore: cast_nullable_to_non_nullable
              as int,
      externalMemoryMB: null == externalMemoryMB
          ? _value.externalMemoryMB
          : externalMemoryMB // ignore: cast_nullable_to_non_nullable
              as int,
      deviceTotalRAMMB: freezed == deviceTotalRAMMB
          ? _value.deviceTotalRAMMB
          : deviceTotalRAMMB // ignore: cast_nullable_to_non_nullable
              as int?,
      deviceAvailableRAMMB: freezed == deviceAvailableRAMMB
          ? _value.deviceAvailableRAMMB
          : deviceAvailableRAMMB // ignore: cast_nullable_to_non_nullable
              as int?,
      deviceUsedRAMMB: freezed == deviceUsedRAMMB
          ? _value.deviceUsedRAMMB
          : deviceUsedRAMMB // ignore: cast_nullable_to_non_nullable
              as int?,
      deviceMemoryUsagePercentage: freezed == deviceMemoryUsagePercentage
          ? _value.deviceMemoryUsagePercentage
          : deviceMemoryUsagePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemorySnapshotImplCopyWith<$Res>
    implements $MemorySnapshotCopyWith<$Res> {
  factory _$$MemorySnapshotImplCopyWith(_$MemorySnapshotImpl value,
          $Res Function(_$MemorySnapshotImpl) then) =
      __$$MemorySnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp,
      int usedMemoryMB,
      int freeMemoryMB,
      int totalMemoryMB,
      double usagePercentage,
      int dartHeapMB,
      int dartHeapCapacityMB,
      int externalMemoryMB,
      int? deviceTotalRAMMB,
      int? deviceAvailableRAMMB,
      int? deviceUsedRAMMB,
      double? deviceMemoryUsagePercentage});
}

/// @nodoc
class __$$MemorySnapshotImplCopyWithImpl<$Res>
    extends _$MemorySnapshotCopyWithImpl<$Res, _$MemorySnapshotImpl>
    implements _$$MemorySnapshotImplCopyWith<$Res> {
  __$$MemorySnapshotImplCopyWithImpl(
      _$MemorySnapshotImpl _value, $Res Function(_$MemorySnapshotImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemorySnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? usedMemoryMB = null,
    Object? freeMemoryMB = null,
    Object? totalMemoryMB = null,
    Object? usagePercentage = null,
    Object? dartHeapMB = null,
    Object? dartHeapCapacityMB = null,
    Object? externalMemoryMB = null,
    Object? deviceTotalRAMMB = freezed,
    Object? deviceAvailableRAMMB = freezed,
    Object? deviceUsedRAMMB = freezed,
    Object? deviceMemoryUsagePercentage = freezed,
  }) {
    return _then(_$MemorySnapshotImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usedMemoryMB: null == usedMemoryMB
          ? _value.usedMemoryMB
          : usedMemoryMB // ignore: cast_nullable_to_non_nullable
              as int,
      freeMemoryMB: null == freeMemoryMB
          ? _value.freeMemoryMB
          : freeMemoryMB // ignore: cast_nullable_to_non_nullable
              as int,
      totalMemoryMB: null == totalMemoryMB
          ? _value.totalMemoryMB
          : totalMemoryMB // ignore: cast_nullable_to_non_nullable
              as int,
      usagePercentage: null == usagePercentage
          ? _value.usagePercentage
          : usagePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      dartHeapMB: null == dartHeapMB
          ? _value.dartHeapMB
          : dartHeapMB // ignore: cast_nullable_to_non_nullable
              as int,
      dartHeapCapacityMB: null == dartHeapCapacityMB
          ? _value.dartHeapCapacityMB
          : dartHeapCapacityMB // ignore: cast_nullable_to_non_nullable
              as int,
      externalMemoryMB: null == externalMemoryMB
          ? _value.externalMemoryMB
          : externalMemoryMB // ignore: cast_nullable_to_non_nullable
              as int,
      deviceTotalRAMMB: freezed == deviceTotalRAMMB
          ? _value.deviceTotalRAMMB
          : deviceTotalRAMMB // ignore: cast_nullable_to_non_nullable
              as int?,
      deviceAvailableRAMMB: freezed == deviceAvailableRAMMB
          ? _value.deviceAvailableRAMMB
          : deviceAvailableRAMMB // ignore: cast_nullable_to_non_nullable
              as int?,
      deviceUsedRAMMB: freezed == deviceUsedRAMMB
          ? _value.deviceUsedRAMMB
          : deviceUsedRAMMB // ignore: cast_nullable_to_non_nullable
              as int?,
      deviceMemoryUsagePercentage: freezed == deviceMemoryUsagePercentage
          ? _value.deviceMemoryUsagePercentage
          : deviceMemoryUsagePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemorySnapshotImpl implements _MemorySnapshot {
  const _$MemorySnapshotImpl(
      {required this.timestamp,
      required this.usedMemoryMB,
      required this.freeMemoryMB,
      required this.totalMemoryMB,
      required this.usagePercentage,
      required this.dartHeapMB,
      required this.dartHeapCapacityMB,
      required this.externalMemoryMB,
      this.deviceTotalRAMMB,
      this.deviceAvailableRAMMB,
      this.deviceUsedRAMMB,
      this.deviceMemoryUsagePercentage});

  factory _$MemorySnapshotImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemorySnapshotImplFromJson(json);

  @override
  final DateTime timestamp;
// App memory
  @override
  final int usedMemoryMB;
  @override
  final int freeMemoryMB;
  @override
  final int totalMemoryMB;
  @override
  final double usagePercentage;
  @override
  final int dartHeapMB;
  @override
  final int dartHeapCapacityMB;
  @override
  final int externalMemoryMB;
// Device memory (optional - may not be available on all platforms)
  @override
  final int? deviceTotalRAMMB;
  @override
  final int? deviceAvailableRAMMB;
  @override
  final int? deviceUsedRAMMB;
  @override
  final double? deviceMemoryUsagePercentage;

  @override
  String toString() {
    return 'MemorySnapshot(timestamp: $timestamp, usedMemoryMB: $usedMemoryMB, freeMemoryMB: $freeMemoryMB, totalMemoryMB: $totalMemoryMB, usagePercentage: $usagePercentage, dartHeapMB: $dartHeapMB, dartHeapCapacityMB: $dartHeapCapacityMB, externalMemoryMB: $externalMemoryMB, deviceTotalRAMMB: $deviceTotalRAMMB, deviceAvailableRAMMB: $deviceAvailableRAMMB, deviceUsedRAMMB: $deviceUsedRAMMB, deviceMemoryUsagePercentage: $deviceMemoryUsagePercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemorySnapshotImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.usedMemoryMB, usedMemoryMB) ||
                other.usedMemoryMB == usedMemoryMB) &&
            (identical(other.freeMemoryMB, freeMemoryMB) ||
                other.freeMemoryMB == freeMemoryMB) &&
            (identical(other.totalMemoryMB, totalMemoryMB) ||
                other.totalMemoryMB == totalMemoryMB) &&
            (identical(other.usagePercentage, usagePercentage) ||
                other.usagePercentage == usagePercentage) &&
            (identical(other.dartHeapMB, dartHeapMB) ||
                other.dartHeapMB == dartHeapMB) &&
            (identical(other.dartHeapCapacityMB, dartHeapCapacityMB) ||
                other.dartHeapCapacityMB == dartHeapCapacityMB) &&
            (identical(other.externalMemoryMB, externalMemoryMB) ||
                other.externalMemoryMB == externalMemoryMB) &&
            (identical(other.deviceTotalRAMMB, deviceTotalRAMMB) ||
                other.deviceTotalRAMMB == deviceTotalRAMMB) &&
            (identical(other.deviceAvailableRAMMB, deviceAvailableRAMMB) ||
                other.deviceAvailableRAMMB == deviceAvailableRAMMB) &&
            (identical(other.deviceUsedRAMMB, deviceUsedRAMMB) ||
                other.deviceUsedRAMMB == deviceUsedRAMMB) &&
            (identical(other.deviceMemoryUsagePercentage,
                    deviceMemoryUsagePercentage) ||
                other.deviceMemoryUsagePercentage ==
                    deviceMemoryUsagePercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      timestamp,
      usedMemoryMB,
      freeMemoryMB,
      totalMemoryMB,
      usagePercentage,
      dartHeapMB,
      dartHeapCapacityMB,
      externalMemoryMB,
      deviceTotalRAMMB,
      deviceAvailableRAMMB,
      deviceUsedRAMMB,
      deviceMemoryUsagePercentage);

  /// Create a copy of MemorySnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemorySnapshotImplCopyWith<_$MemorySnapshotImpl> get copyWith =>
      __$$MemorySnapshotImplCopyWithImpl<_$MemorySnapshotImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemorySnapshotImplToJson(
      this,
    );
  }
}

abstract class _MemorySnapshot implements MemorySnapshot {
  const factory _MemorySnapshot(
      {required final DateTime timestamp,
      required final int usedMemoryMB,
      required final int freeMemoryMB,
      required final int totalMemoryMB,
      required final double usagePercentage,
      required final int dartHeapMB,
      required final int dartHeapCapacityMB,
      required final int externalMemoryMB,
      final int? deviceTotalRAMMB,
      final int? deviceAvailableRAMMB,
      final int? deviceUsedRAMMB,
      final double? deviceMemoryUsagePercentage}) = _$MemorySnapshotImpl;

  factory _MemorySnapshot.fromJson(Map<String, dynamic> json) =
      _$MemorySnapshotImpl.fromJson;

  @override
  DateTime get timestamp; // App memory
  @override
  int get usedMemoryMB;
  @override
  int get freeMemoryMB;
  @override
  int get totalMemoryMB;
  @override
  double get usagePercentage;
  @override
  int get dartHeapMB;
  @override
  int get dartHeapCapacityMB;
  @override
  int get externalMemoryMB; // Device memory (optional - may not be available on all platforms)
  @override
  int? get deviceTotalRAMMB;
  @override
  int? get deviceAvailableRAMMB;
  @override
  int? get deviceUsedRAMMB;
  @override
  double? get deviceMemoryUsagePercentage;

  /// Create a copy of MemorySnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemorySnapshotImplCopyWith<_$MemorySnapshotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
