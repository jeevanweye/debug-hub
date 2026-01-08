# Google Sheets Integration for Event Validation

This document describes the Google Sheets integration feature added to the DebugHub events package, which allows you to validate analytics events against a Google Sheets configuration.

## Overview

The Google Sheets integration provides functionality similar to the android_logger's event validation system. It allows you to:

1. Connect to Google Sheets using Google Sign-In
2. Fetch event definitions from a centralized Google Sheet
3. Compare logged events with expected events from the sheet
4. View detailed validation results with statistics
5. Share validation reports

## Features

- **Google Sign-In Integration**: Secure authentication with Google account
- **Master Sheet Configuration**: Centralized configuration for multiple apps
- **Version-based Validation**: Validate events against specific app versions
- **Detailed Comparison**: Compare event properties including action, category, screen name, etc.
- **Visual Results**: Color-coded results showing correct, incorrect, and missing events
- **Statistics Dashboard**: View summary statistics of validation results
- **Export Reports**: Share validation results via text report

## Architecture

### Models

1. **SheetEventInfo**: Represents an event with all its properties (name, action, category, screen, etc.)
2. **EventReportInfo**: Holds comparison results between sheet events and logged events
3. **MasterSheetInfo**: Configuration for which sheet to use for each app
4. **SheetVersionInfo**: Information about sheet versions/tabs

### Services

- **GoogleSheetsService**: Handles Google Sign-In and Google Sheets API calls

### Repository

- **EventValidationRepository**: Business logic layer for event validation

### Utilities

- **EventComparator**: Compares logged events with sheet events
- **EventConstants**: Configuration constants (base sheet ID, ranges, etc.)

### UI Screens

1. **EventValidationDashboardScreen**: Main screen for signing in and selecting version
2. **EventValidationResultsScreen**: Displays validation results with filtering

## Setup

### 1. Google Cloud Console Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable **Google Sheets API**
4. Enable **Google Sign-In API**
5. Create OAuth 2.0 credentials:
   - For Android: Add SHA-1 fingerprint
   - For iOS: Add bundle identifier
   - For Web: Add authorized domains

### 2. Android Configuration

Add to `android/app/build.gradle`:

```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

### 3. iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

### 4. Google Sheet Structure

#### Master Sheet (Base Configuration)

The master sheet should have the following structure:

| S.N | package_name | sheet_id | range | field |
|-----|--------------|----------|-------|-------|
| 1 | com.example.app | YOUR_SHEET_ID | !A2:I | events |

#### Event Sheet Structure

Each app's event sheet should have tabs for different versions with the following columns:

| S.N | event_name | event_action | event_category | screen_name | vehicle_id | entity | miscellaneous | target_product |
|-----|------------|--------------|----------------|-------------|------------|--------|---------------|----------------|
| 1 | button_click | click | navigation | home_screen | - | button_id:123 | - | app |

## Usage

### 1. Initialize Google Sheets Service

```dart
import 'package:events/events.dart';

// Initialize the service
final sheetsService = GoogleSheetsService();
await sheetsService.initialize();
```

### 2. Open Event Validation Dashboard

```dart
import 'package:events/events.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Get package name
final packageInfo = await PackageInfo.fromPlatform();
final packageName = packageInfo.packageName;

// Navigate to validation dashboard
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EventValidationDashboardScreen(
      packageName: packageName,
      config: yourDebugHubConfig, // Optional
    ),
  ),
);
```

### 3. Track Events with Sheet-Compatible Properties

```dart
import 'package:events/events.dart';
import 'package:base/base.dart';

// Use the extension method for sheet-compatible events
final event = AnalyticsEventSheetExtensions.createWithSheetProperties(
  eventName: 'button_click',
  eventAction: 'click',
  eventCategory: 'navigation',
  screenName: 'home_screen',
  entity: 'button_id:123',
  targetProduct: 'app',
  source: 'Firebase',
);

// Track the event
EventTracker().trackEvent(
  'button_click',
  properties: {
    'event_action': 'click',
    'event_category': 'navigation',
    'screen_name': 'home_screen',
    'entity': 'button_id:123',
    'target_product': 'app',
  },
  source: 'Firebase',
);
```

### 4. Programmatic Validation

```dart
import 'package:events/events.dart';

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

// Get versions
final versions = await repository.getSheetVersions(
  sheetId: config!.sheetId!,
);

// Get sheet events
final sheetEvents = await repository.getSheetEventData(
  sheetId: config.sheetId!,
  versionName: versions.first.title!,
  range: config.range!,
);

// Validate events
final results = await repository.validateEvents(
  sheetEvents: sheetEvents,
);

// Get statistics
final stats = repository.getComparisonStats(results);
print('Total: ${stats.total}');
print('Correct: ${stats.correct}');
print('Not Found: ${stats.notFound}');
```

## Event Comparison Logic

The comparison logic handles several special cases:

### 1. Dynamic Screen Names

Events with screen names marked as "dynamic" or "user's screen" in the sheet will match any screen name in the logged event.

### 2. Vehicle ID Validation

If the sheet specifies "YES" for vehicle_id, the validator checks that the logged event has a non-empty vehicle_id.

### 3. Miscellaneous and Entity Fields

These fields support key-value pairs separated by "::" (double colon). The validator checks that all keys present in the sheet are also present in the logged event.

Example:
- Sheet: `key1:value1::key2:value2`
- Log: `key1:actualValue1::key2:actualValue2::key3:extra`
- Result: ✓ Match (all sheet keys are present)

### 4. Event Matching

Events are matched by:
1. Event name (exact match)
2. Event action (exact match)
3. Event category (exact match)
4. Screen name (with dynamic screen support)
5. Vehicle ID (with presence validation)
6. Entity and miscellaneous (with key matching)
7. Target product (exact match)

## Constants Configuration

Update `EventConstants` to customize the base sheet configuration:

```dart
class EventConstants {
  // Base Google Sheet ID for master configuration
  static const String baseSheetId = 'YOUR_MASTER_SHEET_ID';
  
  // Range in the master sheet to read configuration
  static const String baseSheetRange = 'app_sheet!A2:E';
}
```

## Validation Results

The validation results screen shows:

### Summary Statistics
- **Total Events**: Total number of events in the sheet
- **Correct**: Events found and matching exactly
- **Not Found**: Events not present in device logs
- **Incorrect**: Events found but with different properties

### Filtering Options
- View all events
- Filter by correct events only
- Filter by incorrect events only
- Filter by not found events only

### Event Details
Tap on any event to see:
- Expected properties (from sheet)
- Actual properties (from device logs)
- Detailed comparison
- Copy to clipboard option

## Best Practices

1. **Consistent Event Naming**: Use consistent naming conventions for events across your app
2. **Document Dynamic Fields**: Clearly mark dynamic fields in your sheet
3. **Version Management**: Create separate tabs for each app version
4. **Regular Validation**: Validate events before each release
5. **Share Reports**: Share validation reports with QA team

## Troubleshooting

### Sign-In Issues
- Ensure OAuth credentials are properly configured
- Check SHA-1 fingerprint for Android
- Verify bundle identifier for iOS

### Sheet Access Issues
- Ensure the Google account has access to the sheet
- Check that the sheet ID is correct
- Verify the range format

### Event Matching Issues
- Check for typos in event names
- Verify property names match exactly
- Review dynamic field configurations

## Migration from android_logger

If you're migrating from android_logger, the concepts are similar:

| android_logger | DebugHub Events |
|----------------|-----------------|
| WeEventInfo | SheetEventInfo |
| EventReportsInfo | EventReportInfo |
| SheetClient | GoogleSheetsService |
| SheetDashBoardDataSource | EventValidationRepository |
| compareEvents() | EventComparator.compareEvents() |

The main differences:
- Uses Flutter's google_sign_in instead of Android's GoogleSignIn
- Uses googleapis package instead of Android's Sheets API
- Provides Flutter UI screens instead of Android Activities
- Uses Freezed for immutable models

## Example Integration in DebugHub UI

To add event validation to the DebugHub main screen:

```dart
// In debug_hub_ui package
import 'package:events/events.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Add a button in EventsScreen
IconButton(
  icon: const Icon(Icons.cloud_sync),
  onPressed: () async {
    final packageInfo = await PackageInfo.fromPlatform();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventValidationDashboardScreen(
          packageName: packageInfo.packageName,
          config: widget.config,
        ),
      ),
    );
  },
  tooltip: 'Validate with Google Sheets',
),
```

## License

MIT License - Same as DebugHub

