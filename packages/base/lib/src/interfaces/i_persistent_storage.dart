import 'package:base/base.dart';

/// Interface for persistent storage operations
/// Follows Dependency Inversion Principle - depend on abstractions
abstract class IPersistentStorage {
  /// Initialize the persistent storage
  Future<void> initialize();
  
  /// Close the persistent storage
  Future<void> close();
  
  /// Clear all persisted data
  Future<void> clearAll();
  
  /// Get count of all items in persistent storage
  Future<Map<String, int>> getItemCounts();
  
  /// Get total storage size in bytes
  Future<int> getStorageSize();
}

/// Interface for persistent log storage
abstract class IPersistentLogStorage {
  Future<void> saveLog(DebugLog log);
  Future<List<DebugLog>> loadLogs();
  Future<void> clearLogs();
}

/// Interface for persistent network request storage
abstract class IPersistentNetworkStorage {
  Future<void> saveNetworkRequest(NetworkRequest request);
  Future<List<NetworkRequest>> loadNetworkRequests();
  Future<void> clearNetworkRequests();
}

/// Interface for persistent crash report storage
abstract class IPersistentCrashStorage {
  Future<void> saveCrashReport(CrashReport report);
  Future<List<CrashReport>> loadCrashReports();
  Future<void> clearCrashReports();
}

/// Interface for persistent analytics event storage
abstract class IPersistentEventStorage {
  Future<void> saveAnalyticsEvent(AnalyticsEvent event);
  Future<List<AnalyticsEvent>> loadAnalyticsEvents();
  Future<void> clearAnalyticsEvents();
}

/// Interface for persistent notification log storage
abstract class IPersistentNotificationStorage {
  Future<void> saveNotificationLog(NotificationLog log);
  Future<List<NotificationLog>> loadNotificationLogs();
  Future<void> clearNotificationLogs();
}

