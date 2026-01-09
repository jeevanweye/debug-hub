import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Platform channel for device memory information
class DeviceMemoryChannel {
  static const MethodChannel _channel = MethodChannel('com.debughub.memory_monitor/device_memory');

  /// Get device memory information via platform channel
  static Future<Map<String, dynamic>?> getDeviceMemory() async {
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>('getDeviceMemory');
      if (result == null) return null;
      
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      debugPrint('❌ Platform exception getting device memory: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('❌ Error getting device memory via channel: $e');
      return null;
    }
  }
}

