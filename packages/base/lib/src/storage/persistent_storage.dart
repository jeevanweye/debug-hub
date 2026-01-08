import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/debug_log.dart';
import '../models/network_request.dart';
import '../models/crash_report.dart';
import '../models/analytics_event.dart';

class PersistentStorage {
  static final PersistentStorage _instance = PersistentStorage._internal();
  factory PersistentStorage() => _instance;
  PersistentStorage._internal();

  static const String _logsBoxName = 'debug_logs';
  static const String _networkBoxName = 'network_requests';
  static const String _crashesBoxName = 'crash_reports';
  static const String _eventsBoxName = 'analytics_events';

  Box<String>? _logsBox;
  Box<String>? _networkBox;
  Box<String>? _crashesBox;
  Box<String>? _eventsBox;

  bool _isInitialized = false;

  /// Initialize Hive and open boxes
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();
      
      _logsBox = await Hive.openBox<String>(_logsBoxName);
      _networkBox = await Hive.openBox<String>(_networkBoxName);
      _crashesBox = await Hive.openBox<String>(_crashesBoxName);
      _eventsBox = await Hive.openBox<String>(_eventsBoxName);
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing PersistentStorage: $e');
    }
  }

  bool get isInitialized => _isInitialized;

  // Logs
  Future<void> saveLog(DebugLog log) async {
    if (!_isInitialized) return;
    try {
      await _logsBox?.put(log.id, jsonEncode(log.toJson()));
    } catch (e) {
      debugPrint('Error saving log: $e');
    }
  }

  Future<List<DebugLog>> loadLogs() async {
    if (!_isInitialized) return [];
    try {
      final values = _logsBox?.values.toList() ?? [];
      return values
          .map((json) => DebugLog.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      debugPrint('Error loading logs: $e');
      return [];
    }
  }

  Future<void> clearLogs() async {
    if (!_isInitialized) return;
    try {
      await _logsBox?.clear();
    } catch (e) {
      debugPrint('Error clearing logs: $e');
    }
  }

  // Network Requests
  Future<void> saveNetworkRequest(NetworkRequest request) async {
    if (!_isInitialized) return;
    try {
      await _networkBox?.put(request.id, jsonEncode(request.toJson()));
    } catch (e) {
      debugPrint('Error saving network request: $e');
    }
  }

  Future<void> updateNetworkRequest(NetworkRequest request) async {
    if (!_isInitialized) return;
    try {
      await _networkBox?.put(request.id, jsonEncode(request.toJson()));
    } catch (e) {
      debugPrint('Error updating network request: $e');
    }
  }

  Future<List<NetworkRequest>> loadNetworkRequests() async {
    if (!_isInitialized) return [];
    try {
      final values = _networkBox?.values.toList() ?? [];
      return values
          .map((json) => NetworkRequest.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      debugPrint('Error loading network requests: $e');
      return [];
    }
  }

  Future<void> clearNetworkRequests() async {
    if (!_isInitialized) return;
    try {
      await _networkBox?.clear();
    } catch (e) {
      debugPrint('Error clearing network requests: $e');
    }
  }

  // Crash Reports
  Future<void> saveCrashReport(CrashReport report) async {
    if (!_isInitialized) return;
    try {
      await _crashesBox?.put(report.id, jsonEncode(report.toJson()));
    } catch (e) {
      debugPrint('Error saving crash report: $e');
    }
  }

  Future<List<CrashReport>> loadCrashReports() async {
    if (!_isInitialized) return [];
    try {
      final values = _crashesBox?.values.toList() ?? [];
      return values
          .map((json) => CrashReport.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      debugPrint('Error loading crash reports: $e');
      return [];
    }
  }

  Future<void> clearCrashReports() async {
    if (!_isInitialized) return;
    try {
      await _crashesBox?.clear();
    } catch (e) {
      debugPrint('Error clearing crash reports: $e');
    }
  }

  // Analytics Events
  Future<void> saveEvent(AnalyticsEvent event) async {
    if (!_isInitialized) return;
    try {
      await _eventsBox?.put(event.id, jsonEncode(event.toJson()));
    } catch (e) {
      debugPrint('Error saving event: $e');
    }
  }

  Future<List<AnalyticsEvent>> loadEvents() async {
    if (!_isInitialized) return [];
    try {
      final values = _eventsBox?.values.toList() ?? [];
      return values
          .map((json) => AnalyticsEvent.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      debugPrint('Error loading events: $e');
      return [];
    }
  }

  Future<void> clearEvents() async {
    if (!_isInitialized) return;
    try {
      await _eventsBox?.clear();
    } catch (e) {
      debugPrint('Error clearing events: $e');
    }
  }

  // Clear all data
  Future<void> clearAll() async {
    if (!_isInitialized) return;
    await Future.wait([
      clearLogs(),
      clearNetworkRequests(),
      clearCrashReports(),
      clearEvents(),
    ]);
  }

  /// Get total storage size in bytes
  Future<int> getStorageSize() async {
    if (!_isInitialized) return 0;
    
    try {
      int totalSize = 0;
      
      // Calculate size of each box
      final boxes = [_logsBox, _networkBox, _crashesBox, _eventsBox];
      
      for (final box in boxes) {
        if (box != null) {
          for (final value in box.values) {
            totalSize += value.length; // Approximate size in bytes
          }
        }
      }
      
      return totalSize;
    } catch (e) {
      debugPrint('Error calculating storage size: $e');
      return 0;
    }
  }

  /// Get storage size as human-readable string
  Future<String> getStorageSizeFormatted() async {
    final bytes = await getStorageSize();
    
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  /// Get count of items in each category
  Future<Map<String, int>> getItemCounts() async {
    if (!_isInitialized) {
      return {
        'logs': 0,
        'network': 0,
        'crashes': 0,
        'events': 0,
      };
    }

    return {
      'logs': _logsBox?.length ?? 0,
      'network': _networkBox?.length ?? 0,
      'crashes': _crashesBox?.length ?? 0,
      'events': _eventsBox?.length ?? 0,
    };
  }

  /// Close all boxes (call on app dispose)
  Future<void> close() async {
    await _logsBox?.close();
    await _networkBox?.close();
    await _crashesBox?.close();
    await _eventsBox?.close();
    _isInitialized = false;
  }
}

