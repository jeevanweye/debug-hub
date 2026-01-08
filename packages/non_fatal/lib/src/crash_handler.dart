import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:base/base.dart';

class CrashHandler {
  static final CrashHandler _instance = CrashHandler._internal();
  factory CrashHandler() => _instance;
  CrashHandler._internal();

  final DebugStorage _storage = DebugStorage();
  bool _isEnabled = false;
  FlutterExceptionHandler? _originalOnError;
  bool Function(Object, StackTrace)? _originalOnPlatformError;

  void enable() {
    if (_isEnabled) return;
    _isEnabled = true;

    // Catch Flutter framework errors
    _originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
      _originalOnError?.call(details);
    };

    // Catch errors outside Flutter framework (async errors)
    _originalOnPlatformError = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return _originalOnPlatformError?.call(error, stack) ?? false;
    };
  }

  void disable() {
    if (!_isEnabled) return;
    _isEnabled = false;

    if (_originalOnError != null) {
      FlutterError.onError = _originalOnError;
      _originalOnError = null;
    }

    if (_originalOnPlatformError != null) {
      PlatformDispatcher.instance.onError = _originalOnPlatformError;
      _originalOnPlatformError = null;
    }
  }

  bool get isEnabled => _isEnabled;

  void _handleFlutterError(FlutterErrorDetails details) {
    final report = CrashReport.create(
      error: details.exception.toString(),
      stackTrace: details.stack,
      context: details.context?.toString(),
      isFatal: details.silent == false,
    );
    _storage.addCrashReport(report);
  }

  void _handlePlatformError(Object error, StackTrace stack) {
    final report = CrashReport.create(
      error: error.toString(),
      stackTrace: stack,
      context: 'Platform Error',
      isFatal: true,
    );
    _storage.addCrashReport(report);
  }

  void reportError(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
    bool isFatal = false,
  }) {
    if (!_isEnabled) return;

    final report = CrashReport.create(
      error: error.toString(),
      stackTrace: stackTrace,
      context: context,
      isFatal: isFatal,
    );
    _storage.addCrashReport(report);
  }

  List<CrashReport> getCrashReports() => _storage.getCrashReports();

  void clearCrashReports() => _storage.clearCrashReports();
}

