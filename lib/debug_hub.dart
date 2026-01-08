library debug_hub;

// Main entry point - use DebugHubManager for simplified integration
export 'debug_hub_interface.dart' show DebugHubManager;

// Advanced usage - full API access
export 'package:debug_hub_ui/debug_hub_ui.dart' hide DebugHubConfig;
export 'package:debug_hub_ui/src/debug_hub_config.dart' show DebugHubConfig;

// Core functionality
export 'package:base/base.dart';
export 'package:network/network.dart';
export 'package:log/log.dart';

// Application features (hide UI to avoid conflicts)
export 'package:events/events.dart' hide EventValidationDashboardScreen, EventValidationResultsScreen;
export 'package:notification/notification.dart';
export 'package:non_fatal/non_fatal.dart';
