import 'package:flutter/foundation.dart';
import 'device_memory_channel.dart';

/// Platform-specific device memory information
class DeviceMemoryInfo {
  final int? totalRAMMB;
  final int? availableRAMMB;
  final int? usedRAMMB;
  final double? usagePercentage;

  DeviceMemoryInfo({
    this.totalRAMMB,
    this.availableRAMMB,
    this.usedRAMMB,
    this.usagePercentage,
  });

  static Future<DeviceMemoryInfo> getDeviceMemory() async {
    try {
      // Use platform channel to get device memory
      final memoryData = await DeviceMemoryChannel.getDeviceMemory();
      
      if (memoryData == null) {
        return DeviceMemoryInfo();
      }

      final totalRAM = memoryData['totalRAMMB'] as int?;
      final availableRAM = memoryData['availableRAMMB'] as int?;
      final usedRAM = memoryData['usedRAMMB'] as int?;
      final usagePercent = memoryData['usagePercentage'] as double?;

      return DeviceMemoryInfo(
        totalRAMMB: totalRAM,
        availableRAMMB: availableRAM,
        usedRAMMB: usedRAM,
        usagePercentage: usagePercent,
      );
    } catch (e) {
      debugPrint('❌ Error getting device memory: $e');
      return DeviceMemoryInfo();
    }
  }
}

