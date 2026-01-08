import 'package:flutter/material.dart';
import 'package:debug_hub_ui/debug_hub_ui.dart';
import 'package:base/base.dart';
import 'package:network/network.dart';
import 'package:events/events.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DebugHub with configuration (only in debug mode)
  await DebugHub().init(
    config: const DebugHubConfig(
      serverURL: 'https://jsonplaceholder.typicode.com',
      mainColor: Color(0xFF42d459),
      enableShakeGesture: false, // Keep bubble always visible
      enableLogMonitoring: true,
      enableNetworkMonitoring: true,
      enableCrashMonitoring: true,
      enableEventMonitoring: true, // Enable event monitoring
      showBubbleOnStart: true,
      emailToRecipients: ['developer@example.com'],
    ),
  );

  // Enable DebugHub (only works in debug mode)
  DebugHub().enable();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Debug Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: DebugHub().navigatorKey,
      home: const MyHomePage(),
      // Add DebugHub overlay using builder
      builder: (context, child) {
        return DebugHub().wrap(child ?? const SizedBox.shrink());
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DebugStorage _storage = DebugStorage();
  final NetworkInterceptor _networkInterceptor = NetworkInterceptor();
  final EventTracker _eventTracker = EventTracker();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Log the action
    _storage.addLog(
      DebugLog.create(
        level: LogLevel.info,
        message: 'Counter incremented to $_counter',
        tag: 'Counter',
      ),
    );

    // Track event
    _eventTracker.trackEvent(
      'counter_incremented',
      properties: {
        'counter_value': _counter,
        'timestamp': DateTime.now().toIso8601String(),
      },
      source: 'Custom',
    );
  }

  Future<void> _makeNetworkRequest() async {
    try {
      // Capture request
      final requestId = _networkInterceptor.captureRequest(
        url: 'https://jsonplaceholder.typicode.com/posts/1',
        method: 'GET',
        headers: {'Content-Type': 'application/json'},
      );

      final startTime = DateTime.now();

      // Make actual request
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      );

      final duration = DateTime.now().difference(startTime);

      // Capture response
      _networkInterceptor.captureResponse(
        id: requestId,
        statusCode: response.statusCode,
        responseBody: response.body,
        responseHeaders: response.headers.map((k, v) => MapEntry(k, v)),
        duration: duration,
      );

      // Log success
      _storage.addLog(
        DebugLog.create(
          level: LogLevel.info,
          message: 'Network request successful: ${response.statusCode}',
          tag: 'Network',
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request successful: ${response.statusCode}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      // Log error
      _storage.addLog(
        DebugLog.create(
          level: LogLevel.error,
          message: 'Network request failed',
          tag: 'Network',
          error: e,
          stackTrace: stackTrace,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _makePostRequest() async {
    try {
      final requestBody = {
        'title': 'DebugHub Test',
        'body': 'Testing POST request',
        'userId': 1,
      };

      final requestId = _networkInterceptor.captureRequest(
        url: 'https://jsonplaceholder.typicode.com/posts',
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      final startTime = DateTime.now();

      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      final duration = DateTime.now().difference(startTime);

      _networkInterceptor.captureResponse(
        id: requestId,
        statusCode: response.statusCode,
        responseBody: response.body,
        responseHeaders: response.headers.map((k, v) => MapEntry(k, v)),
        duration: duration,
      );

      _storage.addLog(
        DebugLog.create(
          level: LogLevel.info,
          message: 'POST request successful: ${response.statusCode}',
          tag: 'Network',
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('POST successful: ${response.statusCode}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      _storage.addLog(
        DebugLog.create(
          level: LogLevel.error,
          message: 'POST request failed',
          tag: 'Network',
          error: e,
          stackTrace: stackTrace,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('POST failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _testLogs() {
    // Generate different log levels
    _storage.addLog(
      DebugLog.create(
        level: LogLevel.verbose,
        message: 'This is a verbose log message',
        tag: 'Test',
      ),
    );

    _storage.addLog(
      DebugLog.create(
        level: LogLevel.debug,
        message: 'This is a debug log message',
        tag: 'Test',
      ),
    );

    _storage.addLog(
      DebugLog.create(
        level: LogLevel.info,
        message: 'This is an info log message',
        tag: 'Test',
      ),
    );

    _storage.addLog(
      DebugLog.create(
        level: LogLevel.warning,
        message: 'This is a warning log message',
        tag: 'Test',
      ),
    );

    _storage.addLog(
      DebugLog.create(
        level: LogLevel.error,
        message: 'This is an error log message',
        tag: 'Test',
        error: 'Sample error',
      ),
    );

    _storage.addLog(
      DebugLog.create(
        level: LogLevel.wtf,
        message: 'This is a WTF log message',
        tag: 'Test',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test logs generated'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _simulateCrash() {
    try {
      // Simulate a crash
      throw Exception('This is a simulated crash for testing');
    } catch (e, stackTrace) {
      _storage.addCrashReport(
        CrashReport.create(
          error: e.toString(),
          stackTrace: stackTrace,
          context: 'Simulated crash from button press',
          isFatal: false,
        ),
      );

      _storage.addLog(
        DebugLog.create(
          level: LogLevel.error,
          message: 'Crash simulated',
          tag: 'Crash',
          error: e,
          stackTrace: stackTrace,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Crash simulated and logged'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('DebugHub Demo'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome to DebugHub!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tap the floating green bubble to open DebugHub',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'The bubble stays visible in debug mode',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Counter Demo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('You have pushed the button this many times:'),
                      Text(
                        '$_counter',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _incrementCounter,
                        icon: const Icon(Icons.add),
                        label: const Text('Increment Counter'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Network Requests',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _makeNetworkRequest,
                        icon: const Icon(Icons.cloud_download),
                        label: const Text('Make GET Request'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _makePostRequest,
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text('Make POST Request'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Testing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _testLogs,
                        icon: const Icon(Icons.article),
                        label: const Text('Generate Test Logs'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _simulateCrash,
                        icon: const Icon(Icons.error),
                        label: const Text('Simulate Crash'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Analytics Events',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          _eventTracker.trackFirebaseEvent(
                            'button_click',
                            properties: {
                              'button_name': 'test_firebase',
                              'screen': 'home',
                            },
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Firebase event tracked'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                        icon: const Icon(Icons.local_fire_department),
                        label: const Text('Track Firebase Event'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          _eventTracker.trackCleverTapEvent(
                            'user_action',
                            properties: {
                              'action_type': 'test',
                              'value': 100,
                            },
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('CleverTap event tracked'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: const Icon(Icons.track_changes),
                        label: const Text('Track CleverTap Event'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Features:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Network monitoring\n'
                '• Log capture\n'
                '• Non-fatal error tracking\n'
                '• Analytics events tracking\n'
                '• App & device info\n'
                '• Always visible in debug mode\n'
                '• Share debug data\n'
                '• Share as cURL command',
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
