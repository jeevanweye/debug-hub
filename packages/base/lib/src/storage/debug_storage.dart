import 'dart:collection';
import '../models/debug_log.dart';
import '../models/network_request.dart';
import '../models/crash_report.dart';
import '../models/analytics_event.dart';
import '../models/notification_log.dart';
import '../interfaces/i_debug_storage.dart';
import 'persistent_storage.dart';

/// In-memory storage implementation for debug data
/// Implements multiple interfaces following Interface Segregation Principle
class DebugStorage implements 
    IDebugStorage,
    ILogStorage,
    INetworkStorage,
    ICrashStorage,
    IEventStorage,
    INotificationStorage {
  
  static final DebugStorage _instance = DebugStorage._internal();
  factory DebugStorage() => _instance;
  DebugStorage._internal();

  final int maxLogs = 1500;
  final int maxNetworkRequests = 1000;
  final int maxCrashReports = 500;
  final int maxEvents = 1500;
  final int maxNotificationLogs = 1000;

  final _logs = Queue<DebugLog>();
  final _networkRequests = Queue<NetworkRequest>();
  final _crashReports = Queue<CrashReport>();
  final _events = Queue<AnalyticsEvent>();
  final _notificationLogs = Queue<NotificationLog>();

  final PersistentStorage _persistentStorage = PersistentStorage();
  bool _isLoaded = false;

  /// Initialize and load data from persistent storage
  @override
  Future<void> initialize() async {
    if (_isLoaded) return;

    await _persistentStorage.initialize();
    
    // Load data from persistent storage
    final logs = await _persistentStorage.loadLogs();
    final requests = await _persistentStorage.loadNetworkRequests();
    final crashes = await _persistentStorage.loadCrashReports();
    final events = await _persistentStorage.loadEvents();
    final notifications = await _persistentStorage.loadNotificationLogs();

    // Populate in-memory queues
    _logs.addAll(logs.take(maxLogs));
    _networkRequests.addAll(requests.take(maxNetworkRequests));
    _crashReports.addAll(crashes.take(maxCrashReports));
    _events.addAll(events.take(maxEvents));
    _notificationLogs.addAll(notifications.take(maxNotificationLogs));

    _isLoaded = true;
  }

  // Logs
  @override
  void addLog(DebugLog log) {
    _logs.add(log);
    if (_logs.length > maxLogs) {
      _logs.removeFirst();
    }
    // Persist to storage
    _persistentStorage.saveLog(log);
  }

  @override
  List<DebugLog> getLogs() => _logs.toList();

  @override
  Future<void> clearLogs() async {
    _logs.clear();
    await _persistentStorage.clearLogs();
  }

  // Network Requests
  @override
  void addNetworkRequest(NetworkRequest request) {
    _networkRequests.add(request);
    if (_networkRequests.length > maxNetworkRequests) {
      _networkRequests.removeFirst();
    }
    // Persist to storage
    _persistentStorage.saveNetworkRequest(request);
  }

  void updateNetworkRequest(String id, NetworkRequest updatedRequest) {
    final index = _networkRequests.toList().indexWhere((r) => r.id == id);
    if (index != -1) {
      final list = _networkRequests.toList();
      list[index] = updatedRequest;
      _networkRequests.clear();
      _networkRequests.addAll(list);
      // Persist update
      _persistentStorage.updateNetworkRequest(updatedRequest);
    }
  }

  @override
  List<NetworkRequest> getNetworkRequests() => _networkRequests.toList();

  NetworkRequest? getNetworkRequestById(String id) {
    try {
      return _networkRequests.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearNetworkRequests() async {
    _networkRequests.clear();
    await _persistentStorage.clearNetworkRequests();
  }

  // Crash Reports
  @override
  void addCrashReport(CrashReport report) {
    _crashReports.add(report);
    if (_crashReports.length > maxCrashReports) {
      _crashReports.removeFirst();
    }
    // Persist to storage
    _persistentStorage.saveCrashReport(report);
  }

  @override
  List<CrashReport> getCrashReports() => _crashReports.toList();

  @override
  Future<void> clearCrashReports() async {
    _crashReports.clear();
    await _persistentStorage.clearCrashReports();
  }

  // Analytics Events
  @override
  void addAnalyticsEvent(AnalyticsEvent event) {
    _events.add(event);
    if (_events.length > maxEvents) {
      _events.removeFirst();
    }
    // Persist to storage
    _persistentStorage.saveEvent(event);
  }

  @override
  List<AnalyticsEvent> getAnalyticsEvents() => _events.toList();

  @override
  Future<void> clearAnalyticsEvents() async {
    _events.clear();
    await _persistentStorage.clearEvents();
  }

  // Notification Logs
  @override
  void addNotificationLog(NotificationLog log) {
    _notificationLogs.add(log);
    if (_notificationLogs.length > maxNotificationLogs) {
      _notificationLogs.removeFirst();
    }
    // Persist to storage
    _persistentStorage.saveNotificationLog(log);
  }

  @override
  List<NotificationLog> getNotificationLogs() => _notificationLogs.toList();

  @override
  Future<void> clearNotificationLogs() async {
    _notificationLogs.clear();
    await _persistentStorage.clearNotificationLogs();
  }

  // Clear all
  @override
  Future<void> clearAll() async {
    _logs.clear();
    _networkRequests.clear();
    _crashReports.clear();
    _events.clear();
    _notificationLogs.clear();
    await _persistentStorage.clearAll();
  }

  // Get storage info
  @override
  Map<String, int> getItemCounts() {
    return {
      'logs': _logs.length,
      'networkRequests': _networkRequests.length,
      'crashReports': _crashReports.length,
      'events': _events.length,
      'notifications': _notificationLogs.length,
    };
  }

  // Additional helper methods (not part of interface)
  void addEvent(AnalyticsEvent event) => addAnalyticsEvent(event);
  List<AnalyticsEvent> getEvents() => getAnalyticsEvents();
  Future<void> clearEvents() => clearAnalyticsEvents();
  
  Future<int> getStorageSize() async {
    return _persistentStorage.getStorageSize();
  }

  Future<String> getStorageSizeFormatted() async {
    return _persistentStorage.getStorageSizeFormatted();
  }
}

