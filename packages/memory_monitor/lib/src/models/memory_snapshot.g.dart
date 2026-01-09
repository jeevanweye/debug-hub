// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemorySnapshotImpl _$$MemorySnapshotImplFromJson(Map<String, dynamic> json) =>
    _$MemorySnapshotImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      usedMemoryMB: (json['usedMemoryMB'] as num).toInt(),
      freeMemoryMB: (json['freeMemoryMB'] as num).toInt(),
      totalMemoryMB: (json['totalMemoryMB'] as num).toInt(),
      usagePercentage: (json['usagePercentage'] as num).toDouble(),
      dartHeapMB: (json['dartHeapMB'] as num).toInt(),
      dartHeapCapacityMB: (json['dartHeapCapacityMB'] as num).toInt(),
      externalMemoryMB: (json['externalMemoryMB'] as num).toInt(),
      deviceTotalRAMMB: (json['deviceTotalRAMMB'] as num?)?.toInt(),
      deviceAvailableRAMMB: (json['deviceAvailableRAMMB'] as num?)?.toInt(),
      deviceUsedRAMMB: (json['deviceUsedRAMMB'] as num?)?.toInt(),
      deviceMemoryUsagePercentage:
          (json['deviceMemoryUsagePercentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$MemorySnapshotImplToJson(
        _$MemorySnapshotImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'usedMemoryMB': instance.usedMemoryMB,
      'freeMemoryMB': instance.freeMemoryMB,
      'totalMemoryMB': instance.totalMemoryMB,
      'usagePercentage': instance.usagePercentage,
      'dartHeapMB': instance.dartHeapMB,
      'dartHeapCapacityMB': instance.dartHeapCapacityMB,
      'externalMemoryMB': instance.externalMemoryMB,
      'deviceTotalRAMMB': instance.deviceTotalRAMMB,
      'deviceAvailableRAMMB': instance.deviceAvailableRAMMB,
      'deviceUsedRAMMB': instance.deviceUsedRAMMB,
      'deviceMemoryUsagePercentage': instance.deviceMemoryUsagePercentage,
    };
