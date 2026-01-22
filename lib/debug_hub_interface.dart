/// DebugHub Manager - Enterprise-grade debugging solution
///
/// This provides a clean, production-ready interface for developers.
library debug_hub_manager;

import 'package:flutter/material.dart';
import 'package:debug_hub_ui/debug_hub_ui.dart' hide DebugHubConfig;
import 'package:debug_hub_ui/src/debug_hub_config.dart' show DebugHubConfig;
import 'package:base/base.dart' show AppLogLevel;
import 'package:log/log.dart';
import 'package:events/events.dart';
import 'package:notification/notification.dart';
import 'package:non_fatal/non_fatal.dart';

/// DebugHub Manager - Simplified API for enterprise integration
///
/// Provides a clean interface for integrating DebugHub into your application
/// with minimal code and maximum functionality.
///
/// Example:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await DebugHubManager.initialize(
///     packageName: 'com.yourcompany.app',
///     mainColor: Colors.blue,
///   );
///   runApp(DebugHubManager.wrap(MyApp()));
/// }
/// ```
class DebugHubManager {
  DebugHubManager._();

  /// Initialize DebugHub with optional configuration
  ///
  /// This should be called early in your `main()` function before `runApp`.
  ///
  /// Parameters:
  /// - [packageName]: Your app's package identifier (e.g., 'com.yourcompany.app')
  /// - [serverURL]: Your API server URL for highlighting in network requests
  /// - [ignoredURLs]: List of URL patterns to exclude from network monitoring
  /// - [mainColor]: Primary theme color for DebugHub UI
  /// - [enableShakeGesture]: Deprecated - shake gesture functionality has been removed (ignored)
  /// - [showBubbleOnStart]: Show debug bubble when app starts (default: true)
  ///
  /// Example:
  /// ```dart
  /// await DebugHubManager.initialize(
  ///   packageName: 'com.yourcompany.app',
  ///   serverURL: 'https://api.yourcompany.com',
  ///   mainColor: Colors.blue,
  /// );
  /// ```
  static Widget initialize({
    Color? mainColor,
    required Widget child,
    Map<String, dynamic>? userProperties,
  }) {
    final config = DebugHubConfig(
      mainColor: mainColor ?? const Color(0xFF42d459),
      userProperties: userProperties,
    );
    return DebugHub().wrap(child, config: config);
  }

  static Future<void> enableOnlyWithoutUI() async {
    await DebugHub().initWithoutUI();
  }

  static void updateUserProperties(
    Map<String, dynamic> userProperties,
  ) {
    DebugHub().updateUserProperties(userProperties);
  }

  /// Log a message with optional tag and level
  ///
  /// Parameters:
  /// - [message]: The log message
  /// - [tag]: Optional tag for categorization (e.g., 'Auth', 'Network')
  /// - [level]: Log level (debug, info, warning, error)
  ///
  /// Example:
  /// ```dart
  /// DebugHubManager.log('User logged in', tag: 'Auth');
  /// ```
  static void log(
    String message, {
    String? tag,
    AppLogLevel level = AppLogLevel.debug,
  }) {
    DebugLogger().log(message, tag: tag, level: level);
  }

  /// Log an error with optional error object and stack trace
  ///
  /// Parameters:
  /// - [message]: Error description
  /// - [error]: The error object
  /// - [stackTrace]: Stack trace for debugging
  /// - [tag]: Optional tag for categorization
  ///
  /// Example:
  /// ```dart
  /// DebugHubManager.logError('Failed to load data', error: e, stackTrace: s);
  /// ```
  static void logError(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    DebugLogger().log(
      message,
      tag: tag,
      level: AppLogLevel.error,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Track an analytics event
  ///
  /// Parameters:
  /// - [name]: Event name (e.g., 'button_click', 'page_view')
  /// - [properties]: Event properties as key-value pairs
  /// - [source]: Event source (e.g., 'firebase', 'clevertap')
  ///
  /// Example:
  /// ```dart
  /// DebugHubManager.trackEvent(
  ///   'button_click',
  ///   properties: {'button_id': 'submit', 'screen': 'home'},
  ///   source: 'firebase',
  /// );
  /// ```
  static void trackEvent(
    String name, {
    Map<String, dynamic>? properties,
    String? source,
  }) {
    EventTracker().trackEvent(name, properties: properties, source: source);
  }

  /// Log a notification received
  ///
  /// Call this when your app receives a push notification.
  ///
  /// Parameters:
  /// - [title]: Notification title
  /// - [body]: Notification body text
  /// - [payload]: Additional data payload
  /// - [notificationId]: Unique notification identifier
  ///
  /// Example:
  /// ```dart
  /// DebugHubManager.logNotification(
  ///   title: 'New Message',
  ///   body: 'You have a new message',
  ///   payload: {'message_id': '123'},
  ///   notificationId: 'notif_123',
  /// );
  /// ```
  static void logNotification({
    String? title,
    String? body,
    Map<String, dynamic>? payload,
    String? notificationId,
    String? notificationSource,
    String? mode,
  }) {
    NotificationLogger().logNotificationReceived(
      title: title,
      body: body,
      payload: payload,
      notificationId: notificationId,
      notificationSource: notificationSource,
      mode: mode,
    );
  }
  /// Report a non-fatal crash or error
  ///
  /// Use this to manually report errors that don't crash the app.
  ///
  /// Parameters:
  /// - [error]: The error object
  /// - [stackTrace]: Stack trace for debugging
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   // risky operation
  /// } catch (error, stackTrace) {
  ///   DebugHubManager.reportCrash(error, stackTrace);
  /// }
  /// ```
  static void reportCrash(
    dynamic error,
    StackTrace? stackTrace, {
    bool isFatal = false,
  }) {
    CrashHandler().reportError(error, stackTrace: stackTrace, isFatal: isFatal);
  }

  /// Get the NavigatorObserver for DebugHub
  ///
  /// This should be added to MaterialApp's navigatorObservers list.
  /// Similar to WEChucker.getObserver()
  ///
  /// Example:
  /// ```dart
  /// MaterialApp(
  ///   navigatorObservers: [DebugHubManager.getObserver()],
  ///   // ...
  /// )
  /// ```
  static NavigatorObserver getObserver() {
    return DebugHub().getObserver();
  }

  /// Clear all debug data
  ///
  /// Clears all logs, network requests, crashes, events, and notifications.
  ///
  /// Example:
  /// ```dart
  /// await DebugHubManager.clearAll();
  /// ```
  static Future<void> clearAll() async {
    await DebugHub().clearAll();
  }

  /// Show DebugHub screen manually
  ///
  /// Opens the DebugHub dashboard programmatically.
  ///
  /// Example:
  /// ```dart
  /// DebugHubManager.show(context);
  /// ```
  static void show(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DebugMainScreen(config: DebugHub().config),
      ),
    );
  }
}
