# Google Sheets Event Validation - Quick Reference

## Quick Start (5 Minutes)

### 1. Open Validation Dashboard
```dart
import 'package:events/events.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfo = await PackageInfo.fromPlatform();
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EventValidationDashboardScreen(
      packageName: packageInfo.packageName,
    ),
  ),
);
```

### 2. Sign In → Select Version → Validate → View Results

That's it! 🎉

## Track Sheet-Compatible Events

```dart
EventTracker().trackEvent(
  'button_click',
  properties: {
    'event_action': 'click',
    'event_category': 'navigation',
    'screen_name': 'home_screen',
    'entity': 'button_id:submit',
    'target_product': 'app',
  },
  source: 'Firebase',
);
```

## Google Sheet Structure

### Master Sheet
| S.N | package_name | sheet_id | range | field |
|-----|--------------|----------|-------|-------|
| 1 | com.your.app | YOUR_SHEET_ID | !A2:I | events |

### Event Sheet (Tab: v1.0.0)
| S.N | event_name | event_action | event_category | screen_name | vehicle_id | entity | miscellaneous | target_product |
|-----|------------|--------------|----------------|-------------|------------|--------|---------------|----------------|
| 1 | button_click | click | navigation | home_screen | - | button_id:submit | - | app |

## Configuration

### EventConstants
```dart
class EventConstants {
  static const String baseSheetId = 'YOUR_MASTER_SHEET_ID';
  static const String baseSheetRange = 'app_sheet!A2:E';
}
```

### Android Setup
```gradle
// android/app/build.gradle
dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

### iOS Setup
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

## API Reference

### GoogleSheetsService
```dart
final service = GoogleSheetsService();
await service.initialize();
await service.signIn();
final versions = await service.getSheetVersions(sheetId: 'ID');
```

### EventValidationRepository
```dart
final repo = EventValidationRepository();
await repo.signIn();
final masterSheets = await repo.getMasterSheetInfo();
final config = repo.findSheetForPackage(
  masterSheets: masterSheets,
  packageName: 'com.example.app',
);
final results = await repo.validateEvents(sheetEvents: events);
final stats = repo.getComparisonStats(results);
```

### EventComparator
```dart
final results = EventComparator.compareEvents(
  loggedEvents: loggedEvents,
  sheetEvents: sheetEvents,
);
final stats = EventComparator.getStats(results);
```

## Event Properties

| Property | Description | Example |
|----------|-------------|---------|
| event_name | Event identifier | `button_click` |
| event_action | Action type | `click`, `view`, `submit` |
| event_category | Event category | `navigation`, `user_action` |
| screen_name | Screen identifier | `home_screen`, `dynamic` |
| vehicle_id | Vehicle/demand ID | `123`, `YES` (for validation) |
| entity | Entity info | `button_id:submit` |
| miscellaneous | Extra data | `key1:val1::key2:val2` |
| target_product | Target product | `app`, `web` |

## Special Cases

### Dynamic Screens
Sheet: `dynamic` or `user's screen` → Matches any screen in logs

### Vehicle ID Validation
Sheet: `YES` → Checks that log has non-empty vehicle_id

### Key-Value Pairs
Sheet: `key1:val1::key2:val2`  
Log: `key1:actual1::key2:actual2::key3:extra`  
Result: ✅ Match (all sheet keys present)

## Validation Results

### Status Colors
- 🟢 Green: Correct (found and matches)
- 🟠 Orange: Incorrect (found but doesn't match)
- 🔴 Red: Not Found (missing in logs)

### Statistics
- **Total**: Total events in sheet
- **Correct**: Events matching exactly
- **Not Found**: Events missing in logs
- **Incorrect**: Events found but different

## Common Issues

### "Not signed in"
→ Configure OAuth in Google Cloud Console

### "No sheet configuration found"
→ Add your package to master sheet

### Events not matching
→ Check property names and values

### Permission denied
→ Ensure Google account has sheet access

## Documentation

- `README.md` - Package overview
- `GOOGLE_SHEETS_INTEGRATION.md` - Full guide
- `INTEGRATION_EXAMPLE.md` - Step-by-step example
- `IMPLEMENTATION_SUMMARY.md` - Technical details

## Support

For issues or questions, refer to the comprehensive documentation in the package.

