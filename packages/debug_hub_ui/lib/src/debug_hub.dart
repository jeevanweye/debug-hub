import 'package:flutter/material.dart';
import 'package:base/base.dart';
import 'package:network/network.dart';
import 'package:non_fatal/non_fatal.dart';
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
  void init({DebugHubConfig? config}) {
    _config = config ?? const DebugHubConfig();
  }

  /// Enable DebugHub
  void enable() {
    if (_isEnabled) return;
    
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

    debugPrint('🚀 DebugHub enabled');
  }

  /// Disable DebugHub
  void disable() {
    _isEnabled = false;
    NetworkInterceptor().disable();
    debugPrint('🛑 DebugHub disabled');
  }

  /// Clear all debug data
  void clearAll() {
    DebugStorage().clearAll();
  }

  /// Wrap your MaterialApp with this to enable DebugHub overlay
  Widget wrap(Widget child) {
    if (!_isEnabled || !_config.showBubbleOnStart) return child;

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

