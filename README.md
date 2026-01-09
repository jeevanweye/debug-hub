# DebugHub 🐛

A comprehensive Flutter debugging tool built with **Clean Architecture** and **SOLID Principles** that makes debugging effortless with minimal integration code.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.9+-blue.svg" alt="Flutter Version">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Architecture-Clean-brightgreen.svg" alt="Clean Architecture">
  <img src="https://img.shields.io/badge/SOLID-Principles-blue.svg" alt="SOLID Principles">
</p>

## ✨ Features

- 🌐 **Network Monitoring** - Capture and inspect all HTTP requests/responses
- 📝 **Log Tracking** - View all app logs with filtering and search
- 💥 **Crash Reporting** - Track non-fatal crashes and errors
- 📊 **Event Tracking** - Monitor analytics events (Firebase, CleverTap, etc.)
- 🔔 **Notification Logging** - Track notifications received and tapped
- 📱 **Device Info** - View device and app information
- 💾 **Persistent Storage** - Data persists across app restarts
- 🎨 **Customizable UI** - Theme colors and configuration options
- 🔍 **Search & Filter** - Find what you need quickly
- 📤 **Share Data** - Export debug data easily
- 🧠 **Memory Monitoring** - Real-time memory usage tracking
- 🗂️ **More Section** - Organized access to advanced features

## 🚀 Quick Start

### 1. Add Dependency

```yaml
dependencies:
  debug_hub:
    path: path/to/DebugHub
```

### 2. Initialize (3 lines of code!)

```dart
import 'package:flutter/material.dart';
import 'package:debug_hub/debug_hub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DebugHubManager.initialize();  // Initialize
  
  runApp(DebugHubManager.wrap(MyApp()));  // Wrap your app
}
```

### 3. Done! 🎉

That's it! DebugHub is now active with a floating debug bubble.

## 📱 Screenshots

The UI includes:
- **Network Tab** - View all API calls with request/response details
- **Logs Tab** - Filter logs by level (Verbose, Debug, Info, Warning, Error)
- **Non-Fatal Tab** - Track crashes with stack traces
- **Events Tab** - Monitor analytics events with properties
- **Notifications Tab** - See all notifications received and tapped
- **More Tab** - Access advanced features:
  - **App Info** - Device and app information
  - **Memory Monitor** - Real-time memory usage tracking
  - **Storage Manager** - Manage debug data storage
  - **Settings** - Configure DebugHub preferences

## 🎯 Usage Examples

### Basic Logging

```dart
import 'package:debug_hub/debug_hub.dart';

// Log a message
DebugHubManager.log('User logged in', tag: 'Auth');

// Log an error
DebugHubManager.logError('Failed to load', error: e, stackTrace: s);
```

### Track Events

```dart
// Track analytics event
DebugHubManager.trackEvent('button_click', properties: {
  'screen': 'home',
  'button': 'submit',
});
```

### Log Notifications

```dart
// When notification received
DebugHubManager.logNotification(
  title: 'New Message',
  body: 'You have a new message',
  payload: {'message_id': '123'},
);

// When notification tapped
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
  DebugHubSimple.reportCrash(e, stackTrace);
}
```

## 🎨 Customization

```dart
await DebugHubSimple.init(
  serverURL: 'https://api.example.com',  // Highlight your API
  mainColor: Colors.blue,                 // Custom theme
  showBubbleOnStart: true,                // Show bubble
  ignoredURLs: ['analytics.google.com'], // URLs to ignore
);
```

## 🔌 Integrations

### Dio (Network Monitoring)

```dart
import 'package:dio/dio.dart';
import 'package:network/network.dart';

final dio = Dio();
dio.interceptors.add(DebugHubDioInterceptor());
```

### Firebase Cloud Messaging

```dart
FirebaseMessaging.onMessage.listen((message) {
  DebugHubSimple.logNotification(
    title: message.notification?.title,
    body: message.notification?.body,
    payload: message.data,
  );
});
```

### Error Handling

```dart
FlutterError.onError = (details) {
  DebugHubSimple.reportCrash(details.exception, details.stack);
};
```

## 📦 Architecture

DebugHub is built with a modular architecture:

```
debug_hub/
├── packages/
│   ├── base/           # Core models and storage
│   ├── network/        # Network monitoring
│   ├── log/            # Log tracking
│   ├── events/         # Event tracking
│   ├── notification/   # Notification logging
│   ├── non_fatal/      # Crash reporting
│   ├── memory_monitor/ # Memory usage monitoring
│   └── debug_hub_ui/   # UI components
├── lib/
│   ├── debug_hub.dart           # Main export
│   └── debug_hub_interface.dart # Simplified API
└── example/            # Example app
```

## 🛡️ Production Safety

DebugHub automatically disables itself in release builds. No need to remove code!

```dart
// Safe in production - won't run in release mode
await DebugHubManager.initialize();
```

## 📖 Documentation

- [Integration Guide](INTEGRATION_GUIDE.md) - Detailed setup instructions
- [API Reference](lib/debug_hub_interface.dart) - Complete API documentation
- [Example App](example/) - Working example

## 🎓 Best Practices

1. ✅ Initialize early in `main()`
2. ✅ Wrap your app with `DebugHubManager.wrap()`
3. ✅ Use tags for better log organization
4. ✅ Track important user actions
5. ✅ Always report non-fatal errors
6. ✅ Test in debug mode only

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆘 Support

For issues or questions:
1. Check the [Integration Guide](INTEGRATION_GUIDE.md)
2. Review the [Example App](example/)
3. Open an issue on GitHub

## 🌟 Features Comparison

| Feature | DebugHub | Other Tools |
|---------|----------|-------------|
| Network Monitoring | ✅ | ✅ |
| Log Tracking | ✅ | ✅ |
| Crash Reporting | ✅ | ✅ |
| Event Tracking | ✅ | ❌ |
| Notification Logging | ✅ | ❌ |
| Memory Monitoring | ✅ | ❌ |
| Persistent Storage | ✅ | ❌ |
| Bottom Navigation | ✅ | ❌ |
| More Section | ✅ | ❌ |
| Minimal Code | ✅ (3 lines) | ❌ |
| Auto-disable in Release | ✅ | ✅ |
| Clean Architecture | ✅ | ❌ |
| SOLID Principles | ✅ | ❌ |
| Interface-Based Design | ✅ | ❌ |
| Easy to Test | ✅ | ⚠️ |
| Well Documented | ✅ | ⚠️ |

## 🚀 Roadmap

### Features
- [ ] Web support
- [ ] Desktop support
- [ ] Remote debugging
- [ ] Performance monitoring
- [ ] Custom plugins API
- [ ] Export to file formats (CSV, JSON)
- [x] Memory usage monitoring
- [x] More section for organized features

### Architecture Improvements
- [ ] Add explicit Use Cases layer
- [ ] Integrate state management (Riverpod/Bloc)
- [ ] Add Dependency Injection container (GetIt)
- [ ] Comprehensive unit tests (>80% coverage)
- [ ] Widget tests for UI components

---

**Made with ❤️ for Flutter developers**

*Debug smarter, not harder!* 🐛✨
