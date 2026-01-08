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
      level: LogLevel.debug,
      tag: tag ?? 'print',
    );
  }

  void interceptDebugPrint(String message, {String? tag}) {
    _logger.log(
      message,
      level: LogLevel.debug,
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
    LogLevel logLevel;
    if (level >= 1000) {
      logLevel = LogLevel.error;
    } else if (level >= 900) {
      logLevel = LogLevel.warning;
    } else if (level >= 800) {
      logLevel = LogLevel.info;
    } else {
      logLevel = LogLevel.debug;
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

