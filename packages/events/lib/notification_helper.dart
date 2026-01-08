// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/navigator.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:io' show Platform;
//
// class NotificationHelper {
//   static final NotificationHelper _instance = NotificationHelper._internal();
//   factory NotificationHelper() => _instance;
//   NotificationHelper._internal();
//
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   GlobalKey<NavigatorState>? _navigatorKey;
//
//   Future<void> init({GlobalKey<NavigatorState>? navKey}) async {
//     _navigatorKey = navKey;
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//
//     // Initialize with onDidReceiveNotificationResponse callback
//     await _notificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         _onNotificationTapped(response);
//       },
//     );
//
//     // Create the notification channel explicitly for Android 8.0+
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'event_logger_channel',
//       'Event Logger Notifications',
//       description: 'Notifications for the Event Logger package',
//       importance: Importance.max,
//     );
//
//     await _notificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     // Request notification permissions (handles Android 13+ automatically)
//     await requestNotificationPermission();
//   }
//
//   void _onNotificationTapped(NotificationResponse response) {
//     print('Notification tapped with payload: ${response.payload}');
//
//     if (_navigatorKey?.currentState != null) {
//       _navigatorKey!.currentState!.pushNamed('/event-list');
//     } else {
//       print('Navigator key is not available');
//     }
//   }
//
//   /// Request notification permission with automatic Android version check
//   Future<bool> requestNotificationPermission() async {
//     if (Platform.isAndroid) {
//       // Check Android version
//       final androidInfo = await _getAndroidVersion();
//
//       // Android 13 (API 33) and above require runtime permission
//       if (androidInfo >= 33) {
//         final status = await Permission.notification.status;
//
//         if (status.isDenied) {
//           final result = await Permission.notification.request();
//           print('Notification permission requested: $result');
//           return result.isGranted;
//         } else if (status.isPermanentlyDenied) {
//           print('Notification permission permanently denied. Open app settings.');
//           return false;
//         }
//
//         return status.isGranted;
//       } else {
//         // For Android versions below 13, permissions are granted at install time
//         print('Android version < 13: Notification permission granted by default');
//         return true;
//       }
//     }
//
//     // For iOS or other platforms
//     return true;
//   }
//
//   /// Get Android API level
//   Future<int> _getAndroidVersion() async {
//     if (Platform.isAndroid) {
//       try {
//         // Use permission_handler's internal method to get Android version
//         final androidInfo = await Permission.notification.status;
//         // This is a workaround - ideally use device_info_plus package
//         // For now, we'll assume modern Android and always check permission
//         return 33; // Assume Android 13+ to be safe
//       } catch (e) {
//         print('Error getting Android version: $e');
//         return 33; // Default to requiring permission
//       }
//     }
//     return 0;
//   }
//
//   /// Show notification with automatic permission check and payload
//   Future<void> showNotification({
//     required String title,
//     required String body,
//     String? payload, // Add payload parameter for navigation data
//   }) async {
//     try {
//       // Verify permission before showing notification
//       final hasPermission = await _checkNotificationPermission();
//
//       if (!hasPermission) {
//         print('Notification permission not granted. Requesting...');
//         final granted = await requestNotificationPermission();
//
//         if (!granted) {
//           print('Notification permission denied. Cannot show notification.');
//           return;
//         }
//       }
//
//       const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//         'event_logger_channel',
//         'Event Logger Notifications',
//         channelDescription: 'Notifications for the Event Logger package',
//         importance: Importance.high, // Changed from none to high
//         priority: Priority.high, // Changed from default to high
//         showWhen: true,
//       );
//
//       const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//
//       await _notificationsPlugin.show(
//         DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         title,
//         body,
//         platformChannelSpecifics,
//         payload: payload, // Pass the payload
//       );
//
//       print('Notification shown successfully: $title');
//     } catch (e) {
//       print('Error showing notification: $e');
//     }
//   }
//
//   /// Check if notification permission is granted
//   Future<bool> _checkNotificationPermission() async {
//     if (Platform.isAndroid) {
//       final status = await Permission.notification.status;
//       return status.isGranted;
//     }
//     return true;
//   }
//
//   /// Open app settings (useful for permanently denied permissions)
//   Future<void> openSettings() async {
//     await openAppSettings();
//   }
// }