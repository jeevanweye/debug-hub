# Events Package

Analytics event tracking and validation package for DebugHub.

## Features

- 📊 **Event Tracking**: Track analytics events from multiple sources (CleverTap, Firebase, Custom)
- ☁️ **Google Sheets Integration**: Validate events against Google Sheets configuration
- 🔍 **Event Comparison**: Compare logged events with expected events
- 📈 **Statistics Dashboard**: View validation statistics and results
- 📤 **Export Reports**: Share validation reports
- 🎯 **Version-based Validation**: Validate events for specific app versions

## Quick Start

### Basic Event Tracking

```dart
import 'package:events/events.dart';

// Initialize
EventTracker().enable();

// Track an event
EventTracker().trackEvent(
  'button_click',
  properties: {
    'screen': 'home',
    'button_id': 'submit',
  },
  source: 'Firebase',
);

// Get all events
final events = EventTracker().getEvents();
```

### Google Sheets Validation

See [GOOGLE_SHEETS_INTEGRATION.md](GOOGLE_SHEETS_INTEGRATION.md) for detailed documentation.

```dart
import 'package:events/events.dart';

// Open validation dashboard
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EventValidationDashboardScreen(
      packageName: 'com.example.app',
    ),
  ),
);
```

## Getting Started

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  events:
    path: ../events
```

### Basic Setup

```dart
import 'package:events/events.dart';

void main() {
  // Enable event tracking
  EventTracker().enable();
  
  runApp(MyApp());
}
```

## Usage

### Track Events

```dart
// Track a CleverTap event
EventTracker().trackCleverTapEvent(
  'product_viewed',
  properties: {
    'product_id': '123',
    'category': 'electronics',
  },
);

// Track a Firebase event
EventTracker().trackFirebaseEvent(
  'screen_view',
  properties: {
    'screen_name': 'home',
  },
);

// Track a custom event
EventTracker().trackCustomEvent(
  'feature_used',
  properties: {
    'feature': 'dark_mode',
  },
);
```

### Track Events with Sheet-Compatible Properties

```dart
import 'package:events/events.dart';

// Use extension method for Google Sheets compatibility
final event = AnalyticsEventSheetExtensions.createWithSheetProperties(
  eventName: 'button_click',
  eventAction: 'click',
  eventCategory: 'navigation',
  screenName: 'home_screen',
  entity: 'button_id:123',
  targetProduct: 'app',
  source: 'Firebase',
);
```

### Google Sheets Integration

#### 1. Setup Google Cloud Console

1. Create a project in Google Cloud Console
2. Enable Google Sheets API
3. Enable Google Sign-In API
4. Create OAuth 2.0 credentials

#### 2. Open Validation Dashboard

```dart
import 'package:events/events.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Get package name
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

#### 3. Programmatic Validation

```dart
final repository = EventValidationRepository();

// Sign in
await repository.signIn();

// Get master sheet info
final masterSheets = await repository.getMasterSheetInfo();

// Find configuration for your app
final config = repository.findSheetForPackage(
  masterSheets: masterSheets,
  packageName: 'com.example.app',
);

// Get sheet events
final sheetEvents = await repository.getSheetEventData(
  sheetId: config!.sheetId!,
  versionName: 'v1.0.0',
  range: config.range!,
);

// Validate events
final results = await repository.validateEvents(
  sheetEvents: sheetEvents,
);

// Get statistics
final stats = repository.getComparisonStats(results);
```

## Documentation

- [Google Sheets Integration Guide](GOOGLE_SHEETS_INTEGRATION.md) - Comprehensive guide for Google Sheets validation
- [API Documentation](lib/) - Detailed API documentation

## Architecture

### Models
- `SheetEventInfo`: Event with all properties
- `EventReportInfo`: Comparison results
- `MasterSheetInfo`: Sheet configuration
- `SheetVersionInfo`: Version information

### Services
- `GoogleSheetsService`: Google Sheets API integration

### Repository
- `EventValidationRepository`: Event validation logic

### Utilities
- `EventComparator`: Event comparison logic
- `EventConstants`: Configuration constants

### UI
- `EventValidationDashboardScreen`: Main validation screen
- `EventValidationResultsScreen`: Results display

## Dependencies

```yaml
dependencies:
  base: ^1.0.0
  google_sign_in: ^6.2.1
  googleapis: ^13.2.0
  googleapis_auth: ^1.6.0
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
```

## Additional Information

### Contributing

This package is part of the DebugHub project. For contributions, please refer to the main DebugHub repository.

### Issues

Report issues on the [DebugHub GitHub repository](https://github.com/your-repo/debughub).

### License

MIT License
