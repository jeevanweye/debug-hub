# DebugHub Manager - API Reference

## 📚 Complete API Documentation

### Initialization

#### `DebugHubManager.initialize()`

Initialize DebugHub with configuration options.

**Parameters**:
- `packageName` (String?, optional): Your app's package identifier (e.g., 'com.yourcompany.app')
- `serverURL` (String?, optional): Your API server URL for highlighting in network requests
- `ignoredURLs` (List<String>?, optional): List of URL patterns to exclude from network monitoring
- `mainColor` (Color?, optional): Primary theme color for DebugHub UI (default: green)
- `enableShakeGesture` (bool, optional): Enable shake to show/hide debug bubble (default: false)
- `showBubbleOnStart` (bool, optional): Show debug bubble when app starts (default: true)

**Returns**: `Future<void>`

**Example**:
```dart
await DebugHubManager.initialize(
  packageName: 'com.yourcompany.app',
  serverURL: 'https://api.yourcompany.com',
  mainColor: Colors.blue,
  enableShakeGesture: true,
);
```

---

#### `DebugHubManager.wrap(Widget app)`

Wrap your MaterialApp to enable DebugHub overlay.

**Parameters**:
- `app` (Widget): Your root application widget

**Returns**: `Widget`

**Example**:
```dart
runApp(DebugHubManager.wrap(MyApp()));
```

---

### Logging

#### `DebugHubManager.log(String message, {String? tag, LogLevel level})`

Log a message with optional tag and level.

**Parameters**:
- `message` (String, required): The log message
- `tag` (String?, optional): Tag for categorization (e.g., 'Auth', 'Network')
- `level` (LogLevel, optional): Log level (default: LogLevel.debug)

**Log Levels**:
- `LogLevel.verbose`
- `LogLevel.debug`
- `LogLevel.info`
- `LogLevel.warning`
- `LogLevel.error`

**Example**:
```dart
DebugHubManager.log('User logged in', tag: 'Auth', level: LogLevel.info);
DebugHubManager.log('Fetching data...', tag: 'Network');
```

---

#### `DebugHubManager.logError(String message, {dynamic error, StackTrace? stackTrace, String? tag})`

Log an error with optional error object and stack trace.

**Parameters**:
- `message` (String, required): Error description
- `error` (dynamic, optional): The error object
- `stackTrace` (StackTrace?, optional): Stack trace for debugging
- `tag` (String?, optional): Tag for categorization

**Example**:
```dart
try {
  await fetchData();
} catch (error, stackTrace) {
  DebugHubManager.logError(
    'Failed to fetch data',
    error: error,
    stackTrace: stackTrace,
    tag: 'Network',
  );
}
```

---

### Analytics Events

#### `DebugHubManager.trackEvent(String name, {Map<String, dynamic>? properties, String? source})`

Track an analytics event.

**Parameters**:
- `name` (String, required): Event name (e.g., 'button_click', 'page_view')
- `properties` (Map<String, dynamic>?, optional): Event properties as key-value pairs
- `source` (String?, optional): Event source (e.g., 'firebase', 'clevertap')

**Example**:
```dart
DebugHubManager.trackEvent(
  'button_click',
  properties: {
    'button_id': 'submit',
    'screen': 'home',
    'user_type': 'premium',
  },
  source: 'firebase',
);

DebugHubManager.trackEvent(
  'page_view',
  properties: {'page': 'product_detail', 'product_id': '123'},
);
```

---

### Notifications

#### `DebugHubManager.logNotification({String? title, String? body, Map<String, dynamic>? payload, String? notificationId})`

Log a notification received.

**Parameters**:
- `title` (String?, optional): Notification title
- `body` (String?, optional): Notification body text
- `payload` (Map<String, dynamic>?, optional): Additional data payload
- `notificationId` (String?, optional): Unique notification identifier

**Example**:
```dart
// When receiving a Firebase notification
FirebaseMessaging.onMessage.listen((message) {
  DebugHubManager.logNotification(
    title: message.notification?.title,
    body: message.notification?.body,
    payload: message.data,
    notificationId: message.messageId,
  );
});
```

---

#### `DebugHubManager.logNotificationTap({required String notificationId, String? title, String? body, Map<String, dynamic>? payload})`

Log a notification tap.

**Parameters**:
- `notificationId` (String, required): Unique notification identifier
- `title` (String?, optional): Notification title
- `body` (String?, optional): Notification body text
- `payload` (Map<String, dynamic>?, optional): Additional data payload

**Example**:
```dart
// When user taps a notification
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  DebugHubManager.logNotificationTap(
    notificationId: message.messageId ?? 'unknown',
    title: message.notification?.title,
    payload: message.data,
  );
});
```

---

### Crash Reporting

#### `DebugHubManager.reportCrash(dynamic error, StackTrace? stackTrace)`

Report a non-fatal crash or error.

**Parameters**:
- `error` (dynamic, required): The error object
- `stackTrace` (StackTrace?, optional): Stack trace for debugging

**Example**:
```dart
// Manual error reporting
try {
  dangerousOperation();
} catch (error, stackTrace) {
  DebugHubManager.reportCrash(error, stackTrace);
}

// Global error handler
FlutterError.onError = (FlutterErrorDetails details) {
  DebugHubManager.reportCrash(
    details.exception,
    details.stack,
  );
};

// Async error handler
PlatformDispatcher.instance.onError = (error, stack) {
  DebugHubManager.reportCrash(error, stack);
  return true;
};
```

---

### Utilities

#### `DebugHubManager.clearAll()`

Clear all debug data (logs, network requests, crashes, events, notifications).

**Returns**: `Future<void>`

**Example**:
```dart
await DebugHubManager.clearAll();
```

---

#### `DebugHubManager.show(BuildContext context)`

Show DebugHub screen manually.

**Parameters**:
- `context` (BuildContext, required): Build context

**Example**:
```dart
// Add a button to manually open DebugHub
ElevatedButton(
  onPressed: () => DebugHubManager.show(context),
  child: Text('Open Debug Hub'),
);
```

---

## 🎯 Quick Reference

### Minimal Setup (2 lines)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DebugHubManager.initialize();
  runApp(DebugHubManager.wrap(MyApp()));
}
```

### Full Setup with Configuration
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DebugHubManager.initialize(
    packageName: 'com.yourcompany.app',
    serverURL: 'https://api.yourcompany.com',
    ignoredURLs: ['googleapis.com', 'google.com'],
    mainColor: Colors.blue,
    enableShakeGesture: true,
    showBubbleOnStart: true,
  );
  
  runApp(DebugHubManager.wrap(MyApp()));
}
```

### Common Usage Patterns

**Logging**:
```dart
DebugHubManager.log('Message', tag: 'Tag', level: LogLevel.info);
DebugHubManager.logError('Error', error: e, stackTrace: s, tag: 'Error');
```

**Analytics**:
```dart
DebugHubManager.trackEvent('event_name', properties: {...}, source: 'firebase');
```

**Notifications**:
```dart
DebugHubManager.logNotification(title: '...', body: '...', payload: {...});
DebugHubManager.logNotificationTap(notificationId: '...', title: '...');
```

**Crashes**:
```dart
DebugHubManager.reportCrash(error, stackTrace);
```

**Utilities**:
```dart
await DebugHubManager.clearAll();
DebugHubManager.show(context);
```

---

## 🔍 Advanced Usage

### Custom Network Interceptor (Dio)
```dart
final dio = Dio();
dio.interceptors.add(DebugHubDioInterceptor());
```

### Custom Network Interceptor (HTTP)
```dart
final client = DebugHttpClient();
final response = await client.get(Uri.parse('https://api.example.com/data'));
```

### Global Error Handling
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DebugHub
  await DebugHubManager.initialize();
  
  // Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    DebugHubManager.reportCrash(details.exception, details.stack);
  };
  
  // Catch async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    DebugHubManager.reportCrash(error, stack);
    return true;
  };
  
  runApp(DebugHubManager.wrap(MyApp()));
}
```

---

## 📱 Platform-Specific Notes

### Android
- Shake gesture requires `sensors_plus` package
- Network monitoring works with both Dio and HTTP package

### iOS
- Shake gesture requires `sensors_plus` package
- Network monitoring works with both Dio and HTTP package

### Web
- DebugHub works on web but some features may be limited
- Shake gesture not available on web

---

## 🛡️ Production Safety

DebugHub automatically disables in release mode:

```dart
// This code is safe in production
await DebugHubManager.initialize();  // Does nothing in release mode
runApp(DebugHubManager.wrap(MyApp()));  // Just returns MyApp() in release
DebugHubManager.log('test');  // No-op in release mode
```

No need to wrap calls in `kDebugMode` checks!

---

## 💡 Best Practices

1. **Initialize Early**: Call `initialize()` before `runApp()`
2. **Use Tags**: Organize logs with meaningful tags
3. **Track Important Events**: Focus on key user actions
4. **Report Non-Fatal Errors**: Don't let errors go silent
5. **Clear Regularly**: Clear data during testing to avoid clutter
6. **Configure Package Name**: Enable Google Sheets event validation

---

## 🆘 Troubleshooting

### DebugHub not showing?
- Check you're in debug mode (`flutter run` not `flutter run --release`)
- Verify `initialize()` was called
- Check `showBubbleOnStart` is true

### Logs not appearing?
- Verify you're using `DebugHubManager.log()`
- Check log level filters in UI
- Try clearing and re-logging

### Network requests not captured?
- Add interceptor: `DebugHubDioInterceptor()` or `DebugHttpClient()`
- Check URL not in `ignoredURLs`
- Verify request was made after interceptor added

---

**For more details, see:**
- [Integration Guide](INTEGRATION_GUIDE.md)
- [Architecture Documentation](ARCHITECTURE.md)
- [Example App](example/)

