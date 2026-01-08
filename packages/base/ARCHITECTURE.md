# Base Package - Architecture Documentation

## 📦 Package Overview

The `base` package is the **Domain Layer** of DebugHub, containing core models, interfaces, and storage abstractions.

---

## 🎯 Purpose

This package provides:
- **Domain Models** - Core entities used across the application
- **Storage Interfaces** - Abstractions for data storage
- **Storage Implementations** - In-memory and persistent storage
- **Utilities** - Shared helper functions

---

## 🏗️ Architecture

### Layer: Domain Layer

```
┌─────────────────────────────────────────┐
│           Base Package                   │
│         (Domain Layer)                   │
├─────────────────────────────────────────┤
│  Models (Entities)                      │
│  - DebugLog                             │
│  - NetworkRequest                       │
│  - CrashReport                          │
│  - AnalyticsEvent                       │
│  - NotificationLog                      │
├─────────────────────────────────────────┤
│  Interfaces (Abstractions)              │
│  - IDebugStorage                        │
│  - IPersistentStorage                   │
│  - ILogStorage, IEventStorage, etc.     │
├─────────────────────────────────────────┤
│  Storage (Implementations)              │
│  - DebugStorage (in-memory)             │
│  - PersistentStorage (Hive)             │
├─────────────────────────────────────────┤
│  Utils (Helpers)                        │
│  - DateFormatter                        │
│  - JsonFormatter                        │
└─────────────────────────────────────────┘
```

---

## 📁 Directory Structure

```
base/
├── lib/
│   ├── base.dart                    # Public API exports
│   └── src/
│       ├── models/                  # Domain entities
│       │   ├── debug_log.dart
│       │   ├── network_request.dart
│       │   ├── crash_report.dart
│       │   ├── analytics_event.dart
│       │   ├── notification_log.dart
│       │   └── device_info.dart
│       ├── interfaces/              # Abstractions
│       │   ├── i_debug_storage.dart
│       │   └── i_persistent_storage.dart
│       ├── storage/                 # Storage implementations
│       │   ├── debug_storage.dart
│       │   └── persistent_storage.dart
│       └── utils/                   # Utilities
│           ├── date_formatter.dart
│           └── json_formatter.dart
├── test/                            # Unit tests
├── pubspec.yaml
└── README.md
```

---

## 🎨 SOLID Principles

### 1. Single Responsibility Principle (SRP)

Each class has ONE reason to change:

- **DebugLog** - Represents a log entry
- **DebugStorage** - Manages in-memory data
- **PersistentStorage** - Manages disk persistence
- **DateFormatter** - Formats dates
- **JsonFormatter** - Formats JSON

### 2. Open/Closed Principle (OCP)

Classes are open for extension, closed for modification:

```dart
// Extend models without modifying
class CustomDebugLog extends DebugLog {
  final String customField;
  // ...
}

// Implement interfaces for custom storage
class CustomStorage implements IDebugStorage {
  // Custom implementation
}
```

### 3. Liskov Substitution Principle (LSP)

All implementations are substitutable:

```dart
IPersistentStorage storage1 = PersistentStorage();
IPersistentStorage storage2 = CustomPersistentStorage();

// Both work the same way
await storage1.initialize();
await storage2.initialize();
```

### 4. Interface Segregation Principle (ISP)

Clients depend only on what they need:

```dart
// Only need log storage? Use ILogStorage
class LogService {
  final ILogStorage logStorage;
  LogService(this.logStorage);
}

// Only need event storage? Use IEventStorage
class EventService {
  final IEventStorage eventStorage;
  EventService(this.eventStorage);
}
```

### 5. Dependency Inversion Principle (DIP)

Depend on abstractions, not concretions:

```dart
// ❌ Bad - depends on concrete class
class MyService {
  final DebugStorage storage = DebugStorage();
}

// ✅ Good - depends on interface
class MyService {
  final IDebugStorage storage;
  MyService(this.storage);
}
```

---

## 📊 Models (Domain Entities)

### DebugLog

Represents a log entry.

```dart
class DebugLog {
  final String id;
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? tag;
  final Map<String, dynamic>? metadata;
  
  factory DebugLog.create({
    required LogLevel level,
    required String message,
    String? tag,
    Map<String, dynamic>? metadata,
  });
}
```

**Immutable**: ✅  
**Serializable**: ✅ (JSON)  
**Factory Constructor**: ✅

---

### NetworkRequest

Represents a network request/response.

```dart
class NetworkRequest {
  final String id;
  final DateTime timestamp;
  final String method;
  final String url;
  final Map<String, dynamic>? headers;
  final dynamic requestBody;
  final int? statusCode;
  final dynamic responseBody;
  final Duration? duration;
  final String? error;
}
```

**Immutable**: ✅  
**Serializable**: ✅ (JSON)  
**Supports HTTP/HTTPS**: ✅

---

### CrashReport

Represents a crash or error.

```dart
class CrashReport {
  final String id;
  final DateTime timestamp;
  final String error;
  final String? stackTrace;
  final Map<String, dynamic>? context;
  final bool isFatal;
}
```

**Immutable**: ✅  
**Serializable**: ✅ (JSON)  
**Fatal/Non-Fatal**: ✅

---

### AnalyticsEvent

Represents an analytics event.

```dart
class AnalyticsEvent {
  final String id;
  final DateTime timestamp;
  final String name;
  final Map<String, dynamic>? properties;
  final String? category;
  final String? action;
  final String? label;
}
```

**Immutable**: ✅  
**Serializable**: ✅ (JSON)  
**Flexible Properties**: ✅

---

### NotificationLog

Represents a notification (received/tapped).

```dart
class NotificationLog {
  final String id;
  final DateTime timestamp;
  final NotificationType type; // received or tapped
  final String? notificationId;
  final String? title;
  final String? body;
  final Map<String, dynamic>? payload;
  
  factory NotificationLog.create({
    required NotificationType type,
    String? notificationId,
    String? title,
    String? body,
    Map<String, dynamic>? payload,
  });
}
```

**Immutable**: ✅  
**Serializable**: ✅ (JSON)  
**Factory Constructor**: ✅

---

## 🔌 Interfaces

### IDebugStorage

Core in-memory storage interface.

```dart
abstract class IDebugStorage {
  Future<void> initialize();
  void clearAll();
  Map<String, int> getItemCounts();
}
```

### ILogStorage

Log-specific storage operations.

```dart
abstract class ILogStorage {
  void addLog(DebugLog log);
  List<DebugLog> getLogs();
  void clearLogs();
}
```

### INetworkStorage

Network request storage operations.

```dart
abstract class INetworkStorage {
  void addNetworkRequest(NetworkRequest request);
  List<NetworkRequest> getNetworkRequests();
  void clearNetworkRequests();
}
```

### ICrashStorage

Crash report storage operations.

```dart
abstract class ICrashStorage {
  void addCrashReport(CrashReport report);
  List<CrashReport> getCrashReports();
  void clearCrashReports();
}
```

### IEventStorage

Analytics event storage operations.

```dart
abstract class IEventStorage {
  void addAnalyticsEvent(AnalyticsEvent event);
  List<AnalyticsEvent> getAnalyticsEvents();
  void clearAnalyticsEvents();
}
```

### INotificationStorage

Notification log storage operations.

```dart
abstract class INotificationStorage {
  void addNotificationLog(NotificationLog log);
  List<NotificationLog> getNotificationLogs();
  void clearNotificationLogs();
}
```

---

## 💾 Storage Implementations

### DebugStorage (In-Memory)

Singleton class for in-memory data storage.

**Features**:
- ✅ Queue-based storage with size limits
- ✅ Automatic persistence to disk
- ✅ Thread-safe operations
- ✅ Implements all storage interfaces

**Usage**:
```dart
final storage = DebugStorage();
await storage.initialize();

// Add data
storage.addLog(DebugLog.create(
  level: LogLevel.debug,
  message: 'Test log',
));

// Retrieve data
final logs = storage.getLogs();

// Clear data
await storage.clearLogs();
```

**Size Limits**:
- Logs: 1000
- Network Requests: 500
- Crash Reports: 100
- Events: 1000
- Notifications: 500

---

### PersistentStorage (Hive)

Singleton class for persistent disk storage using Hive.

**Features**:
- ✅ Persistent storage across app restarts
- ✅ Fast key-value storage
- ✅ JSON serialization
- ✅ Implements all persistent storage interfaces

**Usage**:
```dart
final storage = PersistentStorage();
await storage.initialize();

// Save data
await storage.saveLog(log);

// Load data
final logs = await storage.loadLogs();

// Clear data
await storage.clearLogs();

// Get storage info
final size = await storage.getStorageSize();
final counts = await storage.getItemCounts();
```

**Storage Boxes**:
- `debug_logs` - Log entries
- `network_requests` - Network requests
- `crash_reports` - Crash reports
- `analytics_events` - Analytics events
- `notification_logs` - Notification logs

---

## 🛠️ Utilities

### DateFormatter

Formats DateTime objects for display.

```dart
class DateFormatter {
  static String format(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} '
           '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }
  
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) return '${difference.inSeconds}s ago';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
```

---

### JsonFormatter

Formats JSON for display.

```dart
class JsonFormatter {
  static String format(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }
  
  static String formatCompact(dynamic json) {
    return jsonEncode(json);
  }
}
```

---

## 🧪 Testing

### Unit Testing

All classes are designed for easy unit testing.

```dart
test('DebugStorage adds log correctly', () {
  final storage = DebugStorage();
  final log = DebugLog.create(
    level: LogLevel.debug,
    message: 'Test',
  );
  
  storage.addLog(log);
  
  expect(storage.getLogs(), contains(log));
});
```

### Mock Testing

Use interfaces for easy mocking.

```dart
class MockLogStorage extends Mock implements ILogStorage {}

test('Service uses log storage', () {
  final mockStorage = MockLogStorage();
  final service = MyService(mockStorage);
  
  when(mockStorage.getLogs()).thenReturn([]);
  
  // Test service
});
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive_flutter: ^1.1.0
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

dev_dependencies:
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  build_runner: ^2.4.13
```

---

## 🚀 Usage Examples

### Basic Usage

```dart
import 'package:base/base.dart';

void main() async {
  // Initialize storage
  final storage = DebugStorage();
  await storage.initialize();
  
  // Add a log
  storage.addLog(DebugLog.create(
    level: LogLevel.info,
    message: 'App started',
  ));
  
  // Add a network request
  storage.addNetworkRequest(NetworkRequest(
    id: '1',
    timestamp: DateTime.now(),
    method: 'GET',
    url: 'https://api.example.com/data',
  ));
  
  // Retrieve data
  final logs = storage.getLogs();
  final requests = storage.getNetworkRequests();
  
  print('Logs: ${logs.length}');
  print('Requests: ${requests.length}');
}
```

### Interface-Based Usage

```dart
import 'package:base/base.dart';

class LoggingService {
  final ILogStorage logStorage;
  
  LoggingService({ILogStorage? logStorage})
    : logStorage = logStorage ?? DebugStorage();
  
  void log(String message) {
    logStorage.addLog(DebugLog.create(
      level: LogLevel.info,
      message: message,
    ));
  }
}
```

---

## 🎓 Best Practices

### 1. Always Use Interfaces

```dart
// ✅ Good
final ILogStorage logStorage = DebugStorage();

// ❌ Bad
final DebugStorage storage = DebugStorage();
```

### 2. Initialize Before Use

```dart
final storage = DebugStorage();
await storage.initialize(); // Always initialize first
```

### 3. Use Factory Constructors

```dart
// ✅ Good - uses factory
final log = DebugLog.create(
  level: LogLevel.info,
  message: 'Test',
);

// ❌ Bad - manual ID generation
final log = DebugLog(
  id: '${DateTime.now().millisecondsSinceEpoch}',
  timestamp: DateTime.now(),
  level: LogLevel.info,
  message: 'Test',
);
```

### 4. Handle Errors

```dart
try {
  await storage.initialize();
} catch (e) {
  debugPrint('Failed to initialize storage: $e');
}
```

---

## 📚 Related Documentation

- [Main ARCHITECTURE.md](../../ARCHITECTURE.md) - Overall architecture
- [REFACTORING_SUMMARY.md](../../REFACTORING_SUMMARY.md) - Refactoring details
- [README.md](README.md) - Package overview

---

## ✨ Summary

The `base` package provides:

✅ **Clean Domain Models** - Immutable, serializable entities  
✅ **Clear Interfaces** - ISP-compliant abstractions  
✅ **Robust Storage** - In-memory and persistent storage  
✅ **SOLID Principles** - All principles applied  
✅ **Easy Testing** - Mockable interfaces  
✅ **Good Documentation** - Comprehensive docs  
✅ **No External Dependencies** - Only Flutter SDK + Hive  

**This package is the foundation of DebugHub's clean architecture!** 🎉

