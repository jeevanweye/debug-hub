import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';
import 'models/memory_snapshot.dart';
import 'utils/device_memory_info.dart';

/// Memory monitoring service
class MemoryMonitor {
  static final MemoryMonitor _instance = MemoryMonitor._internal();
  factory MemoryMonitor() => _instance;
  MemoryMonitor._internal();

  final int maxSnapshots = 100;
  final Queue<MemorySnapshot> _snapshots = Queue<MemorySnapshot>();
  
  Timer? _monitoringTimer;
  bool _isMonitoring = false;
  VmService? _vmService;

  bool get isMonitoring => _isMonitoring;
  List<MemorySnapshot> get snapshots => _snapshots.toList();

  /// Start monitoring memory usage
  Future<void> startMonitoring({Duration interval = const Duration(seconds: 5)}) async {
    if (_isMonitoring) return;
    
    // Check if we're in debug mode
    if (kReleaseMode) {
      debugPrint('⚠️ Memory monitoring is not available in release mode.');
      debugPrint('💡 Run the app in debug or profile mode to enable memory monitoring.');
      return;
    }
    
    try {
      // Connect to VM service
      final serviceInfo = await developer.Service.getInfo();
      if (serviceInfo.serverUri == null) {
        debugPrint('⚠️ VM Service not available.');
        debugPrint('💡 Memory monitoring only works in debug/profile mode.');
        debugPrint('💡 Make sure you are running: flutter run (not flutter run --release)');
        return;
      }

      // Get the server URI
      final serverUri = serviceInfo.serverUri!;
      debugPrint('🔗 VM Service URI: $serverUri');
      
      // Try to connect using the HTTP URI directly first
      // vmServiceConnectUri can handle HTTP URIs and convert them internally
      String connectionUri = serverUri.toString();
      
      // If it's HTTP/HTTPS, try WebSocket conversion
      if (serverUri.scheme == 'http' || serverUri.scheme == 'https') {
        // Construct WebSocket URI manually
        final scheme = serverUri.scheme == 'https' ? 'wss' : 'ws';
        final host = serverUri.host;
        final port = serverUri.hasPort ? serverUri.port : (serverUri.scheme == 'https' ? 443 : 80);
        final path = serverUri.path.isEmpty ? '/ws' : '${serverUri.path}/ws';
        connectionUri = '$scheme://$host:$port$path';
      } else if (serverUri.scheme == 'ws' || serverUri.scheme == 'wss') {
        // Already WebSocket
        connectionUri = serverUri.toString();
        if (!connectionUri.endsWith('/ws')) {
          connectionUri = connectionUri.endsWith('/') ? '${connectionUri}ws' : '$connectionUri/ws';
        }
      }

      debugPrint('🔗 Connecting to: $connectionUri');
      
      // Connect with timeout and retry logic
      VmService? service;
      int retries = 3;
      for (int i = 0; i < retries; i++) {
        try {
          service = await vmServiceConnectUri(
            connectionUri,
          ).timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              throw TimeoutException('Connection timeout (attempt ${i + 1}/$retries)');
            },
          );
          break; // Success, exit retry loop
        } catch (e) {
          if (i < retries - 1) {
            debugPrint('⚠️ Connection attempt ${i + 1} failed: $e');
            debugPrint('🔄 Retrying in 1 second...');
            await Future.delayed(const Duration(seconds: 1));
          } else {
            rethrow; // Last attempt failed, rethrow
          }
        }
      }
      
      _vmService = service;
      
      // Verify connection by getting VM info
      final vm = await _vmService!.getVM();
      if (vm.isolates == null || vm.isolates!.isEmpty) {
        debugPrint('⚠️ No isolates found in VM');
        _vmService?.dispose();
        _vmService = null;
        return;
      }
      
      _isMonitoring = true;
      debugPrint('🔍 Memory monitoring started successfully');

      // Take initial snapshot
      await _captureSnapshot();

      // Start periodic monitoring
      _monitoringTimer = Timer.periodic(interval, (_) async {
        await _captureSnapshot();
      });
    } on TimeoutException catch (e) {
      debugPrint('❌ VM Service connection timeout: $e');
      debugPrint('💡 Make sure you are running in debug or profile mode');
      _isMonitoring = false;
      _vmService?.dispose();
      _vmService = null;
    } catch (e) {
      debugPrint('❌ Failed to start memory monitoring: $e');
      debugPrint('💡 Memory monitoring only works in debug/profile mode');
      debugPrint('💡 Make sure the app is not running in release mode');
      _isMonitoring = false;
      _vmService?.dispose();
      _vmService = null;
    }
  }

  /// Stop monitoring
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    _isMonitoring = false;
    _vmService?.dispose();
    _vmService = null;
    debugPrint('🛑 Memory monitoring stopped');
  }

  /// Capture a memory snapshot
  Future<void> _captureSnapshot() async {
    if (!_isMonitoring || _vmService == null) return;

    try {
      final vm = await _vmService!.getVM();
      if (vm.isolates == null || vm.isolates!.isEmpty) return;

      final isolateRef = vm.isolates!.first;
      final isolate = await _vmService!.getIsolate(isolateRef.id!);
      
      if (isolate.id == null) return;

      final memoryUsage = await _vmService!.getMemoryUsage(isolate.id!);
      
      // Calculate memory values in MB
      final heapUsage = (memoryUsage.heapUsage ?? 0) ~/ (1024 * 1024);
      final heapCapacity = (memoryUsage.heapCapacity ?? 0) ~/ (1024 * 1024);
      final externalUsage = (memoryUsage.externalUsage ?? 0) ~/ (1024 * 1024);
      
      final totalUsed = heapUsage + externalUsage;
      final totalCapacity = heapCapacity + externalUsage;
      final usagePercentage = totalCapacity > 0 
          ? (totalUsed / totalCapacity * 100) 
          : 0.0;

      // Get device memory information
      final deviceMemory = await DeviceMemoryInfo.getDeviceMemory();

      final snapshot = MemorySnapshot(
        timestamp: DateTime.now(),
        usedMemoryMB: totalUsed,
        freeMemoryMB: totalCapacity - totalUsed,
        totalMemoryMB: totalCapacity,
        usagePercentage: usagePercentage,
        dartHeapMB: heapUsage,
        dartHeapCapacityMB: heapCapacity,
        externalMemoryMB: externalUsage,
        deviceTotalRAMMB: deviceMemory.totalRAMMB,
        deviceAvailableRAMMB: deviceMemory.availableRAMMB,
        deviceUsedRAMMB: deviceMemory.usedRAMMB,
        deviceMemoryUsagePercentage: deviceMemory.usagePercentage,
      );

      _snapshots.add(snapshot);
      
      // Remove old snapshots
      if (_snapshots.length > maxSnapshots) {
        _snapshots.removeFirst();
      }

      debugPrint('📊 Memory: ${totalUsed}MB / ${totalCapacity}MB (${usagePercentage.toStringAsFixed(1)}%)');
    } catch (e) {
      debugPrint('❌ Error capturing memory snapshot: $e');
    }
  }

  /// Get memory statistics
  MemoryStatistics getStatistics() {
    return MemoryStatistics.fromSnapshots(_snapshots.toList());
  }

  /// Get current memory usage
  MemorySnapshot? getCurrentSnapshot() {
    return _snapshots.isEmpty ? null : _snapshots.last;
  }

  /// Clear all snapshots
  void clearSnapshots() {
    _snapshots.clear();
    debugPrint('🗑️ Memory snapshots cleared');
  }

  /// Force garbage collection (for testing)
  Future<void> forceGC() async {
    if (_vmService == null) return;

    try {
      final vm = await _vmService!.getVM();
      if (vm.isolates == null || vm.isolates!.isEmpty) return;

      final isolateRef = vm.isolates!.first;
      if (isolateRef.id == null) return;

      await _vmService!.callServiceExtension(
        'ext.flutter.reassemble',
        isolateId: isolateRef.id,
      );
      
      debugPrint('🗑️ Garbage collection triggered');
    } catch (e) {
      debugPrint('❌ Failed to trigger GC: $e');
    }
  }
}

