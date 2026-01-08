# Notification Logger Package

Notification logging and tracking package for DebugHub.

## Features

- 📱 **Notification Tracking**: Log notifications received by your app
- 👆 **Tap Tracking**: Track which notifications users tap on
- 📊 **Payload Logging**: Capture full notification payloads
- 🔍 **Search & Filter**: Search and filter notification logs
- 📤 **Export**: Share notification logs

## Quick Start

### 1. Enable Notification Logging

Notification logging is automatically enabled when DebugHub is enabled (if `enableNotificationMonitoring` is true in config).

```dart
import 'package:debug_hub_ui/debug_hub_ui.dart';

await DebugHub().init();
DebugHub().enable();
```

### 2. Log Notifications Received

When your app receives a notification, log it:

```dart
import 'package:notification/notification.dart';

// When notification is received
NotificationLogger().logNotificationReceived(
  title: 'New Message',
  body: 'You have a new message',
  payload: {
    'message_id': '123',
    'sender': 'John Doe',
    'type': 'chat',
  },
  notificationId: 'notification_123',
);
```

### 3. Log Notification Taps

When a user taps on a notification:

```dart
// When notification is tapped
NotificationLogger().logNotificationTapped(
  notificationId: 'notification_123',
  title: 'New Message',
  body: 'You have a new message',
  payload: {
    'message_id': '123',
    'sender': 'John Doe',
    'type': 'chat',
  },
);
```

## Integration Examples

### Firebase Cloud Messaging (FCM)

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notification/notification.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationLogger().logNotificationReceived(
    title: message.notification?.title,
    body: message.notification?.body,
    payload: message.data,
    notificationId: message.messageId ?? 'unknown',
  );
}

// Foreground message handler
void setupFirebaseMessaging() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationLogger().logNotificationReceived(
      title: message.notification?.title,
      body: message.notification?.body,
      payload: message.data,
      notificationId: message.messageId ?? 'unknown',
    );
  });

  // Handle notification taps
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    NotificationLogger().logNotificationTapped(
      notificationId: message.messageId ?? 'unknown',
      title: message.notification?.title,
      body: message.notification?.body,
      payload: message.data,
    );
  });
}
```

### Local Notifications

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification/notification.dart';

final FlutterLocalNotificationsPlugin localNotifications = 
    FlutterLocalNotificationsPlugin();

// When showing a notification
Future<void> showNotification({
  required int id,
  required String title,
  required String body,
  Map<String, dynamic>? payload,
}) async {
  await localNotifications.show(
    id,
    title,
    body,
    notificationDetails,
    payload: payload != null ? jsonEncode(payload) : null,
  );

  // Log the notification
  NotificationLogger().logNotificationReceived(
    title: title,
    body: body,
    payload: payload,
    notificationId: id.toString(),
  );
}

// Handle notification tap
void onNotificationTapped(NotificationResponse response) {
  Map<String, dynamic>? payload;
  if (response.payload != null) {
    payload = jsonDecode(response.payload!);
  }

  NotificationLogger().logNotificationTapped(
    notificationId: response.id?.toString() ?? 'unknown',
    title: response.title,
    body: response.body,
    payload: payload,
  );
}
```

### OneSignal

```dart
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:notification/notification.dart';

void setupOneSignal() {
  OneSignal.Notifications.addClickListener((event) {
    NotificationLogger().logNotificationTapped(
      notificationId: event.notification.notificationId ?? 'unknown',
      title: event.notification.title,
      body: event.notification.body,
      payload: event.notification.additionalData,
    );
  });

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    NotificationLogger().logNotificationReceived(
      title: event.notification.title,
      body: event.notification.body,
      payload: event.notification.additionalData,
      notificationId: event.notification.notificationId ?? 'unknown',
    );
  });
}
```

## API Reference

### NotificationLogger

#### Methods

##### `enable()`
Enable notification logging.

##### `disable()`
Disable notification logging.

##### `logNotificationReceived({...})`
Log a notification that was received.

**Parameters:**
- `title` (String?): Notification title
- `body` (String?): Notification body/message
- `payload` (Map<String, dynamic>?): Additional notification data
- `notificationId` (String?): Unique identifier for the notification

##### `logNotificationTapped({...})`
Log a notification that was tapped.

**Parameters:**
- `notificationId` (String): Required - Unique identifier for the notification
- `title` (String?): Notification title (optional, for reference)
- `body` (String?): Notification body (optional, for reference)
- `payload` (Map<String, dynamic>?): Additional notification data (optional)

##### `getNotificationLogs()`
Get all notification logs.

**Returns:** `List<NotificationLog>`

##### `getNotificationLogsByType(NotificationType type)`
Get notification logs filtered by type.

**Parameters:**
- `type` (NotificationType): `NotificationType.received` or `NotificationType.tapped`

**Returns:** `List<NotificationLog>`

##### `getNotificationLogsById(String notificationId)`
Get all logs for a specific notification ID.

**Parameters:**
- `notificationId` (String): The notification ID to search for

**Returns:** `List<NotificationLog>`

##### `clearNotificationLogs()`
Clear all notification logs.

## NotificationLog Model

### Properties

- `id` (String): Unique log identifier
- `timestamp` (DateTime): When the log was created
- `type` (NotificationType): `received` or `tapped`
- `title` (String?): Notification title
- `body` (String?): Notification body
- `payload` (Map<String, dynamic>?): Additional data
- `notificationId` (String?): Notification identifier
- `wasTapped` (bool): Whether notification was tapped
- `tappedAt` (DateTime?): When notification was tapped

## UI

Notification logs are displayed in the DebugHub UI under the "Notifications" tab. You can:

- View all notification logs
- Filter by type (Received/Tapped)
- Search by title, body, or notification ID
- View detailed payload information
- Share logs
- Clear logs

## Best Practices

1. **Always log received notifications**: Log every notification your app receives
2. **Log taps immediately**: Log notification taps as soon as they occur
3. **Use consistent IDs**: Use the same notification ID for received and tapped logs
4. **Include payloads**: Always include the full payload for debugging
5. **Enable in debug only**: Notification logging is automatically disabled in release builds

## Dependencies

- `base`: Core models and storage

## License

MIT License
