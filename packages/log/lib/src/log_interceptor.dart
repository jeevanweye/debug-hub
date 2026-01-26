import 'dart:developer' as developer;
import 'package:base/base.dart';
import 'debug_logger.dart';

class LogInterceptor {
  static final LogInterceptor _instance = LogInterceptor._internal();
  factory LogInterceptor() => _instance;
  LogInterceptor._internal();

  final DebugLogger _logger = DebugLogger();

  void interceptPrint(String message, {String? tag}) {
    _logger.log(
      message,
      level: AppLogLevel.debug,
      tag: tag ?? 'print',
    );
  }

  void interceptDebugPrint(String message, {String? tag}) {
    _logger.log(
      message,
      level: AppLogLevel.debug,
      tag: tag ?? 'debugPrint',
    );
  }

  void interceptDeveloperLog(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    AppLogLevel logLevel;
    if (level >= 1000) {
      logLevel = AppLogLevel.error;
    } else if (level >= 900) {
      logLevel = AppLogLevel.warning;
    } else if (level >= 800) {
      logLevel = AppLogLevel.info;
    } else {
      logLevel = AppLogLevel.debug;
    }

    _logger.log(
      message,
      level: logLevel,
      tag: name.isEmpty ? 'log' : name,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

