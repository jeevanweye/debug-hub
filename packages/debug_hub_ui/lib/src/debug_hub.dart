import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:base/base.dart';
import 'package:network/network.dart';
import 'package:non_fatal/non_fatal.dart';
import 'package:events/events.dart';
import 'package:notification/notification.dart';
import 'debug_hub_config.dart';
import 'widgets/debug_bubble.dart';

class DebugHub {
  static final DebugHub _instance = DebugHub._internal();
  factory DebugHub() => _instance;
  DebugHub._internal();

  DebugHubConfig _config = const DebugHubConfig();
  bool _isEnabled = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  DebugHubConfig get config => _config;
  bool get isEnabled => _isEnabled;
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// Initialize DebugHub with configuration
  /// Returns false if not in debug mode
  Future<bool> init({DebugHubConfig? config}) async {
    // Only allow in debug mode
    if (!kDebugMode) {
      debugPrint('⚠️ DebugHub can only be used in debug mode');
      return false;
    }

    _config = config ?? const DebugHubConfig();
    
    // Initialize persistent storage
    await DebugStorage().initialize();
    
    return true;
  }

  /// Enable DebugHub
  /// Returns false if not in debug mode
  bool enable() {
    // Enforce debug mode only
    if (!kDebugMode) {
      return false;
    }

    if (_isEnabled) return true;
    
    _isEnabled = true;

    // Enable network monitoring
    if (_config.enableNetworkMonitoring) {
      NetworkInterceptor().enable();
    }

    // Enable log monitoring
    if (_config.enableLogMonitoring) {
      // Log monitoring will be handled by the log package
    }

    // Enable crash monitoring
    if (_config.enableCrashMonitoring) {
      CrashHandler().enable();
    }

    // Enable event monitoring
    if (_config.enableEventMonitoring) {
      EventTracker().enable();
    }

    // Enable notification monitoring
    if (_config.enableNotificationMonitoring) {
      NotificationLogger().enable();
    }

    debugPrint('🚀 DebugHub enabled (Debug Mode Only)');
    return true;
  }

  /// Disable DebugHub
  void disable() {
    _isEnabled = false;
    NetworkInterceptor().disable();
    EventTracker().disable();
    NotificationLogger().disable();
    debugPrint('🛑 DebugHub disabled');
  }

  /// Clear all debug data including persistent storage
  Future<void> clearAll() async {
    await DebugStorage().clearAll();
  }

  /// Wrap your MaterialApp with this to enable DebugHub overlay
  /// Only shows in debug mode
  Widget wrap(Widget child) {
    // Don't show in release mode
    if (!kDebugMode || !_isEnabled || !_config.showBubbleOnStart) {
      return child;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        DebugBubble(
          config: _config,
          navigatorKey: _navigatorKey,
        ),
      ],
    );
  }
}

