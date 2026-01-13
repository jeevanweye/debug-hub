import 'package:base/base.dart';
import 'package:flutter/foundation.dart';

class DebugLogger {
  static final DebugLogger _instance = DebugLogger._internal();
  factory DebugLogger() => _instance;
  DebugLogger._internal();

  final DebugStorage _storage = DebugStorage();
  bool _isEnabled = false;

  void enable() {
    _isEnabled = true;
  }

  void disable() {
    _isEnabled = false;
  }

  bool get isEnabled => _isEnabled;

  void log(
    String message, {
    AppLogLevel level = AppLogLevel.debug,
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    if (!_isEnabled) return;

    final debugLog = DebugLog.create(
      level: level,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );

    _storage.addLog(debugLog);

    // Also print to console in debug mode
    debugPrint(debugLog.toString());
  }

  void verbose(String message, {String? tag, Map<String, dynamic>? metadata}) {
    log(message, level: AppLogLevel.verbose, tag: tag, metadata: metadata);
  }

  void debug(String message, {String? tag, Map<String, dynamic>? metadata}) {
    log(message, level: AppLogLevel.debug, tag: tag, metadata: metadata);
  }

  void info(String message, {String? tag, Map<String, dynamic>? metadata}) {
    log(message, level: AppLogLevel.info, tag: tag, metadata: metadata);
  }

  void warning(String message, {String? tag, Map<String, dynamic>? metadata}) {
    log(message, level: AppLogLevel.warning, tag: tag, metadata: metadata);
  }

  void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    log(
      message,
      level: AppLogLevel.error,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );
  }

  void wtf(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    log(
      message,
      level: AppLogLevel.wtf,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );
  }

  List<DebugLog> getLogs() => _storage.getLogs();

  void clearLogs() => _storage.clearLogs();
}

