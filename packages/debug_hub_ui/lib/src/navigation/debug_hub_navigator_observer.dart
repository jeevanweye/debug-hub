import 'package:flutter/material.dart';

/// NavigatorObserver for DebugHub that stores NavigatorState
/// This allows DebugHub to access Navigator without needing a GlobalKey or BuildContext
/// Similar to how WEChucker works
class DebugHubNavigatorObserver extends NavigatorObserver {
  static final DebugHubNavigatorObserver _instance = DebugHubNavigatorObserver._internal();
  factory DebugHubNavigatorObserver() => _instance;
  DebugHubNavigatorObserver._internal();

  NavigatorState? _navigatorState;

  /// Get the current NavigatorState
  NavigatorState? get navigatorState => _navigatorState;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // NavigatorState is available via the navigator property in NavigatorObserver
    // Store it when we have access
    if (navigator != null) {
      _navigatorState = navigator;
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (navigator != null) {
      _navigatorState = navigator;
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (navigator != null) {
      _navigatorState = navigator;
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (navigator != null) {
      _navigatorState = navigator;
    }
  }
}

