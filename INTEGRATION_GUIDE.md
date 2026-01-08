# DebugHub - Integration Guide

A comprehensive Flutter debugging tool with minimal integration code.

## 🚀 Quick Start (3 Steps)

### Step 1: Add Dependency

Add to your `pubspec.yaml`:

```yaml
dependencies:
  debug_hub:
    path: ../DebugHub  # or your path
```

### Step 2: Initialize in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:debug_hub/debug_hub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DebugHub (only in debug mode)
  await DebugHubManager.initialize();
  
  runApp(DebugHubManager.wrap(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomeScreen(),
    );
  }
}
```

### Step 3: That's it! 🎉

DebugHub is now active. You'll see a floating debug bubble on your screen.

---

## 📱 Features

- ✅ **Network Monitoring** - Automatically captures all HTTP requests
- ✅ **Log Tracking** - View all app logs in one place
- ✅ **Crash Reporting** - Track non-fatal crashes
- ✅ **Event Tracking** - Monitor analytics events
- ✅ **Notification Logging** - Track notifications received and tapped
- ✅ **Device Info** - View device and app information

---

## 🎨 Customization

### Custom Configuration

```dart
await DebugHubManager.initialize(
  serverURL: 'https://api.example.com',  // Highlight your API
  mainColor: Colors.blue,                 // Custom theme color
  showBubbleOnStart: true,                // Show bubble on start
  enableShakeGesture: false,              // Shake to toggle bubble
  ignoredURLs: [                          // URLs to ignore
    'analytics.google.com',
    'crashlytics.com',
  ],
);
```

### Advanced Configuration

For more control, use the full API:

```dart
import 'package:debug_hub/debug_hub.dart';

final config = DebugHubConfig(
  serverURL: 'https://api.example.com',
  ignoredURLs: ['analytics.google.com'],
  onlyURLs: ['api.example.com'],  // Only capture these URLs
  mainColor: Colors.purple,
  enableNetworkMonitoring: true,
  enableLogMonitoring: true,
  enableCrashMonitoring: true,
  enableEventMonitoring: true,
  enableNotificationMonitoring: true,
  maxLogs: 1000,
  maxNetworkRequests: 500,
  showBubbleOnStart: true,
  bubbleAlignment: Alignment.bottomRight,
);

await DebugHub().initialize(config: config);
DebugHub().enable();
```

---

## 📝 Manual Logging

### Log Messages

```dart
import 'package:debug_hub/debug_hub.dart';

// Simple log
DebugHubManager.log('User logged in');

// Log with tag
DebugHubManager.log('Payment processed', tag: 'Payment');

// Log error
DebugHubManager.logError(
  'Failed to load data',
  error: e,
  stackTrace: stackTrace,
  tag: 'API',
);
```

### Track Events

```dart
// Track analytics event
DebugHubManager.trackEvent(
  'button_click',
  properties: {
    'screen': 'home',
    'button': 'submit',
  },
  source: 'Firebase',
);
```

### Log Notifications

```dart
// When notification is received
DebugHubManager.logNotification(
  title: 'New Message',
  body: 'You have a new message',
  payload: {'message_id': '123'},
  notificationId: 'notification_123',
);

// When notification is tapped
DebugHubManager.logNotificationTap(
  notificationId: 'notification_123',
  title: 'New Message',
);
```

### Report Crashes

```dart
try {
  // Your code
} catch (e, stackTrace) {
  DebugHubManager.reportCrash(e, stackTrace);
}
```

---

## 🔌 Automatic Integrations

### Network Monitoring (Dio)

DebugHub automatically captures Dio requests:

```dart
import 'package:dio/dio.dart';
import 'package:network/network.dart';

final dio = Dio();
dio.interceptors.add(DebugHubDioInterceptor());

// All requests are now logged automatically
final response = await dio.get('https://api.example.com/users');
```

### Firebase Cloud Messaging

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:debug_hub/debug_hub.dart';

FirebaseMessaging.onMessage.listen((message) {
  DebugHubManager.logNotification(
    title: message.notification?.title,
    body: message.notification?.body,
    payload: message.data,
    notificationId: message.messageId,
  );
});

FirebaseMessaging.onMessageOpenedApp.listen((message) {
  DebugHubManager.logNotificationTap(
    notificationId: message.messageId ?? 'unknown',
    title: message.notification?.title,
    payload: message.data,
  );
});
```

### Error Handling

```dart
import 'package:flutter/material.dart';
import 'package:debug_hub/debug_hub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Catch Flutter errors
  FlutterError.onError = (details) {
    DebugHubManager.reportCrash(
      details.exception,
      details.stack,
    );
  };
  
  await DebugHubManager.initialize();
  runApp(DebugHubManager.wrap(MyApp()));
}
```

---

## 🎯 Usage Examples

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:debug_hub/debug_hub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DebugHub
  await DebugHubManager.initialize(
    serverURL: 'https://api.myapp.com',
    mainColor: Colors.teal,
  );
  
  // Catch errors
  FlutterError.onError = (details) {
    DebugHubManager.reportCrash(details.exception, details.stack);
  };
  
  runApp(DebugHubManager.wrap(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Log event
            DebugHubManager.trackEvent('button_click', properties: {
              'screen': 'home',
              'action': 'submit',
            });
            
            // Log message
            DebugHubManager.log('Button clicked', tag: 'UI');
            
            // Show success
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logged to DebugHub')),
            );
          },
          child: Text('Click Me'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => DebugHubManager.show(context),
        child: Icon(Icons.bug_report),
        tooltip: 'Open DebugHub',
      ),
    );
  }
}
```

---

## 🛠️ API Reference

### DebugHubManager

#### Initialization

```dart
static Future<void> init({
  String? serverURL,
  List<String>? ignoredURLs,
  Color? mainColor,
  bool enableShakeGesture = false,
  bool showBubbleOnStart = true,
})
```

#### Logging

```dart
static void log(String message, {String? tag, LogLevel level})
static void logError(String message, {dynamic error, StackTrace? stackTrace, String? tag})
```

#### Events

```dart
static void trackEvent(String name, {Map<String, dynamic>? properties, String? source})
```

#### Notifications

```dart
static void logNotification({String? title, String? body, Map<String, dynamic>? payload, String? notificationId})
static void logNotificationTap({required String notificationId, String? title, String? body, Map<String, dynamic>? payload})
```

#### Crashes

```dart
static void reportCrash(dynamic error, StackTrace? stackTrace)
```

#### Utilities

```dart
static Widget wrap(Widget app)
static void show(BuildContext context)
static Future<void> clearAll()
```

---

## 📦 What's Included

### Packages

- **base** - Core models and storage
- **network** - Network monitoring
- **log** - Log tracking
- **events** - Event tracking
- **notification** - Notification logging
- **non_fatal** - Crash reporting
- **debug_hub_ui** - UI components

### UI Features

- 📱 Bottom navigation with 6 tabs
- 🔍 Search and filter in all tabs
- 📤 Share functionality
- 🗑️ Clear data
- 🎨 Customizable theme
- 💾 Persistent storage

---

## 🎓 Best Practices

1. **Initialize Early**: Call `init()` before `runApp()`
2. **Wrap Your App**: Use `wrap()` to enable the debug bubble
3. **Use Tags**: Add tags to logs for better organization
4. **Track Events**: Log important user actions
5. **Report Crashes**: Always report non-fatal errors
6. **Test in Debug**: DebugHub only works in debug mode

---

## 🚫 Production Safety

DebugHub automatically disables itself in release builds. No need to remove code!

```dart
// This is safe in production - DebugHub won't run
await DebugHubManager.initialize();
runApp(DebugHubManager.wrap(MyApp()));
```

---

## 🆘 Troubleshooting

### Bubble Not Showing

- Ensure you're in debug mode
- Check `showBubbleOnStart: true` in config
- Try calling `DebugHub().enable()`

### Network Requests Not Captured

- Add `DebugHubDioInterceptor()` to Dio
- Check `enableNetworkMonitoring: true` in config

### Logs Not Appearing

- Use `DebugHubManager.log()` instead of `print()`
- Check `enableLogMonitoring: true` in config

---

## 📄 License

MIT License

---

## 🤝 Support

For issues or questions, refer to the documentation in each package.

---

**That's it! You're ready to debug like a pro! 🚀**

