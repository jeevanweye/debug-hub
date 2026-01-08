import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'log_interceptor.dart';

class ConsoleOverride {
  static final ConsoleOverride _instance = ConsoleOverride._internal();
  factory ConsoleOverride() => _instance;
  ConsoleOverride._internal();

  final LogInterceptor _interceptor = LogInterceptor();
  DebugPrintCallback? _originalDebugPrint;
  bool _isEnabled = false;

  void enable() {
    if (_isEnabled) return;
    _isEnabled = true;

    // Override debugPrint
    _originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) {
        _interceptor.interceptDebugPrint(message);
      }
      _originalDebugPrint?.call(message, wrapWidth: wrapWidth);
    };

    // Note: We cannot override print() directly as it's a top-level function
    // Users should use debugPrint or our DebugLogger instead
  }

  void disable() {
    if (!_isEnabled) return;
    _isEnabled = false;

    if (_originalDebugPrint != null) {
      debugPrint = _originalDebugPrint!;
      _originalDebugPrint = null;
    }
  }

  bool get isEnabled => _isEnabled;
}

