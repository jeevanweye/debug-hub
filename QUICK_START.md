# DebugHub Quick Start Guide

## 🚀 Get Started in 2 Minutes

### 1. Run the Example App

```bash
cd /Users/sandeep/Documents/Android/DebugHub
flutter pub get
flutter run
```

### 2. Test Features

Once the app is running:

1. **See the green bug icon** in the bottom-right corner
2. **Tap it** to open DebugHub
3. **Try the buttons** in the app:
   - Make GET Request
   - Make POST Request
   - Generate Test Logs
   - Simulate Crash
4. **Check each tab** in DebugHub:
   - Network: See your API calls
   - Logs: See all logs with filtering
   - Crashes: See crash reports
   - Storage: Browse app files
   - App Info: See device & app details

### 3. Test Gestures

- **Shake your device** (or Hardware > Shake in simulator) to hide/show bubble
- **Long press the bubble** to clear all data
- **Drag the bubble** to move it around

## 📦 Use as Plugin (5 Minutes)

### Step 1: Copy Packages

```bash
cp -r packages/ /path/to/your_project/
```

### Step 2: Add to pubspec.yaml

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

### Step 3: Initialize in main.dart

```dart
import 'package:flutter/foundation.dart';
import 'package:debug_hub_ui/debug_hub_ui.dart';

void main() {
  if (kDebugMode) {
    DebugHub().init(
      config: const DebugHubConfig(
        mainColor: Color(0xFF42d459),
      ),
    );
    DebugHub().enable();
  }
  runApp(const MyApp());
}
```

### Step 4: Wrap Your App

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: DebugHub().navigatorKey,
      home: const HomePage(),
      builder: (context, child) {
        if (kDebugMode) {
          return DebugHub().wrap(child ?? const SizedBox.shrink());
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
```

### Step 5: Run!

```bash
flutter pub get
flutter run
```

## 🌐 Network Monitoring Setup

### For Dio:

```dart
import 'package:dio/dio.dart';
import 'package:network/network.dart';

final dio = Dio();
if (kDebugMode) {
  dio.interceptors.add(DebugDioInterceptor());
}
```

### For HTTP:

```dart
import 'package:network/network.dart';
import 'package:http/http.dart' as http;

final interceptor = NetworkInterceptor();

Future<void> makeRequest() async {
  final id = interceptor.captureRequest(
    url: 'https://api.example.com/data',
    method: 'GET',
  );
  
  final start = DateTime.now();
  final response = await http.get(Uri.parse('https://api.example.com/data'));
  
  interceptor.captureResponse(
    id: id,
    statusCode: response.statusCode,
    responseBody: response.body,
    duration: DateTime.now().difference(start),
  );
}
```

## 📝 Logging Setup

```dart
import 'package:base/base.dart';

final storage = DebugStorage();

// Log info
storage.addLog(
  DebugLog.create(
    level: LogLevel.info,
    message: 'User logged in',
    tag: 'Auth',
  ),
);

// Log error
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

## 🎨 Customization

### Change Color

```dart
DebugHub().init(
  config: const DebugHubConfig(
    mainColor: Color(0xFFFF5722), // Your color
  ),
);
```

### Filter URLs

```dart
DebugHub().init(
  config: DebugHubConfig(
    serverURL: 'https://api.myapp.com',
    ignoredURLs: ['https://analytics.com'],
  ),
);
```

### Add Custom Tab

```dart
DebugHub().init(
  config: DebugHubConfig(
    additionalTab: MyCustomWidget(),
    additionalTabLabel: 'Custom',
    additionalTabIcon: Icons.settings,
  ),
);
```

## 📚 Learn More

- **Full Documentation**: [README.md](README.md)
- **Plugin Usage**: [PLUGIN_USAGE.md](PLUGIN_USAGE.md)
- **Setup Guide**: [SETUP.md](SETUP.md)
- **Feature Comparison**: [COMPARISON.md](COMPARISON.md)

## 🐛 Troubleshooting

### Bubble not showing?
- Make sure you're in debug mode (`kDebugMode`)
- Check that you called `DebugHub().wrap(app)`
- Verify `showBubbleOnStart: true` in config

### Network requests not captured?
- Use `NetworkInterceptor` or `DebugDioInterceptor`
- Check if URL is filtered in config
- Verify `enableNetworkMonitoring: true`

### Shake not working?
- Use physical device or simulator's shake gesture
- Check `enableShakeGesture: true` in config

## ✅ Checklist

- [ ] Run example app
- [ ] Test all features
- [ ] Copy packages to your project
- [ ] Add to pubspec.yaml
- [ ] Initialize in main.dart
- [ ] Wrap your app
- [ ] Setup network monitoring
- [ ] Setup logging
- [ ] Test in your app
- [ ] Customize configuration

## 🎉 You're Ready!

That's it! You now have a powerful debugging tool in your Flutter app.

**Happy Debugging!** 🐛🔍

---

**Need Help?**
- Check [README.md](README.md) for detailed documentation
- See [PLUGIN_USAGE.md](PLUGIN_USAGE.md) for integration examples
- Review [SETUP.md](SETUP.md) for troubleshooting

