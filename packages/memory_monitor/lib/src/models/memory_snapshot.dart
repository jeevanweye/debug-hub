import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_snapshot.freezed.dart';
part 'memory_snapshot.g.dart';

/// Memory snapshot at a point in time
@freezed
class MemorySnapshot with _$MemorySnapshot {
  const factory MemorySnapshot({
    required DateTime timestamp,
    // App memory
    required int usedMemoryMB,
    required int freeMemoryMB,
    required int totalMemoryMB,
    required double usagePercentage,
    required int dartHeapMB,
    required int dartHeapCapacityMB,
    required int externalMemoryMB,
    // Device memory (optional - may not be available on all platforms)
    int? deviceTotalRAMMB,
    int? deviceAvailableRAMMB,
    int? deviceUsedRAMMB,
    double? deviceMemoryUsagePercentage,
  }) = _MemorySnapshot;

  factory MemorySnapshot.fromJson(Map<String, dynamic> json) =>
      _$MemorySnapshotFromJson(json);
}

/// Memory statistics over a period
class MemoryStatistics {
  final double averageUsageMB;
  final double peakUsageMB;
  final double minUsageMB;
  final double averagePercentage;
  final List<MemorySnapshot> snapshots;

  MemoryStatistics({
    required this.averageUsageMB,
    required this.peakUsageMB,
    required this.minUsageMB,
    required this.averagePercentage,
    required this.snapshots,
  });

  factory MemoryStatistics.fromSnapshots(List<MemorySnapshot> snapshots) {
    if (snapshots.isEmpty) {
      return MemoryStatistics(
        averageUsageMB: 0,
        peakUsageMB: 0,
        minUsageMB: 0,
        averagePercentage: 0,
        snapshots: [],
      );
    }

    final usages = snapshots.map((s) => s.usedMemoryMB.toDouble()).toList();
    final percentages = snapshots.map((s) => s.usagePercentage).toList();

    return MemoryStatistics(
      averageUsageMB: usages.reduce((a, b) => a + b) / usages.length,
      peakUsageMB: usages.reduce((a, b) => a > b ? a : b),
      minUsageMB: usages.reduce((a, b) => a < b ? a : b),
      averagePercentage: percentages.reduce((a, b) => a + b) / percentages.length,
      snapshots: snapshots,
    );
  }
}

