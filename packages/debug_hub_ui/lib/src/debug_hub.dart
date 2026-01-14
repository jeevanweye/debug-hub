import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:base/base.dart';
import 'package:network/network.dart';
import 'package:non_fatal/non_fatal.dart';
import 'package:events/events.dart';
import 'package:notification/notification.dart';
import 'debug_hub_config.dart';
import 'widgets/debug_bubble.dart';
import 'navigation/debug_hub_navigator_observer.dart';

class DebugHub {
  static final DebugHub _instance = DebugHub._internal();
  factory DebugHub() => _instance;
  DebugHub._internal();

  DebugHubConfig _config = const DebugHubConfig();
  bool _isEnabled = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final DebugHubNavigatorObserver _navigatorObserver = DebugHubNavigatorObserver();

  DebugHubConfig get config => _config;
  bool get isEnabled => _isEnabled;
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  
  /// Get the NavigatorObserver for DebugHub
  /// This should be added to MaterialApp's navigatorObservers list
  NavigatorObserver getObserver() => _navigatorObserver;

  /// Initialize DebugHub with configuration synchronously
  /// Returns false if not in debug mode
  bool _init({DebugHubConfig? config}) {

    if (config != null) {
      _config = config;
    }
    
    // Initialize persistent storage asynchronously (non-blocking)
    DebugStorage().initialize().catchError((error) {
      debugPrint('⚠️ DebugHub: Failed to initialize storage: $error');
    });
    
    enable();
    return true;
  }

  /// Enable DebugHub
  /// Returns false if not in debug mode
  bool enable() {

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
    if (!_isEnabled) return;
    await DebugStorage().clearAll();
  }

  /// Wrap your MaterialApp with this to enable DebugHub overlay
  /// This method initializes DebugHub and wraps the child in one call
  /// Only shows in debug mode
  Widget wrap(Widget child, {DebugHubConfig? config}) {
    // Initialize DebugHub if config is provided
    if (config != null) {
      _init(config: config);
    } else if (!_isEnabled) {
      // Initialize with default config if not already enabled
      _init();
    }
    
    // Don't show in release mode or if bubble is disabled
    if (!_isEnabled || !_config.showBubbleOnStart) {
      return child;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        DebugBubble(
          config: _config,
        ),
      ],
    );
  }

  void updateUserProperties(Map<String, dynamic> userProperties,) {
    if (!_isEnabled) return;
    _config = _config.copyWith(userProperties: userProperties);
  }
}

