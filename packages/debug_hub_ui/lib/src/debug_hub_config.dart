import 'package:flutter/material.dart';

class DebugHubConfig {
  /// Server URL to highlight in network requests
  final String? serverURL;

  /// URLs to ignore from capturing
  final List<String>? ignoredURLs;

  /// Only capture these URLs
  final List<String>? onlyURLs;

  /// Log prefixes to ignore
  final List<String>? ignoredPrefixLogs;

  /// Only capture logs with these prefixes
  final List<String>? onlyPrefixLogs;

  /// Additional custom tab in the debug UI
  final Widget? additionalTab;

  /// Label for additional tab
  final String? additionalTabLabel;

  /// Icon for additional tab
  final IconData? additionalTabIcon;

  /// Email recipients for sharing debug data
  final List<String>? emailToRecipients;

  /// Email CC recipients
  final List<String>? emailCcRecipients;

  /// Main theme color for debug UI
  final Color mainColor;

  /// Enable log monitoring
  final bool enableLogMonitoring;

  /// Enable network monitoring
  final bool enableNetworkMonitoring;

  /// Enable crash monitoring
  final bool enableCrashMonitoring;

  /// Enable event monitoring (analytics events)
  final bool enableEventMonitoring;

  /// Enable notification monitoring
  final bool enableNotificationMonitoring;

  /// Maximum number of logs to store
  final int maxLogs;

  /// Maximum number of network requests to store
  final int maxNetworkRequests;

  /// Show debug bubble on app start
  final bool showBubbleOnStart;

  /// Bubble position (default: bottom right)
  final Alignment bubbleAlignment;

  /// Enable performance monitoring
  final bool enablePerformanceMonitoring;

  /// Package name for event validation (e.g., com.example.app)
  final String? packageName;

  const DebugHubConfig({
    this.serverURL,
    this.ignoredURLs,
    this.onlyURLs,
    this.ignoredPrefixLogs,
    this.onlyPrefixLogs,
    this.additionalTab,
    this.additionalTabLabel,
    this.additionalTabIcon,
    this.emailToRecipients,
    this.emailCcRecipients,
    this.mainColor = const Color(0xFF42d459),
    this.enableLogMonitoring = true,
    this.enableNetworkMonitoring = true,
    this.enableCrashMonitoring = true,
    this.enableEventMonitoring = true,
    this.enableNotificationMonitoring = true,
    this.maxLogs = 1000,
    this.maxNetworkRequests = 500,
    this.showBubbleOnStart = true,
    this.bubbleAlignment = Alignment.bottomRight,
    this.enablePerformanceMonitoring = true,
    this.packageName,
  });

  DebugHubConfig copyWith({
    String? serverURL,
    List<String>? ignoredURLs,
    List<String>? onlyURLs,
    List<String>? ignoredPrefixLogs,
    List<String>? onlyPrefixLogs,
    Widget? additionalTab,
    String? additionalTabLabel,
    IconData? additionalTabIcon,
    List<String>? emailToRecipients,
    List<String>? emailCcRecipients,
    Color? mainColor,
    bool? enableShakeGesture,
    bool? enableLogMonitoring,
    bool? enableNetworkMonitoring,
    bool? enableCrashMonitoring,
    bool? enableEventMonitoring,
    bool? enableNotificationMonitoring,
    int? maxLogs,
    int? maxNetworkRequests,
    bool? showBubbleOnStart,
    Alignment? bubbleAlignment,
    bool? enablePerformanceMonitoring,
    String? packageName,
  }) {
    return DebugHubConfig(
      serverURL: serverURL ?? this.serverURL,
      ignoredURLs: ignoredURLs ?? this.ignoredURLs,
      onlyURLs: onlyURLs ?? this.onlyURLs,
      ignoredPrefixLogs: ignoredPrefixLogs ?? this.ignoredPrefixLogs,
      onlyPrefixLogs: onlyPrefixLogs ?? this.onlyPrefixLogs,
      additionalTab: additionalTab ?? this.additionalTab,
      additionalTabLabel: additionalTabLabel ?? this.additionalTabLabel,
      additionalTabIcon: additionalTabIcon ?? this.additionalTabIcon,
      emailToRecipients: emailToRecipients ?? this.emailToRecipients,
      emailCcRecipients: emailCcRecipients ?? this.emailCcRecipients,
      mainColor: mainColor ?? this.mainColor,
      enableLogMonitoring: enableLogMonitoring ?? this.enableLogMonitoring,
      enableNetworkMonitoring: enableNetworkMonitoring ?? this.enableNetworkMonitoring,
      enableCrashMonitoring: enableCrashMonitoring ?? this.enableCrashMonitoring,
      enableEventMonitoring: enableEventMonitoring ?? this.enableEventMonitoring,
      enableNotificationMonitoring: enableNotificationMonitoring ?? this.enableNotificationMonitoring,
      maxLogs: maxLogs ?? this.maxLogs,
      maxNetworkRequests: maxNetworkRequests ?? this.maxNetworkRequests,
      showBubbleOnStart: showBubbleOnStart ?? this.showBubbleOnStart,
      bubbleAlignment: bubbleAlignment ?? this.bubbleAlignment,
      enablePerformanceMonitoring: enablePerformanceMonitoring ?? this.enablePerformanceMonitoring,
      packageName: packageName ?? this.packageName,
    );
  }

  bool shouldCaptureURL(String url) {
    if (onlyURLs != null && onlyURLs!.isNotEmpty) {
      return onlyURLs!.any((pattern) => url.contains(pattern));
    }
    if (ignoredURLs != null && ignoredURLs!.isNotEmpty) {
      return !ignoredURLs!.any((pattern) => url.contains(pattern));
    }
    return true;
  }

  bool shouldCaptureLog(String message) {
    if (onlyPrefixLogs != null && onlyPrefixLogs!.isNotEmpty) {
      return onlyPrefixLogs!.any((prefix) => message.startsWith(prefix));
    }
    if (ignoredPrefixLogs != null && ignoredPrefixLogs!.isNotEmpty) {
      return !ignoredPrefixLogs!.any((prefix) => message.startsWith(prefix));
    }
    return true;
  }
}

