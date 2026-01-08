# Using DebugHub as a Plugin in Other Flutter Projects

This guide explains how to use DebugHub as a debugging plugin in your Flutter projects.

## 📦 Installation Methods

### Method 1: Copy Packages (Recommended for now)

1. **Copy the packages folder** from DebugHub to your project:
```bash
cp -r /path/to/DebugHub/packages /path/to/your_project/
```

2. **Add to your `pubspec.yaml`**:
```yaml
dependencies:
  debug_hub_ui:
    path: packages/debug_hub_ui
  base:
    path: packages/base
  network:
    path: packages/network
  log:
    path: packages/log
  storage:
    path: packages/storage
  non_fatal:
    path: packages/non_fatal
```

3. **Run**:
```bash
flutter pub get
```

### Method 2: Git Submodule (For teams)

1. **Add as submodule**:
```bash
cd your_project
git submodule add <debughub-repo-url> debug_hub
```

2. **Add to your `pubspec.yaml`**:
```yaml
dependencies:
  debug_hub_ui:
    path: debug_hub/packages/debug_hub_ui
  base:
    path: debug_hub/packages/base
  network:
    path: debug_hub/packages/network
  log:
    path: debug_hub/packages/log
  storage:
    path: debug_hub/packages/storage
  non_fatal:
    path: debug_hub/packages/non_fatal
```

### Method 3: Pub.dev (Future)

Once published to pub.dev:
```yaml
dependencies:
  debug_hub: ^1.0.0
```

## 🚀 Quick Start

### 1. Basic Setup (Debug Mode Only)

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:debug_hub_ui/debug_hub_ui.dart';

void main() {
  // Only enable in debug mode
  if (kDebugMode) {
    DebugHub().init(
      config: const DebugHubConfig(
        mainColor: Color(0xFF42d459),
        enableShakeGesture: true,
        enableLogMonitoring: true,
        enableNetworkMonitoring: true,
        enableCrashMonitoring: true,
      ),
    );
    DebugHub().enable();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      navigatorKey: DebugHub().navigatorKey,
      home: const YourHomePage(),
      builder: (context, child) {
        // Wrap with DebugHub only in debug mode
        if (kDebugMode) {
          return DebugHub().wrap(child ?? const SizedBox.shrink());
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
```

### 2. Network Monitoring Setup

#### For `http` package:

```dart
import 'package:http/http.dart' as http;
import 'package:network/network.dart';

class ApiService {
  final _interceptor = NetworkInterceptor();

  Future<Response> get(String url) async {
    final requestId = _interceptor.captureRequest(
      url: url,
      method: 'GET',
      headers: {'Content-Type': 'application/json'},
    );

    final startTime = DateTime.now();
    
    try {
      final response = await http.get(Uri.parse(url));
      
      _interceptor.captureResponse(
        id: requestId,
        statusCode: response.statusCode,
        responseBody: response.body,
        responseHeaders: response.headers.map((k, v) => MapEntry(k, v)),
        duration: DateTime.now().difference(startTime),
      );
      
      return response;
    } catch (e) {
      _interceptor.captureResponse(
        id: requestId,
        error: e.toString(),
        duration: DateTime.now().difference(startTime),
      );
      rethrow;
    }
  }
}
```

#### For `dio` package:

```dart
import 'package:dio/dio.dart';
import 'package:network/network.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com',
    ));

    // Add DebugHub interceptor
    if (kDebugMode) {
      _dio.interceptors.add(DebugDioInterceptor());
    }
  }

  Future<Response> get(String path) async {
    return await _dio.get(path);
  }
}
```

### 3. Logging Setup

```dart
import 'package:base/base.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static final _storage = DebugStorage();

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      _storage.addLog(
        DebugLog.create(
          level: LogLevel.info,
          message: message,
          tag: tag,
        ),
      );
    }
    debugPrint('[$tag] $message');
  }

  static void error(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      _storage.addLog(
        DebugLog.create(
          level: LogLevel.error,
          message: message,
          tag: tag,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
    debugPrint('ERROR [$tag] $message: $error');
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      _storage.addLog(
        DebugLog.create(
          level: LogLevel.warning,
          message: message,
          tag: tag,
        ),
      );
    }
    debugPrint('WARNING [$tag] $message');
  }
}

// Usage
Logger.info('User logged in', tag: 'Auth');
Logger.error('Failed to fetch data', tag: 'API', error: exception);
```

### 4. Crash Reporting Setup

```dart
import 'package:flutter/foundation.dart';
import 'package:non_fatal/non_fatal.dart';

void main() {
  if (kDebugMode) {
    DebugHub().init();
    DebugHub().enable();
  }

  // Catch all errors
  FlutterError.onError = (details) {
    if (kDebugMode) {
      CrashHandler().reportError(
        details.exception,
        stackTrace: details.stack,
        context: details.context?.toString(),
        isFatal: false,
      );
    }
    // Also send to your production crash reporting (Firebase, Sentry, etc.)
  };

  runApp(const MyApp());
}
```

## 🎯 Real-World Integration Examples

### Example 1: E-commerce App

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:debug_hub_ui/debug_hub_ui.dart';

void main() {
  if (kDebugMode) {
    DebugHub().init(
      config: DebugHubConfig(
        serverURL: 'https://api.myshop.com',
        ignoredURLs: [
          'https://analytics.google.com',
          'https://firebaseinstallations.googleapis.com',
        ],
        mainColor: const Color(0xFF2196F3),
        emailToRecipients: ['dev@myshop.com'],
      ),
    );
    DebugHub().enable();
  }

  runApp(const MyShopApp());
}
```

### Example 2: Social Media App

```dart
void main() {
  if (kDebugMode) {
    DebugHub().init(
      config: DebugHubConfig(
        serverURL: 'https://api.mysocial.com',
        onlyURLs: [
          'https://api.mysocial.com',
        ],
        ignoredPrefixLogs: [
          '[ANALYTICS]',
          '[TRACKING]',
        ],
        mainColor: const Color(0xFFE91E63),
      ),
    );
    DebugHub().enable();
  }

  runApp(const MySocialApp());
}
```

### Example 3: Custom Debug Tab

```dart
class CustomDebugTab extends StatelessWidget {
  const CustomDebugTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Custom Debug Information'),
        // Add your custom debug UI here
        ElevatedButton(
          onPressed: () {
            // Custom debug action
          },
          child: const Text('Run Custom Test'),
        ),
      ],
    );
  }
}

void main() {
  if (kDebugMode) {
    DebugHub().init(
      config: DebugHubConfig(
        additionalTab: const CustomDebugTab(),
        additionalTabLabel: 'Custom',
        additionalTabIcon: Icons.settings,
      ),
    );
    DebugHub().enable();
  }

  runApp(const MyApp());
}
```

## 🔒 Security Best Practices

### 1. Never Enable in Production

```dart
// ✅ Good
void main() {
  if (kDebugMode) {
    DebugHub().enable();
  }
  runApp(const MyApp());
}

// ❌ Bad
void main() {
  DebugHub().enable(); // Always enabled!
  runApp(const MyApp());
}
```

### 2. Use Build Flavors

```dart
// main_dev.dart
void main() {
  DebugHub().enable();
  runApp(const MyApp());
}

// main_prod.dart
void main() {
  // No DebugHub
  runApp(const MyApp());
}
```

### 3. Sanitize Sensitive Data

```dart
final interceptor = NetworkInterceptor();

// Before capturing
if (headers.containsKey('Authorization')) {
  headers['Authorization'] = '***REDACTED***';
}

interceptor.captureRequest(
  url: url,
  method: 'POST',
  headers: headers,
  body: body,
);
```

## 🎨 Customization Tips

### 1. Match Your App's Theme

```dart
DebugHub().init(
  config: DebugHubConfig(
    mainColor: Theme.of(context).primaryColor,
  ),
);
```

### 2. Position the Bubble

```dart
DebugHub().init(
  config: const DebugHubConfig(
    bubbleAlignment: Alignment.bottomLeft, // or topRight, etc.
  ),
);
```

### 3. Adjust Limits

```dart
DebugHub().init(
  config: const DebugHubConfig(
    maxLogs: 2000,
    maxNetworkRequests: 1000,
  ),
);
```

## 🐛 Troubleshooting

### Issue: Bubble not showing

**Solution**: Make sure you're wrapping your app and running in debug mode:
```dart
if (kDebugMode) {
  app = DebugHub().wrap(app);
}
```

### Issue: Network requests not captured

**Solution**: Ensure you're using the interceptor:
```dart
// For http
final interceptor = NetworkInterceptor();
interceptor.captureRequest(...);

// For dio
dio.interceptors.add(DebugDioInterceptor());
```

### Issue: Logs not appearing

**Solution**: Make sure log monitoring is enabled:
```dart
DebugHub().init(
  config: const DebugHubConfig(
    enableLogMonitoring: true,
  ),
);
```

## 📱 Platform-Specific Notes

### Android
- Shake gesture works on physical devices and emulators
- Storage browser shows app's internal storage

### iOS
- Shake gesture works on physical devices
- Use Hardware > Shake in simulator
- Storage browser shows app's documents directory

## 🚀 Performance Tips

1. **Disable in release builds** - Always use `kDebugMode` check
2. **Set reasonable limits** - Don't store thousands of requests
3. **Clear data regularly** - Use long press on bubble to clear
4. **Filter URLs** - Ignore analytics and tracking URLs

## 📚 Additional Resources

- [Main README](README.md) - Complete documentation
- [Example App](lib/main.dart) - Working example
- [Package Structure](README.md#-architecture) - Understanding the architecture

## 💡 Pro Tips

1. **Share with QA**: Use the share button to send debug data to your QA team
2. **Custom Tags**: Use meaningful tags in logs for easy filtering
3. **Server URL**: Set your API base URL to highlight it in requests
4. **Email Recipients**: Configure default recipients for quick bug reports
5. **Shake to Hide**: Shake device to hide bubble during screenshots

---

Happy Debugging! 🐛🔍

