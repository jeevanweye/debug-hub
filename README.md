# DebugHub 🚀

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
</p>

**DebugHub** is a comprehensive Flutter debugging tool inspired by [CocoaDebug](https://github.com/CocoaDebug/CocoaDebug) for iOS. It provides an in-app debugging interface that helps developers monitor network requests, logs, crashes, storage, and device information - all without leaving your app!

## ✨ Features

### 🌐 Network Monitoring
- **Capture all HTTP/HTTPS requests** (supports `http` and `dio` packages)
- View request/response headers and bodies
- Beautiful JSON formatting
- Filter by status (success, error, pending)
- Search by URL or method
- Share network logs via email or copy to clipboard
- Request/response size tracking
- Duration measurement

### 📝 Log Management
- Capture all app logs with different levels (verbose, debug, info, warning, error, wtf)
- Filter logs by level
- Search logs by keyword or tag
- Long press to view full log details with stack traces
- Copy logs to clipboard
- Share logs via email

### 💥 Crash Reporting
- Automatic crash detection
- Stack trace capture
- Manual crash reporting
- View crash history
- Share crash reports

### 📁 Storage Browser
- Browse app documents directory
- View file sizes
- Navigate through folders
- Storage usage statistics

### 📱 Device & App Information
- App version and build number
- Device model and OS version
- Platform information
- Flutter and Dart version
- Copy any info to clipboard

### 🎯 User Experience
- **Floating bubble** - Draggable debug button, always visible in debug mode
- **Long press bubble** - Clear all debug data
- **Beautiful UI** - Modern Material Design 3
- **Customizable theme** - Set your own main color
- **No performance impact** - Lightweight and efficient
- **Optional shake gesture** - Can be enabled to show/hide bubble

## 📸 Screenshots

*Coming soon - Run the app to see it in action!*

## 🚀 Getting Started

### Installation

#### As a Plugin in Your Flutter Project

1. **Copy the DebugHub packages** to your project:
```bash
# Copy the entire packages folder to your project
cp -r packages/ your_project/packages/
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

### Basic Usage

#### 1. Initialize DebugHub in your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:debug_hub_ui/debug_hub_ui.dart';

void main() {
  // Initialize DebugHub with configuration
  DebugHub().init(
    config: const DebugHubConfig(
      serverURL: 'https://api.yourserver.com', // Optional: Highlight your server URL
      mainColor: Color(0xFF42d459), // Optional: Customize theme color
      enableShakeGesture: false, // Keep bubble always visible (default)
      enableLogMonitoring: true,
      enableNetworkMonitoring: true,
      enableCrashMonitoring: true,
      showBubbleOnStart: true,
    ),
  );

  // Enable DebugHub
  DebugHub().enable();

  runApp(const MyApp());
}
```

#### 2. Wrap your app with DebugHub:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      navigatorKey: DebugHub().navigatorKey,
      home: const YourHomePage(),
      builder: (context, child) {
        return DebugHub().wrap(child ?? const SizedBox.shrink());
      },
    );
  }
}
```

That's it! The floating debug bubble will appear in your app.

## 📚 Advanced Usage

### Network Monitoring

#### Using with `http` package:

```dart
import 'package:network/network.dart';
import 'package:http/http.dart' as http;

final networkInterceptor = NetworkInterceptor();

Future<void> makeRequest() async {
  // Capture request
  final requestId = networkInterceptor.captureRequest(
    url: 'https://api.example.com/data',
    method: 'GET',
    headers: {'Content-Type': 'application/json'},
  );

  final startTime = DateTime.now();
  
  // Make actual request
  final response = await http.get(
    Uri.parse('https://api.example.com/data'),
  );

  // Capture response
  networkInterceptor.captureResponse(
    id: requestId,
    statusCode: response.statusCode,
    responseBody: response.body,
    responseHeaders: response.headers.map((k, v) => MapEntry(k, v)),
    duration: DateTime.now().difference(startTime),
  );
}
```

#### Using with `dio` package:

```dart
import 'package:dio/dio.dart';
import 'package:network/network.dart';

final dio = Dio();
dio.interceptors.add(DebugDioInterceptor());

// All requests will be automatically captured
final response = await dio.get('https://api.example.com/data');
```

### Logging

```dart
import 'package:base/base.dart';

final storage = DebugStorage();

// Add different log levels
storage.addLog(
  DebugLog.create(
    level: LogLevel.info,
    message: 'User logged in successfully',
    tag: 'Auth',
  ),
);

storage.addLog(
  DebugLog.create(
    level: LogLevel.error,
    message: 'Failed to load data',
    tag: 'API',
    error: exception,
    stackTrace: stackTrace,
  ),
);
```

### Crash Reporting

```dart
import 'package:non_fatal/non_fatal.dart';

// Manual crash reporting
CrashHandler().reportError(
  error,
  stackTrace: stackTrace,
  context: 'User action context',
  isFatal: false,
);
```

## ⚙️ Configuration Options

```dart
DebugHubConfig(
  // Server URL to highlight in network requests
  serverURL: 'https://api.yourserver.com',
  
  // URLs to ignore from capturing
  ignoredURLs: ['https://analytics.com'],
  
  // Only capture these URLs
  onlyURLs: ['https://api.yourserver.com'],
  
  // Log prefixes to ignore
  ignoredPrefixLogs: ['[VERBOSE]'],
  
  // Only capture logs with these prefixes
  onlyPrefixLogs: ['[APP]'],
  
  // Add custom tab
  additionalTab: YourCustomWidget(),
  additionalTabLabel: 'Custom',
  additionalTabIcon: Icons.extension,
  
  // Email recipients for sharing
  emailToRecipients: ['dev@example.com'],
  emailCcRecipients: ['qa@example.com'],
  
  // Theme color
  mainColor: Color(0xFF42d459),
  
  // Feature toggles
  enableShakeGesture: true,
  enableLogMonitoring: true,
  enableNetworkMonitoring: true,
  enableCrashMonitoring: true,
  showBubbleOnStart: true,
  
  // Limits
  maxLogs: 1000,
  maxNetworkRequests: 500,
  
  // Bubble position
  bubbleAlignment: Alignment.bottomRight,
  
  // Performance monitoring
  enablePerformanceMonitoring: true,
)
```

## 🏗️ Architecture

DebugHub is built with a modular architecture:

```
packages/
├── base/              # Core models and storage
│   ├── models/        # Data models (NetworkRequest, DebugLog, CrashReport)
│   ├── storage/       # In-memory storage
│   └── utils/         # Utilities (JSON formatter, date formatter)
├── network/           # Network monitoring
│   ├── interceptors/  # HTTP and Dio interceptors
│   └── handlers/      # Request/response handling
├── log/               # Log capture
│   └── interceptors/  # Log interception
├── storage/           # File browser
│   └── utils/         # File system utilities
├── non_fatal/         # Crash reporting
│   └── handlers/      # Error handlers
└── debug_hub_ui/      # UI components
    ├── screens/       # All UI screens
    ├── widgets/       # Reusable widgets
    └── config/        # Configuration
```

## 🎯 Use Cases

### Development
- Debug network issues in real-time
- Monitor app logs without connecting to IDE
- Test error handling
- Inspect app storage

### QA Testing
- Share detailed bug reports with network logs
- Capture crash information
- Verify API responses
- Check device-specific issues

### Production Debugging (Debug builds only)
- Investigate user-reported issues
- Monitor network performance
- Track error patterns

## ⚠️ Important Notes

1. **Never ship DebugHub in production builds!** Always use it only in debug mode:
```dart
void main() {
  if (kDebugMode) {
    DebugHub().init();
    DebugHub().enable();
  }
  runApp(const MyApp());
}
```

2. **Performance**: DebugHub is designed to be lightweight, but it does store data in memory. Use the provided limits to prevent memory issues.

3. **Privacy**: Be careful when sharing debug data - it may contain sensitive information like API keys or user data.

## 🔧 Development

### Running the Example App

```bash
# Clone the repository
git clone <your-repo-url>
cd DebugHub

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Building for Release

Make sure to disable DebugHub in release builds:

```dart
import 'package:flutter/foundation.dart';

void main() {
  if (kDebugMode) {
    DebugHub().init();
    DebugHub().enable();
  }
  runApp(const MyApp());
}
```

## 📦 Package Structure

- **base**: Core functionality and data models
- **network**: Network request interception and monitoring
- **log**: Log capture and management
- **storage**: File system browser
- **non_fatal**: Crash and error reporting
- **events**: Event tracking (future feature)
- **notification**: Notification monitoring (future feature)
- **debug_hub_ui**: Main UI package with all screens and widgets

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Inspired by [CocoaDebug](https://github.com/CocoaDebug/CocoaDebug) for iOS
- Built with ❤️ using Flutter

## 📞 Support

If you have any questions or issues, please open an issue on GitHub.

---

## 🎨 Customization Examples

### Custom Theme
```dart
DebugHub().init(
  config: DebugHubConfig(
    mainColor: Color(0xFFFF5722), // Orange theme
  ),
);
```

### Filter Specific URLs
```dart
DebugHub().init(
  config: DebugHubConfig(
    serverURL: 'https://api.myapp.com',
    ignoredURLs: [
      'https://analytics.google.com',
      'https://crashlytics.com',
    ],
  ),
);
```

### Add Custom Tab
```dart
DebugHub().init(
  config: DebugHubConfig(
    additionalTab: MyCustomDebugScreen(),
    additionalTabLabel: 'Custom',
    additionalTabIcon: Icons.settings,
  ),
);
```

## 🚦 Roadmap

- [ ] WebSocket monitoring
- [ ] GraphQL support
- [ ] Performance metrics
- [ ] Memory profiling
- [ ] Widget inspector
- [ ] Timeline view
- [ ] Export to file
- [ ] Remote debugging
- [ ] Plugin system

## 💡 Tips

1. **Always Visible**: The debug bubble stays visible in debug mode for easy access
2. **Long Press**: Long press the bubble to clear all debug data
3. **Search**: Use the search feature in Network and Logs tabs to quickly find what you need
4. **Share**: Use the share button to send debug data via email or other apps
5. **Copy**: Tap the copy icon to copy specific data to clipboard
6. **Optional Shake**: Set `enableShakeGesture: true` if you want to hide/show bubble with shake

---

Made with 💚 for Flutter developers
