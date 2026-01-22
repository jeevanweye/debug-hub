# DebugHub 🐛

**A comprehensive Flutter debugging and monitoring toolkit built with Clean Architecture and SOLID Principles**

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.9+-blue.svg" alt="Flutter Version">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Architecture-Clean-brightgreen.svg" alt="Clean Architecture">
  <img src="https://img.shields.io/badge/SOLID-Principles-blue.svg" alt="SOLID Principles">
</p>

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Why DebugHub?](#-why-debughub)
- [Features](#-features)
- [Quick Start](#-quick-start)
- [Installation](#-installation)
- [Usage Examples](#-usage-examples)
- [Advanced Features](#-advanced-features)
- [Integration Guide](#-integration-guide)
- [API Reference](#-api-reference)
- [Architecture](#-architecture)
- [Benefits](#-benefits)
- [Production Safety](#-production-safety)
- [Best Practices](#-best-practices)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

DebugHub is an enterprise-grade debugging and monitoring solution for Flutter applications that provides comprehensive insights into your app's behavior during development. With **just 3 lines of code**, you can integrate a powerful debugging toolkit that captures network requests, logs, crashes, analytics events, notifications, and much more.

Built with **Clean Architecture** and following **SOLID Principles**, DebugHub is designed to be maintainable, testable, and easily extensible.

---

## 💡 Why DebugHub?

### The Problem
During development, developers often struggle with:
- 🔍 **Debugging network requests** - Hard to inspect API calls and responses
- 📝 **Tracking logs** - Scattered across console, making it difficult to filter and search
- 💥 **Monitoring crashes** - Non-fatal errors often go unnoticed
- 📊 **Validating analytics** - No easy way to verify event tracking
- 🔔 **Testing notifications** - Difficult to see notification payloads and behavior
- 🎯 **Device information** - Hard to access device/app info during testing

### The Solution
DebugHub provides a **unified debugging interface** that:
- ✅ Captures everything automatically with minimal setup
- ✅ Provides a beautiful, intuitive UI accessible via floating bubble
- ✅ Persists data across app restarts
- ✅ Works seamlessly with popular packages (Dio, Firebase, etc.)
- ✅ Automatically disables in production builds
- ✅ Requires NO code removal for production

---

## ✨ Features

### 🌐 Network Monitoring
- **Automatic capture** of all HTTP/HTTPS requests and responses
- **Request details**: URL, method, headers, body
- **Response details**: Status code, headers, body, duration
- **cURL export**: Share requests as cURL commands
- **Search & filter**: Find specific requests quickly
- **Dio & HTTP support**: Works with popular networking packages

### 📝 Comprehensive Logging
- **Multiple log levels**: Verbose, Debug, Info, Warning, Error, WTF
- **Tag-based organization**: Categorize logs for easy filtering
- **Stack trace capture**: Full error context
- **Search functionality**: Find logs instantly
- **Persistent storage**: Logs survive app restarts
- **Export capability**: Share logs easily

### 💥 Crash Reporting
- **Non-fatal error tracking**: Catch and log errors without crashing
- **Stack trace visualization**: Detailed error context
- **Error categorization**: Organize crashes by type
- **Global error handlers**: Integrate with Flutter error handling
- **Crash history**: View all reported crashes

### 📊 Analytics Event Tracking
- **Multi-source support**: Firebase, CleverTap, Custom events
- **Property inspection**: View all event properties
- **Google Sheets validation**: Validate events against expected configuration
- **Event comparison**: Compare logged vs expected events
- **Statistics dashboard**: View validation results and coverage
- **Version-based validation**: Validate events per app version

### 🔔 Notification Logging
- **Received notifications**: Track all incoming notifications
- **Tapped notifications**: Monitor user interactions
- **Payload inspection**: View notification data
- **Firebase integration**: Works seamlessly with FCM
- **Notification history**: Access past notifications

### 📱 Device & App Information
- **Device details**: Model, OS version, screen size
- **App information**: Version, build number, package name
- **Memory monitoring**: Real-time memory usage tracking
- **Storage info**: Available and used storage

### 💾 Persistent Storage
- **Hive-based storage**: Fast, reliable local storage
- **Data persistence**: Survives app restarts
- **Configurable limits**: Control storage size
- **Clear functionality**: Easy data management

### 🎨 Customizable UI
- **Theme customization**: Match your brand colors
- **Floating bubble**: Always accessible, draggable
- **Bottom navigation**: Easy tab switching
- **Search & filter**: Find what you need quickly
- **Share functionality**: Export debug data
- **Dark mode ready**: Beautiful in any theme

### 🔧 Developer-Friendly
- **3-line integration**: Minimal setup required
- **Zero configuration**: Works out of the box
- **Type-safe API**: Full Dart type safety
- **Well documented**: Comprehensive documentation
- **Clean architecture**: Easy to understand and extend
- **Production safe**: Auto-disables in release mode

---

## 🚀 Quick Start

### 1. Add Dependency

Add DebugHub to your `pubspec.yaml`:

```yaml
dependencies:
  debug_hub:
    path: path/to/DebugHub
```

Or if published to pub.dev:

```yaml
dependencies:
  debug_hub: ^1.0.0
```

### 2. Initialize (3 Lines of Code!)

```dart
import 'package:flutter/material.dart';
import 'package:debug_hub/debug_hub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      navigatorObservers: [DebugHubManager.getObserver()],
      home: const HomeScreen(),
      // Add DebugHub overlay (1 line!)
      builder: (context, child) {
        return DebugHubManager.initialize(
          child: child!,
          mainColor: Colors.blue, // Optional: customize color
        );
      },
    );
  }
}
```

### 3. Done! 🎉

That's it! DebugHub is now active with a floating debug bubble. Tap it to access all debugging features.

---

## 📦 Installation

### iOS Setup

No additional setup required! DebugHub works out of the box on iOS.

### Android Setup

No additional setup required! DebugHub works out of the box on Android.

### Google Sheets Event Validation (Optional)

If you want to use the Google Sheets event validation feature:

1. **Create a Google Cloud Project**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project

2. **Enable APIs**
   - Enable Google Sheets API
   - Enable Google Sign-In API

3. **Configure OAuth 2.0**
   - Create OAuth 2.0 credentials
   - Add your app's SHA-1 fingerprint (Android)
   - Add your bundle ID (iOS)

4. **Add Client ID to Your App**

For Android (`android/app/build.gradle`):
```gradle
android {
    defaultConfig {
        resValue "string", "default_web_client_id", "YOUR_WEB_CLIENT_ID"
    }
}
```

For iOS (`ios/Runner/Info.plist`):
```xml
<key>GIDClientID</key>
<string>YOUR_IOS_CLIENT_ID</string>
```

---

## 💻 Usage Examples

### Basic Logging

```dart
import 'package:debug_hub/debug_hub.dart';

// Simple log
DebugHubManager.log('User logged in');

// Log with tag
DebugHubManager.log('Payment processed', tag: 'Payment');

// Log with level
DebugHubManager.log(
  'Data loaded successfully',
  tag: 'API',
  level: AppLogLevel.info,
);

// Log error
try {
  await riskyOperation();
} catch (e, stackTrace) {
  DebugHubManager.logError(
    'Operation failed',
    error: e,
    stackTrace: stackTrace,
    tag: 'Error',
  );
}
```

### Network Monitoring

#### With Dio

```dart
import 'package:dio/dio.dart';
import 'package:network/network.dart';

final dio = Dio();
dio.interceptors.add(DebugHubDioInterceptor());

// All requests are now automatically logged
final response = await dio.get('https://api.example.com/users');
```

#### With HTTP Package

```dart
import 'package:network/network.dart';

final client = DebugHttpClient();
final response = await client.get(
  Uri.parse('https://api.example.com/users'),
);
```

### Analytics Event Tracking

```dart
import 'package:debug_hub/debug_hub.dart';

// Track a simple event
DebugHubManager.trackEvent('button_click');

// Track event with properties
DebugHubManager.trackEvent(
  'product_viewed',
  properties: {
    'product_id': '12345',
    'category': 'electronics',
    'price': 299.99,
  },
);

// Track event with source
DebugHubManager.trackEvent(
  'screen_view',
  properties: {
    'screen_name': 'home',
    'screen_class': 'HomeScreen',
  },
  source: 'Firebase',
);
```

### Notification Logging

#### Firebase Cloud Messaging Integration

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:debug_hub/debug_hub.dart';

// When notification is received
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  DebugHubManager.logNotification(
    title: message.notification?.title,
    body: message.notification?.body,
    payload: message.data,
    notificationId: message.messageId,
  );
});

// When notification is tapped
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  DebugHubManager.logNotificationTap(
    notificationId: message.messageId ?? 'unknown',
    title: message.notification?.title,
    payload: message.data,
  );
});
```

### Crash Reporting

```dart
import 'package:debug_hub/debug_hub.dart';

// Manual crash reporting
try {
  dangerousOperation();
} catch (error, stackTrace) {
  DebugHubManager.reportCrash(error, stackTrace);
}

// Global error handler
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    DebugHubManager.reportCrash(
      details.exception,
      details.stack,
    );
  };
  
  // Catch async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    DebugHubManager.reportCrash(error, stack);
    return true;
  };
  
  runApp(const MyApp());
}
```

### Manual UI Access

```dart
import 'package:debug_hub/debug_hub.dart';

// Show DebugHub screen programmatically
ElevatedButton(
  onPressed: () => DebugHubManager.show(context),
  child: const Text('Open DebugHub'),
);
```

### Clear Debug Data

```dart
import 'package:debug_hub/debug_hub.dart';

// Clear all debug data
await DebugHubManager.clearAll();
```

---

## 🎯 Advanced Features

### Customization

```dart
DebugHubManager.initialize(
  child: child!,
  mainColor: Colors.purple,           // Custom theme color
  userProperties: {                   // Custom user properties
    'user_id': '12345',
    'environment': 'staging',
    'app_flavor': 'dev',
  },
);
```

### Update User Properties Dynamically

```dart
// Update user properties at runtime
DebugHubManager.updateUserProperties({
  'user_id': '67890',
  'subscription': 'premium',
});
```

### Enable Without UI

```dart
// Enable DebugHub tracking without showing UI
// Useful for automated testing
DebugHubManager.enableOnlyWithoutUI();
```

### Google Sheets Event Validation

```dart
import 'package:events/events.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Get package info
final packageInfo = await PackageInfo.fromPlatform();

// Navigate to validation dashboard
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EventValidationDashboardScreen(
      packageName: packageInfo.packageName,
    ),
  ),
);
```

The validation feature allows you to:
- **Compare logged events** with expected events from Google Sheets
- **View statistics**: Missing events, extra events, property mismatches
- **Version-based validation**: Validate events for specific app versions
- **Export reports**: Share validation results

---

## 🔌 Integration Guide

### Complete Integration Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:debug_hub/debug_hub.dart';
import 'package:dio/dio.dart';
import 'package:network/network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    DebugHubManager.reportCrash(details.exception, details.stack);
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    DebugHubManager.reportCrash(error, stack);
    return true;
  };
  
  // Setup Firebase messaging
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
    );
  });
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      navigatorObservers: [DebugHubManager.getObserver()],
      home: const HomeScreen(),
      builder: (context, child) {
        return DebugHubManager.initialize(
          child: child!,
          mainColor: Colors.blue,
          userProperties: {
            'environment': kDebugMode ? 'debug' : 'release',
          },
        );
      },
    );
  }
}

// Setup Dio with DebugHub
class ApiService {
  static final Dio _dio = Dio()
    ..interceptors.add(DebugHubDioInterceptor());
  
  static Future<Response> get(String url) async {
    try {
      return await _dio.get(url);
    } catch (e, stackTrace) {
      DebugHubManager.logError(
        'API request failed',
        error: e,
        stackTrace: stackTrace,
        tag: 'API',
      );
      rethrow;
    }
  }
}
```

---

## 📚 API Reference

### DebugHubManager

The main interface for interacting with DebugHub.

#### Initialization

```dart
static Widget initialize({
  required Widget child,
  Color? mainColor,
  Map<String, dynamic>? userProperties,
})
```

Wraps your app to enable DebugHub overlay.

**Parameters:**
- `child` - Your root widget
- `mainColor` - Optional theme color (default: green)
- `userProperties` - Optional custom properties to display

**Example:**
```dart
DebugHubManager.initialize(
  child: child!,
  mainColor: Colors.blue,
  userProperties: {'user_id': '123'},
);
```

#### Logging

```dart
static void log(
  String message, {
  String? tag,
  AppLogLevel level = AppLogLevel.debug,
})
```

Log a message with optional tag and level.

**Parameters:**
- `message` - Log message
- `tag` - Optional category tag
- `level` - Log level (verbose, debug, info, warning, error, wtf)

**Example:**
```dart
DebugHubManager.log('User logged in', tag: 'Auth', level: AppLogLevel.info);
```

---

```dart
static void logError(
  String message, {
  dynamic error,
  StackTrace? stackTrace,
  String? tag,
})
```

Log an error with optional error object and stack trace.

**Parameters:**
- `message` - Error description
- `error` - Error object
- `stackTrace` - Stack trace
- `tag` - Optional category tag

**Example:**
```dart
DebugHubManager.logError(
  'Failed to load data',
  error: e,
  stackTrace: stackTrace,
  tag: 'API',
);
```

#### Event Tracking

```dart
static void trackEvent(
  String name, {
  Map<String, dynamic>? properties,
  String? source,
})
```

Track an analytics event.

**Parameters:**
- `name` - Event name
- `properties` - Optional event properties
- `source` - Optional event source (Firebase, CleverTap, etc.)

**Example:**
```dart
DebugHubManager.trackEvent(
  'button_click',
  properties: {'button_id': 'submit'},
  source: 'Firebase',
);
```

#### Notification Logging

```dart
static void logNotification({
  String? title,
  String? body,
  Map<String, dynamic>? payload,
  String? notificationId,
})
```

Log a received notification.

**Parameters:**
- `title` - Notification title
- `body` - Notification body
- `payload` - Notification data
- `notificationId` - Unique identifier

**Example:**
```dart
DebugHubManager.logNotification(
  title: 'New Message',
  body: 'You have a new message',
  payload: {'message_id': '123'},
  notificationId: 'notif_123',
);
```

---

```dart
static void logNotificationTap({
  required String notificationId,
  String? title,
  String? body,
  Map<String, dynamic>? payload,
})
```

Log a notification tap.

**Parameters:**
- `notificationId` - Unique identifier (required)
- `title` - Notification title
- `body` - Notification body
- `payload` - Notification data

**Example:**
```dart
DebugHubManager.logNotificationTap(
  notificationId: 'notif_123',
  title: 'New Message',
);
```

#### Crash Reporting

```dart
static void reportCrash(
  dynamic error,
  StackTrace? stackTrace, {
  bool isFatal = false,
})
```

Report a crash or error.

**Parameters:**
- `error` - Error object
- `stackTrace` - Stack trace
- `isFatal` - Whether the crash is fatal

**Example:**
```dart
DebugHubManager.reportCrash(error, stackTrace);
```

#### Utilities

```dart
static NavigatorObserver getObserver()
```

Get the NavigatorObserver for route tracking.

**Example:**
```dart
MaterialApp(
  navigatorObservers: [DebugHubManager.getObserver()],
  // ...
)
```

---

```dart
static Future<void> clearAll()
```

Clear all debug data.

**Example:**
```dart
await DebugHubManager.clearAll();
```

---

```dart
static void show(BuildContext context)
```

Show DebugHub screen manually.

**Example:**
```dart
DebugHubManager.show(context);
```

---

```dart
static void updateUserProperties(Map<String, dynamic> userProperties)
```

Update user properties dynamically.

**Example:**
```dart
DebugHubManager.updateUserProperties({'user_id': '123'});
```

---

```dart
static void enableOnlyWithoutUI()
```

Enable DebugHub tracking without showing UI.

**Example:**
```dart
DebugHubManager.enableOnlyWithoutUI();
```

---

## 🏗️ Architecture

DebugHub follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  (UI Screens, Widgets, State Management)                    │
│  Package: debug_hub_ui                                       │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│                     Application Layer                        │
│  (Use Cases, Business Logic, Repositories)                  │
│  Packages: events, notification, non_fatal                  │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│                      Domain Layer                            │
│  (Entities, Models, Interfaces)                             │
│  Package: base                                               │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│                  Infrastructure Layer                        │
│  (Data Sources, External Services, Storage)                 │
│  Packages: network, log, storage                            │
└─────────────────────────────────────────────────────────────┘
```

### Package Structure

```
debug_hub/
├── lib/
│   ├── debug_hub.dart              # Main export
│   └── debug_hub_interface.dart    # Simplified API
├── packages/
│   ├── base/                       # Core models & storage
│   ├── network/                    # Network monitoring
│   ├── log/                        # Log tracking
│   ├── events/                     # Event tracking & validation
│   ├── notification/               # Notification logging
│   ├── non_fatal/                  # Crash reporting
│   └── debug_hub_ui/               # UI components
└── example/                        # Example app
```

### SOLID Principles

#### 1. Single Responsibility Principle (SRP)
Each class has one reason to change:
- `DebugStorage` - Manages in-memory data
- `PersistentStorage` - Handles disk persistence
- `EventTracker` - Tracks analytics events
- `NetworkInterceptor` - Captures network requests

#### 2. Open/Closed Principle (OCP)
Open for extension, closed for modification:
- Extensible configuration via `DebugHubConfig`
- Interceptor pattern for different HTTP clients
- Plugin architecture for new features

#### 3. Liskov Substitution Principle (LSP)
Subtypes are substitutable:
- Storage implementations are interchangeable
- Interceptors follow common interface

#### 4. Interface Segregation Principle (ISP)
Clients depend only on what they use:
- Separate interfaces for logging, events, notifications
- No fat interfaces

#### 5. Dependency Inversion Principle (DIP)
Depend on abstractions:
- Repository pattern with interfaces
- Dependency injection throughout

### Design Patterns

- **Singleton**: Global state management
- **Repository**: Data access abstraction
- **Adapter**: HTTP client adaptation
- **Factory**: Object creation
- **Observer**: UI updates
- **Strategy**: Flexible implementations

---

## 🎁 Benefits

### For Developers

✅ **Save Time**: No more switching between tools - everything in one place  
✅ **Debug Faster**: Instant access to all debug information  
✅ **Better Insights**: Comprehensive view of app behavior  
✅ **Easy Integration**: Just 3 lines of code  
✅ **Zero Maintenance**: Auto-disables in production  
✅ **Clean Code**: No debug code scattered in your app  

### For Teams

✅ **Consistent Debugging**: Same tools for all team members  
✅ **Easy Sharing**: Export and share debug data  
✅ **Quality Assurance**: Validate analytics events  
✅ **Better Testing**: QA can access debug info easily  
✅ **Documentation**: Self-documenting debug data  

### For Projects

✅ **Faster Development**: Reduce debugging time  
✅ **Better Quality**: Catch issues early  
✅ **Maintainable**: Clean architecture, easy to extend  
✅ **Professional**: Enterprise-grade solution  
✅ **Future-Proof**: Built to scale  

---

## 🛡️ Production Safety

DebugHub is designed to be **100% safe for production**:

### Automatic Disabling

DebugHub automatically detects release mode and disables itself:

```dart
// This code is safe in production
DebugHubManager.log('test');                // No-op in release
DebugHubManager.trackEvent('event');        // No-op in release
```

### No Code Removal Needed

You don't need to:
- ❌ Remove DebugHub calls before release
- ❌ Wrap calls in `kDebugMode` checks
- ❌ Use conditional imports
- ❌ Configure build variants

What you need to do:
- ✅ Just Initialize the DebugHub with kDebugMode check - whatever your logic can modify when to initialize the library with UI or Without UI.


### Zero Performance Impact

In release mode:
- ✅ No UI overlay
- ✅ No data collection
- ✅ No storage usage
- ✅ No memory overhead
- ✅ No performance impact

---

## 🎓 Best Practices

### 1. Initialize Early

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup error handling first
  FlutterError.onError = (details) {
    DebugHubManager.reportCrash(details.exception, details.stack);
  };
  
  runApp(const MyApp());
}
```

### 2. Use Meaningful Tags

```dart
// Good: Organized by feature
DebugHubManager.log('User logged in', tag: 'Auth');
DebugHubManager.log('Payment processed', tag: 'Payment');
DebugHubManager.log('Data synced', tag: 'Sync');

// Bad: No tags or vague tags
DebugHubManager.log('Something happened');
DebugHubManager.log('Event', tag: 'General');
```

### 3. Track Important Events

```dart
// Track user actions
DebugHubManager.trackEvent('button_click', properties: {
  'button_id': 'checkout',
  'screen': 'cart',
});

// Track screen views
DebugHubManager.trackEvent('screen_view', properties: {
  'screen_name': 'product_detail',
  'product_id': '12345',
});

// Track business events
DebugHubManager.trackEvent('purchase_completed', properties: {
  'amount': 99.99,
  'currency': 'USD',
  'items': 3,
});
```

### 4. Always Report Errors

```dart
try {
  await riskyOperation();
} catch (e, stackTrace) {
  // Always report non-fatal errors
  DebugHubManager.reportCrash(e, stackTrace);
  
  // Also log for context
  DebugHubManager.logError(
    'Operation failed',
    error: e,
    stackTrace: stackTrace,
    tag: 'Error',
  );
}
```

### 5. Use Network Interceptors

```dart
// Setup once, capture all requests
final dio = Dio()..interceptors.add(DebugHubDioInterceptor());

// All requests are now automatically logged
await dio.get('https://api.example.com/users');
await dio.post('https://api.example.com/users', data: {...});
```

### 6. Validate Analytics Events

```dart
// Use Google Sheets validation to ensure
// your events match expected configuration
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EventValidationDashboardScreen(
      packageName: 'com.yourcompany.app', // will be taken automatically using package info
    ),
  ),
);
```

### 7. Clear Data Regularly

```dart
// Clear debug data during development to avoid clutter
await DebugHubManager.clearAll();
```

---

## 🆘 Troubleshooting

### DebugHub Not Showing

**Problem**: Floating bubble doesn't appear

**Solutions**:
1. Ensure you're in debug mode: `flutter run` (not `flutter run --release`)
2. Verify initialization:
   ```dart
   builder: (context, child) {
     return DebugHubManager.initialize(child: child!);
   }
   ```
3. Check that `navigatorObservers` includes the observer:
   ```dart
   navigatorObservers: [DebugHubManager.getObserver()]
   ```

---

### Logs Not Appearing

**Problem**: Logs don't show in DebugHub

**Solutions**:
1. Use `DebugHubManager.log()` instead of `print()`
2. Check log level filters in UI
3. Verify you're in debug mode
4. Try clearing and re-logging:
   ```dart
   await DebugHubManager.clearAll();
   DebugHubManager.log('Test log');
   ```

---

### Network Requests Not Captured

**Problem**: API calls don't appear in Network tab

**Solutions**:
1. Add interceptor to Dio:
   ```dart
   dio.interceptors.add(DebugHubDioInterceptor());
   ```
2. Or use DebugHttpClient:
   ```dart
   final client = DebugHttpClient();
   ```
3. Ensure interceptor is added before making requests
4. Check that you're using the instrumented client

---

### Events Not Tracked

**Problem**: Analytics events don't appear

**Solutions**:
1. Use `DebugHubManager.trackEvent()`:
   ```dart
   DebugHubManager.trackEvent('event_name', properties: {...});
   ```
2. Check Events tab in DebugHub UI
3. Verify you're in debug mode

---

### Google Sheets Validation Error

**Problem**: "Sign-in error code 10" or authentication fails

**Solutions**:
1. Configure OAuth 2.0 in Google Cloud Console
2. Add SHA-1 fingerprint (Android):
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey
   ```
3. Add client ID to app configuration
4. See detailed setup guide in Events package documentation

---

### Memory Issues

**Problem**: App uses too much memory

**Solutions**:
1. Clear debug data regularly:
   ```dart
   await DebugHubManager.clearAll();
   ```
2. Configure storage limits (coming soon)
3. Disable DebugHub if not needed:
   ```dart
   // Don't initialize DebugHub
   ```

---

### Build Errors

**Problem**: Build fails after adding DebugHub

**Solutions**:
1. Run `flutter pub get`
2. Clean build:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
3. Check Flutter version (requires 3.9+)
4. Check Dart SDK version (requires 3.4.3+)

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

### Reporting Issues

1. Check existing issues first
2. Provide detailed description
3. Include steps to reproduce
4. Share relevant code snippets
5. Mention Flutter/Dart versions

### Submitting Pull Requests

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write/update tests
5. Update documentation
6. Submit PR with clear description

### Development Setup

```bash
# Clone repository
git clone https://github.com/yourusername/DebugHub.git

# Install dependencies
cd DebugHub
flutter pub get

# Run example app
cd example
flutter run
```

### Code Style

- Follow Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Write documentation for public APIs
- Follow existing patterns

---

## 📄 License

MIT License

Copyright (c) 2024 DebugHub

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## 🌟 Features Comparison

| Feature | DebugHub | Other Tools |
|---------|----------|-------------|
| Network Monitoring | ✅ | ✅ |
| Log Tracking | ✅ | ✅ |
| Crash Reporting | ✅ | ✅ |
| Event Tracking | ✅ | ❌ |
| Event Validation | ✅ | ❌ |
| Google Sheets Integration | ✅ | ❌ |
| Notification Logging | ✅ | ❌ |
| Memory Monitoring | ✅ | ❌ |
| Persistent Storage | ✅ | ❌ |
| Floating Bubble UI | ✅ | ⚠️ |
| Bottom Navigation | ✅ | ❌ |
| Search & Filter | ✅ | ⚠️ |
| Share Functionality | ✅ | ⚠️ |
| cURL Export | ✅ | ⚠️ |
| Minimal Setup | ✅ (3 lines) | ❌ |
| Auto-disable in Release | ✅ | ✅ |
| Clean Architecture | ✅ | ❌ |
| SOLID Principles | ✅ | ❌ |
| Well Documented | ✅ | ⚠️ |
| Easy to Extend | ✅ | ❌ |

---

## 🚀 Roadmap

### Upcoming Features

- [ ] **Web Support** - Full web platform support
- [ ] **Desktop Support** - Windows, macOS, Linux support
- [ ] **Remote Debugging** - Debug apps remotely
- [ ] **Performance Monitoring** - FPS, frame timing, jank detection
- [ ] **Custom Plugins API** - Create custom debug plugins
- [ ] **Export Formats** - CSV, JSON, PDF exports
- [ ] **Database Inspector** - View SQLite/Hive data
- [ ] **Shared Preferences Viewer** - Inspect app preferences
- [ ] **Widget Inspector** - Flutter widget tree inspection
- [ ] **Timeline View** - Visual timeline of events
- [ ] **Filtering Presets** - Save and load filter configurations
- [ ] **Dark Mode** - Full dark mode support

### Architecture Improvements

- [ ] **Use Cases Layer** - Explicit use cases for complex operations
- [ ] **State Management** - Integrate Riverpod/Bloc
- [ ] **Dependency Injection** - Add GetIt container
- [ ] **Unit Tests** - >80% code coverage
- [ ] **Widget Tests** - UI component tests
- [ ] **Integration Tests** - End-to-end tests

---

## 💬 Support

### Documentation

- **This README** - Complete overview and guide
- **API Reference** - Detailed API documentation (above)
- **Example App** - Working example in `example/` folder
- **Package READMEs** - Individual package documentation

### Getting Help

1. **Check Documentation** - Most questions are answered here
2. **Search Issues** - Someone may have had the same problem
3. **Ask Questions** - Open a discussion on GitHub
4. **Report Bugs** - Open an issue with details

### Community

- **GitHub Discussions** - Ask questions, share ideas
- **GitHub Issues** - Report bugs, request features
- **Pull Requests** - Contribute improvements

---

## 🙏 Acknowledgments

DebugHub is built with and inspired by:

- **Flutter** - Amazing cross-platform framework
- **Hive** - Fast and lightweight local storage
- **Dio** - Powerful HTTP client
- **Google Sheets API** - Event validation integration
- **Clean Architecture** - Robert C. Martin
- **SOLID Principles** - Best practices for maintainable code

Special thanks to all contributors and users!

---

## 📞 Contact

For questions, suggestions, or feedback:

- **GitHub**: [DebugHub Repository](https://github.com/yourusername/DebugHub)
- **Issues**: [Report a Bug](https://github.com/yourusername/DebugHub/issues)
- **Discussions**: [Ask a Question](https://github.com/yourusername/DebugHub/discussions)

---

<p align="center">
  <strong>Made with ❤️ for Flutter developers</strong>
  <br>
  <em>Debug smarter, not harder!</em> 🐛✨
</p>

---

## 📝 Quick Reference Card

### Installation
```yaml
dependencies:
  debug_hub: ^1.0.0
```

### Setup
```dart
MaterialApp(
  navigatorObservers: [DebugHubManager.getObserver()],
  builder: (context, child) {
    return DebugHubManager.initialize(child: child!);
  },
)
```

### Usage
```dart
// Logging
DebugHubManager.log('message', tag: 'Tag');
DebugHubManager.logError('error', error: e, stackTrace: s);

// Events
DebugHubManager.trackEvent('event', properties: {...});

// Notifications
DebugHubManager.logNotification(title: '...', body: '...');
DebugHubManager.logNotificationTap(notificationId: '...');

// Crashes
DebugHubManager.reportCrash(error, stackTrace);

// Network (Dio)
dio.interceptors.add(DebugHubDioInterceptor());

// Utilities
await DebugHubManager.clearAll();
DebugHubManager.show(context);
```

---

**That's everything you need to know about DebugHub! Happy debugging! 🚀**
