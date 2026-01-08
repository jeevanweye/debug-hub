import 'package:base/base.dart';

/// Service for logging notifications received and tapped
class NotificationLogger {
  static final NotificationLogger _instance = NotificationLogger._internal();
  factory NotificationLogger() => _instance;
  NotificationLogger._internal();

  final DebugStorage _storage = DebugStorage();
  bool _isEnabled = false;

  /// Enable notification logging
  void enable() {
    _isEnabled = true;
  }

  /// Disable notification logging
  void disable() {
    _isEnabled = false;
  }

  bool get isEnabled => _isEnabled;

  /// Log a notification that was received
  /// 
  /// [title] - Notification title
  /// [body] - Notification body/message
  /// [payload] - Additional notification data/payload
  /// [notificationId] - Unique identifier for the notification
  void logNotificationReceived({
    String? title,
    String? body,
    Map<String, dynamic>? payload,
    String? notificationId,
  }) {
    if (!_isEnabled) return;

    final log = NotificationLog.createReceived(
      title: title,
      body: body,
      payload: payload,
      notificationId: notificationId,
    );

    _storage.addNotificationLog(log);
  }

  /// Log a notification that was tapped
  /// 
  /// [notificationId] - Unique identifier for the notification
  /// [title] - Notification title (optional, for reference)
  /// [body] - Notification body/message (optional, for reference)
  /// [payload] - Additional notification data/payload (optional, for reference)
  void logNotificationTapped({
    required String notificationId,
    String? title,
    String? body,
    Map<String, dynamic>? payload,
  }) {
    if (!_isEnabled) return;

    final log = NotificationLog.createTapped(
      notificationId: notificationId,
      title: title,
      body: body,
      payload: payload,
    );

    _storage.addNotificationLog(log);
  }

  /// Get all notification logs
  List<NotificationLog> getNotificationLogs() {
    return _storage.getNotificationLogs();
  }

  /// Get notification logs filtered by type
  List<NotificationLog> getNotificationLogsByType(NotificationType type) {
    return _storage.getNotificationLogs()
        .where((log) => log.type == type)
        .toList();
  }

  /// Get notification logs for a specific notification ID
  List<NotificationLog> getNotificationLogsById(String notificationId) {
    return _storage.getNotificationLogs()
        .where((log) => log.notificationId == notificationId)
        .toList();
  }

  /// Clear all notification logs
  Future<void> clearNotificationLogs() async {
    await _storage.clearNotificationLogs();
  }
}

