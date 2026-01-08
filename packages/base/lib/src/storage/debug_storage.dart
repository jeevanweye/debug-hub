import 'dart:collection';
import '../models/debug_log.dart';
import '../models/network_request.dart';
import '../models/crash_report.dart';

class DebugStorage {
  static final DebugStorage _instance = DebugStorage._internal();
  factory DebugStorage() => _instance;
  DebugStorage._internal();

  final int maxLogs = 1000;
  final int maxNetworkRequests = 500;
  final int maxCrashReports = 100;

  final _logs = Queue<DebugLog>();
  final _networkRequests = Queue<NetworkRequest>();
  final _crashReports = Queue<CrashReport>();

  // Logs
  void addLog(DebugLog log) {
    _logs.add(log);
    if (_logs.length > maxLogs) {
      _logs.removeFirst();
    }
  }

  List<DebugLog> getLogs() => _logs.toList();

  void clearLogs() => _logs.clear();

  // Network Requests
  void addNetworkRequest(NetworkRequest request) {
    _networkRequests.add(request);
    if (_networkRequests.length > maxNetworkRequests) {
      _networkRequests.removeFirst();
    }
  }

  void updateNetworkRequest(String id, NetworkRequest updatedRequest) {
    final index = _networkRequests.toList().indexWhere((r) => r.id == id);
    if (index != -1) {
      final list = _networkRequests.toList();
      list[index] = updatedRequest;
      _networkRequests.clear();
      _networkRequests.addAll(list);
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

  void clearNetworkRequests() => _networkRequests.clear();

  // Crash Reports
  void addCrashReport(CrashReport report) {
    _crashReports.add(report);
    if (_crashReports.length > maxCrashReports) {
      _crashReports.removeFirst();
    }
  }

  List<CrashReport> getCrashReports() => _crashReports.toList();

  void clearCrashReports() => _crashReports.clear();

  // Clear all
  void clearAll() {
    clearLogs();
    clearNetworkRequests();
    clearCrashReports();
  }
}

