import 'package:flutter/material.dart';
import 'package:debug_hub/debug_hub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DebugHub with minimal code
  await DebugHubManager.initialize(
    serverURL: 'https://api.example.com',
    mainColor: Colors.teal,
  );

  // Catch Flutter errors
  FlutterError.onError = (details) {
    DebugHubManager.reportCrash(details.exception, details.stack);
  };

  runApp(DebugHubManager.wrap(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DebugHub Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logMessage() {
    DebugHubManager.log('User clicked the log button', tag: 'UI');
  }

  void _trackEvent() {
    DebugHubManager.trackEvent(
      'button_click',
      properties: {
        'screen': 'home',
        'button': 'track_event',
        'timestamp': DateTime.now().toIso8601String(),
      },
      source: 'App',
    );
  }

  void _simulateError() {
    try {
      throw Exception('This is a test error');
    } catch (e, stackTrace) {
      DebugHubManager.reportCrash(e, stackTrace);
      DebugHubManager.logError(
        'Simulated error occurred',
        error: e,
        stackTrace: stackTrace,
        tag: 'Error',
      );
    }
  }

  void _logNotification() {
    DebugHubManager.logNotification(
      title: 'Test Notification',
      body: 'This is a test notification from the app',
      payload: {
        'notification_id': '123',
        'type': 'test',
        'timestamp': DateTime.now().toIso8601String(),
      },
      notificationId: 'test_notification_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DebugHub Example'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.bug_report,
                size: 80,
                color: Colors.teal,
              ),
              const SizedBox(height: 24),
              const Text(
                'DebugHub Example',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Try the features below and check the debug bubble!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              _buildFeatureButton(
                context,
                icon: Icons.article,
                label: 'Log Message',
                description: 'Log a debug message',
                color: Colors.blue,
                onPressed: _logMessage,
              ),
              const SizedBox(height: 16),
              _buildFeatureButton(
                context,
                icon: Icons.analytics,
                label: 'Track Event',
                description: 'Track an analytics event',
                color: Colors.green,
                onPressed: _trackEvent,
              ),
              const SizedBox(height: 16),
              _buildFeatureButton(
                context,
                icon: Icons.error_outline,
                label: 'Simulate Error',
                description: 'Trigger a test error',
                color: Colors.red,
                onPressed: _simulateError,
              ),
              const SizedBox(height: 16),
              _buildFeatureButton(
                context,
                icon: Icons.notifications,
                label: 'Log Notification',
                description: 'Log a test notification',
                color: Colors.orange,
                onPressed: _logNotification,
              ),
              const SizedBox(height: 16),
              _buildFeatureButton(
                context,
                icon: Icons.dashboard,
                label: 'Open DebugHub',
                description: 'View all debug data',
                color: Colors.teal,
                onPressed: () => DebugHubManager.show(context),
              ),
              const SizedBox(height: 40),
              const Text(
                '💡 Tip: Look for the floating debug bubble!',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label executed! Check DebugHub.'),
              duration: const Duration(seconds: 2),
              backgroundColor: color,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

