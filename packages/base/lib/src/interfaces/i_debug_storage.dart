import 'package:base/base.dart';

/// Interface for debug data storage
/// Follows Interface Segregation Principle - clients depend only on what they need
abstract class IDebugStorage {
  /// Initialize the storage
  Future<void> initialize();
  
  /// Clear all stored data
  void clearAll();
  
  /// Get count of all items in storage
  Map<String, int> getItemCounts();
}

/// Interface for log storage operations
abstract class ILogStorage {
  void addLog(DebugLog log);
  List<DebugLog> getLogs();
  void clearLogs();
}

/// Interface for network request storage operations
abstract class INetworkStorage {
  void addNetworkRequest(NetworkRequest request);
  List<NetworkRequest> getNetworkRequests();
  void clearNetworkRequests();
}

/// Interface for crash report storage operations
abstract class ICrashStorage {
  void addCrashReport(CrashReport report);
  List<CrashReport> getCrashReports();
  void clearCrashReports();
}

/// Interface for analytics event storage operations
abstract class IEventStorage {
  void addAnalyticsEvent(AnalyticsEvent event);
  List<AnalyticsEvent> getAnalyticsEvents();
  void clearAnalyticsEvents();
}

/// Interface for notification log storage operations
abstract class INotificationStorage {
  void addNotificationLog(NotificationLog log);
  List<NotificationLog> getNotificationLogs();
  void clearNotificationLogs();
}

