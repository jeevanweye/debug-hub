# DebugHub Setup Guide

Complete setup instructions for DebugHub.

## 🎯 Quick Setup (5 minutes)

### Step 1: Install Dependencies

```bash
cd /path/to/DebugHub
flutter pub get
```

### Step 2: Run the Example App

```bash
flutter run
```

That's it! The app will launch with DebugHub enabled.

## 📱 Testing DebugHub Features

Once the app is running:

### 1. See the Floating Bubble
- Look for the green bug icon in the bottom-right corner
- Drag it around the screen
- Tap it to open DebugHub

### 2. Test Network Monitoring
- Tap "Make GET Request" button
- Tap "Make POST Request" button
- Open DebugHub and go to Network tab
- See your requests with full details

### 3. Test Logging
- Tap "Generate Test Logs" button
- Open DebugHub and go to Logs tab
- See logs with different levels (verbose, debug, info, warning, error, wtf)
- Use the filter chips to filter by level
- Use the search bar to search logs

### 4. Test Crash Reporting
- Tap "Simulate Crash" button
- Open DebugHub and go to Crashes tab
- See the crash report with stack trace

### 5. Test Storage Browser
- Open DebugHub and go to Storage tab
- Browse your app's file system
- See file sizes and directory structure

### 6. Test App Info
- Open DebugHub and go to App Info tab
- See device information, app version, Flutter version, etc.
- Copy any info to clipboard

### 7. Test Shake Gesture
- Shake your device (or use Hardware > Shake in simulator)
- The bubble should hide/show

### 8. Test Long Press
- Long press the bubble
- Confirm to clear all debug data

### 9. Test Share Feature
- Open any tab in DebugHub
- Tap the share icon
- Share debug data via email or other apps

## 🔧 Development Setup

### Prerequisites

- Flutter SDK 3.9.0 or higher
- Dart SDK 3.9.0 or higher
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended)

### Clone and Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd DebugHub

# Get dependencies for all packages
flutter pub get

# Optional: Get dependencies for each package individually
cd packages/base && flutter pub get
cd ../network && flutter pub get
cd ../log && flutter pub get
cd ../storage && flutter pub get
cd ../non_fatal && flutter pub get
cd ../debug_hub_ui && flutter pub get
cd ../..

# Run the app
flutter run
```

### Project Structure

```
DebugHub/
├── lib/
│   └── main.dart              # Example app
├── packages/
│   ├── base/                  # Core models and storage
│   ├── network/               # Network monitoring
│   ├── log/                   # Log capture
│   ├── storage/               # File browser
│   ├── non_fatal/             # Crash reporting
│   ├── events/                # Event tracking (future)
│   ├── notification/          # Notification monitoring (future)
│   └── debug_hub_ui/          # Main UI package
├── android/                   # Android configuration
├── ios/                       # iOS configuration
├── README.md                  # Main documentation
├── PLUGIN_USAGE.md           # Plugin usage guide
└── SETUP.md                  # This file
```

## 🧪 Testing

### Run Tests

```bash
# Run all tests
flutter test

# Run tests for specific package
cd packages/base
flutter test
```

### Manual Testing Checklist

- [ ] Floating bubble appears
- [ ] Bubble is draggable
- [ ] Tap bubble opens DebugHub
- [ ] All tabs are accessible
- [ ] Network requests are captured
- [ ] Logs are displayed correctly
- [ ] Crashes are recorded
- [ ] Storage browser works
- [ ] App info is displayed
- [ ] Share functionality works
- [ ] Search works in Network and Logs
- [ ] Filters work correctly
- [ ] Shake gesture works
- [ ] Long press clears data
- [ ] Copy to clipboard works
- [ ] Theme color is applied

## 🚀 Building for Release

### Important: Disable DebugHub in Production

Make sure your production build doesn't include DebugHub:

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

### Build Commands

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🔍 Debugging DebugHub

If something isn't working:

### 1. Check Flutter Version

```bash
flutter --version
# Should be 3.9.0 or higher
```

### 2. Clean and Rebuild

```bash
flutter clean
flutter pub get
flutter run
```

### 3. Check Logs

```bash
flutter run --verbose
```

### 4. Verify Dependencies

```bash
flutter pub deps
```

### 5. Check for Linting Errors

```bash
flutter analyze
```

## 📦 Using as a Plugin

See [PLUGIN_USAGE.md](PLUGIN_USAGE.md) for detailed instructions on using DebugHub in your own projects.

### Quick Plugin Setup

1. Copy packages folder to your project
2. Add to pubspec.yaml:
```yaml
dependencies:
  debug_hub_ui:
    path: packages/debug_hub_ui
```
3. Initialize in main.dart:
```dart
if (kDebugMode) {
  DebugHub().init();
  DebugHub().enable();
}
```
4. Wrap your app:
```dart
if (kDebugMode) {
  app = DebugHub().wrap(app);
}
```

## 🎨 Customization

### Change Theme Color

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

## 🐛 Common Issues

### Issue: "Package not found"

**Solution**: Run `flutter pub get`

### Issue: "Version conflict"

**Solution**: Check Flutter version and update dependencies

### Issue: Bubble not showing

**Solution**: 
1. Check if running in debug mode
2. Verify `DebugHub().wrap()` is called
3. Check `showBubbleOnStart` config

### Issue: Network requests not captured

**Solution**: 
1. Ensure `enableNetworkMonitoring` is true
2. Use NetworkInterceptor or DebugDioInterceptor
3. Check if URL is filtered

### Issue: Shake not working

**Solution**:
1. Use physical device or simulator's shake gesture
2. Check `enableShakeGesture` config
3. Verify sensors_plus permission on Android

## 📱 Platform-Specific Setup

### Android

No additional setup required. Permissions are handled automatically.

### iOS

No additional setup required. Shake gesture works on physical devices and simulator (Hardware > Shake).

## 🔐 Security Notes

1. **Never enable in production** - Always use `kDebugMode`
2. **Sanitize sensitive data** - Remove tokens, passwords before capturing
3. **Use build flavors** - Separate debug and release configurations
4. **Review shared data** - Check before sharing debug information

## 📚 Next Steps

1. ✅ Complete setup
2. ✅ Test all features
3. ✅ Read [PLUGIN_USAGE.md](PLUGIN_USAGE.md)
4. ✅ Integrate into your project
5. ✅ Customize configuration
6. ✅ Share with your team

## 💬 Support

If you encounter any issues:

1. Check this guide
2. Review [README.md](README.md)
3. Check [PLUGIN_USAGE.md](PLUGIN_USAGE.md)
4. Open an issue on GitHub

## 🎉 Success!

You're now ready to use DebugHub! Happy debugging! 🐛🔍

---

Made with 💚 for Flutter developers

