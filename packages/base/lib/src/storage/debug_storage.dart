import 'dart:collection';
import '../models/debug_log.dart';
import '../models/network_request.dart';
import '../models/crash_report.dart';
import '../models/analytics_event.dart';
import 'persistent_storage.dart';

class DebugStorage {
  static final DebugStorage _instance = DebugStorage._internal();
  factory DebugStorage() => _instance;
  DebugStorage._internal();

  final int maxLogs = 1000;
  final int maxNetworkRequests = 500;
  final int maxCrashReports = 100;
  final int maxEvents = 1000;

  final _logs = Queue<DebugLog>();
  final _networkRequests = Queue<NetworkRequest>();
  final _crashReports = Queue<CrashReport>();
  final _events = Queue<AnalyticsEvent>();

  final PersistentStorage _persistentStorage = PersistentStorage();
  bool _isLoaded = false;

  /// Initialize and load data from persistent storage
  Future<void> initialize() async {
    if (_isLoaded) return;

    await _persistentStorage.initialize();
    
    // Load data from persistent storage
    final logs = await _persistentStorage.loadLogs();
    final requests = await _persistentStorage.loadNetworkRequests();
    final crashes = await _persistentStorage.loadCrashReports();
    final events = await _persistentStorage.loadEvents();

    // Populate in-memory queues
    _logs.addAll(logs.take(maxLogs));
    _networkRequests.addAll(requests.take(maxNetworkRequests));
    _crashReports.addAll(crashes.take(maxCrashReports));
    _events.addAll(events.take(maxEvents));

    _isLoaded = true;
  }

  // Logs
  void addLog(DebugLog log) {
    _logs.add(log);
    if (_logs.length > maxLogs) {
      _logs.removeFirst();
    }
    // Persist to storage
    _persistentStorage.saveLog(log);
  }

  List<DebugLog> getLogs() => _logs.toList();

  Future<void> clearLogs() async {
    _logs.clear();
    await _persistentStorage.clearLogs();
  }

  // Network Requests
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

  List<NetworkRequest> getNetworkRequests() => _networkRequests.toList();

  NetworkRequest? getNetworkRequestById(String id) {
    try {
      return _networkRequests.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearNetworkRequests() async {
    _networkRequests.clear();
    await _persistentStorage.clearNetworkRequests();
  }

  // Crash Reports
  void addCrashReport(CrashReport report) {
    _crashReports.add(report);
    if (_crashReports.length > maxCrashReports) {
      _crashReports.removeFirst();
    }
    // Persist to storage
    _persistentStorage.saveCrashReport(report);
  }

  List<CrashReport> getCrashReports() => _crashReports.toList();

  Future<void> clearCrashReports() async {
    _crashReports.clear();
    await _persistentStorage.clearCrashReports();
  }

  // Analytics Events
  void addEvent(AnalyticsEvent event) {
    _events.add(event);
    if (_events.length > maxEvents) {
      _events.removeFirst();
    }
    // Persist to storage
    _persistentStorage.saveEvent(event);
  }

  List<AnalyticsEvent> getEvents() => _events.toList();

  Future<void> clearEvents() async {
    _events.clear();
    await _persistentStorage.clearEvents();
  }

  // Clear all
  Future<void> clearAll() async {
    _logs.clear();
    _networkRequests.clear();
    _crashReports.clear();
    _events.clear();
    await _persistentStorage.clearAll();
  }

  // Get storage info
  Future<int> getStorageSize() => _persistentStorage.getStorageSize();
  Future<String> getStorageSizeFormatted() => _persistentStorage.getStorageSizeFormatted();
  Future<Map<String, int>> getItemCounts() => _persistentStorage.getItemCounts();
}

