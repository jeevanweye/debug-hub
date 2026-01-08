import 'dart:async';
import 'package:flutter/widgets.dart';
import 'crash_handler.dart';

class ErrorCatcher {
  static final ErrorCatcher _instance = ErrorCatcher._internal();
  factory ErrorCatcher() => _instance;
  ErrorCatcher._internal();

  final CrashHandler _crashHandler = CrashHandler();

  /// Run app with error catching
  void runAppWithErrorCatching(Widget app) {
    runZonedGuarded(
      () {
        WidgetsFlutterBinding.ensureInitialized();
        runApp(app);
      },
      (error, stackTrace) {
        _crashHandler.reportError(
          error,
          stackTrace: stackTrace,
          context: 'Uncaught Zone Error',
          isFatal: true,
        );
      },
    );
  }

  /// Wrap a future with error catching
  Future<T> catchFutureError<T>(
    Future<T> Function() future, {
    String? context,
  }) async {
    try {
      return await future();
    } catch (error, stackTrace) {
      _crashHandler.reportError(
        error,
        stackTrace: stackTrace,
        context: context,
      );
      rethrow;
    }
  }

  /// Wrap a function with error catching
  T catchError<T>(
    T Function() function, {
    String? context,
  }) {
    try {
      return function();
    } catch (error, stackTrace) {
      _crashHandler.reportError(
        error,
        stackTrace: stackTrace,
        context: context,
      );
      rethrow;
    }
  }
}

