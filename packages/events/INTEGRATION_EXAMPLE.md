# Integration Example: Adding Event Validation to DebugHub UI

This guide shows how to integrate the Google Sheets event validation feature into the DebugHub UI package.

## Step 1: Update EventsScreen

Add a validation button to the existing `EventsScreen` in the `debug_hub_ui` package.

### File: `packages/debug_hub_ui/lib/src/screens/events_screen.dart`

Add the validation button to the actions row:

```dart
// Add import at the top
import 'package:events/events.dart';
import 'package:package_info_plus/package_info_plus.dart';

// In the _EventsScreenState class, add this method:
Future<void> _openValidation() async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventValidationDashboardScreen(
            packageName: packageInfo.packageName,
            config: widget.config,
          ),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

// Update the actions row in the build method:
Row(
  children: [
    IconButton(
      icon: const Icon(Icons.cloud_sync),
      onPressed: _openValidation,
      tooltip: 'Validate with Google Sheets',
    ),
    IconButton(
      icon: const Icon(Icons.share),
      onPressed: _shareAll,
      tooltip: 'Share all',
    ),
    IconButton(
      icon: const Icon(Icons.delete_outline),
      onPressed: _clearAll,
      tooltip: 'Clear all',
    ),
    IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () => setState(() {}),
      tooltip: 'Refresh',
    ),
  ],
),
```

## Step 2: Update DebugHubConfig (Optional)

If you want to make the validation feature configurable:

### File: `packages/debug_hub_ui/lib/src/debug_hub_config.dart`

```dart
class DebugHubConfig {
  final Color mainColor;
  final bool enableNetworkMonitoring;
  final bool enableLogMonitoring;
  final bool enableCrashMonitoring;
  final bool enableEventMonitoring;
  final bool enableEventValidation; // Add this
  final Widget? additionalTab;
  final String? additionalTabLabel;
  final IconData? additionalTabIcon;

  const DebugHubConfig({
    this.mainColor = Colors.blue,
    this.enableNetworkMonitoring = true,
    this.enableLogMonitoring = true,
    this.enableCrashMonitoring = true,
    this.enableEventMonitoring = true,
    this.enableEventValidation = true, // Add this
    this.additionalTab,
    this.additionalTabLabel,
    this.additionalTabIcon,
  });
}
```

Then update the EventsScreen to check this flag:

```dart
// Only show validation button if enabled
if (widget.config.enableEventValidation)
  IconButton(
    icon: const Icon(Icons.cloud_sync),
    onPressed: _openValidation,
    tooltip: 'Validate with Google Sheets',
  ),
```

## Step 3: Initialize Google Sheets Service

### File: `packages/debug_hub_ui/lib/src/debug_hub.dart`

Add initialization in the `init` method:

```dart
import 'package:events/events.dart';

Future<bool> init({DebugHubConfig? config}) async {
  // Only allow in debug mode
  if (!kDebugMode) {
    debugPrint('⚠️ DebugHub can only be used in debug mode');
    return false;
  }

  _config = config ?? const DebugHubConfig();
  
  // Initialize persistent storage
  await DebugStorage().initialize();
  
  // Initialize Google Sheets service for event validation
  if (_config.enableEventValidation) {
    try {
      await GoogleSheetsService().initialize();
    } catch (e) {
      debugPrint('⚠️ Failed to initialize Google Sheets: $e');
    }
  }
  
  return true;
}
```

## Step 4: Configure Google Sign-In

### Android Setup

#### File: `android/app/build.gradle`

```gradle
dependencies {
    // ... other dependencies
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

#### File: `android/app/src/main/AndroidManifest.xml`

No changes needed - google_sign_in plugin handles this automatically.

### iOS Setup

#### File: `ios/Runner/Info.plist`

Add your OAuth client ID:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Replace with your reversed client ID -->
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>

<key>GIDClientID</key>
<string>YOUR-CLIENT-ID.apps.googleusercontent.com</string>
```

## Step 5: Update Event Tracking

To make events compatible with Google Sheets validation, update your event tracking calls:

### Before:
```dart
EventTracker().trackEvent(
  'button_click',
  properties: {
    'screen': 'home',
  },
);
```

### After (Sheet-Compatible):
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

Or use the helper extension:

```dart
import 'package:events/events.dart';

final event = AnalyticsEventSheetExtensions.createWithSheetProperties(
  eventName: 'button_click',
  eventAction: 'click',
  eventCategory: 'navigation',
  screenName: 'home_screen',
  entity: 'button_id:submit',
  targetProduct: 'app',
  source: 'Firebase',
);
```

## Step 6: Setup Google Sheet

### Master Sheet Structure

Create a master sheet with ID configured in `EventConstants.baseSheetId`:

| S.N | package_name | sheet_id | range | field |
|-----|--------------|----------|-------|-------|
| 1 | com.your.app | YOUR_EVENT_SHEET_ID | !A2:I | events |

### Event Sheet Structure

Create an event sheet with tabs for each version:

Tab name: `v1.0.0` (or your version)

| S.N | event_name | event_action | event_category | screen_name | vehicle_id | entity | miscellaneous | target_product |
|-----|------------|--------------|----------------|-------------|------------|--------|---------------|----------------|
| 1 | button_click | click | navigation | home_screen | - | button_id:submit | - | app |
| 2 | screen_view | view | navigation | home_screen | - | - | - | app |

## Step 7: Test the Integration

1. Run your app in debug mode
2. Open DebugHub
3. Navigate to the Events tab
4. Tap the cloud sync icon (☁️)
5. Sign in with Google
6. Select your app version
7. Tap "Validate Events"
8. View the results

## Complete Example

Here's a complete example of an updated EventsScreen with validation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/base.dart';
import 'package:events/events.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../debug_hub_config.dart';

class EventsScreen extends StatefulWidget {
  final DebugHubConfig config;

  const EventsScreen({
    super.key,
    required this.config,
  });

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final DebugStorage _storage = DebugStorage();
  String _searchQuery = '';
  String? _selectedSource;

  // ... existing methods ...

  Future<void> _openValidation() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventValidationDashboardScreen(
              packageName: packageInfo.packageName,
              config: widget.config,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... existing build code ...
    
    // In the actions row:
    Row(
      children: [
        if (widget.config.enableEventValidation)
          IconButton(
            icon: const Icon(Icons.cloud_sync),
            onPressed: _openValidation,
            tooltip: 'Validate with Google Sheets',
          ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareAll,
          tooltip: 'Share all',
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: _clearAll,
          tooltip: 'Clear all',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => setState(() {}),
          tooltip: 'Refresh',
        ),
      ],
    ),
    
    // ... rest of build code ...
  }
}
```

## Troubleshooting

### Issue: "Not signed in" error
**Solution**: Ensure Google Sign-In is properly configured with correct OAuth credentials.

### Issue: "No sheet configuration found"
**Solution**: Check that your package name is correctly added to the master sheet.

### Issue: Events not matching
**Solution**: Verify that event properties match the expected format in the sheet.

### Issue: Permission denied on sheet
**Solution**: Ensure the signed-in Google account has access to the sheet.

## Next Steps

1. Configure your Google Cloud Console project
2. Set up your master sheet and event sheets
3. Update your event tracking to use sheet-compatible properties
4. Test the validation flow
5. Share validation reports with your QA team

For more details, see [GOOGLE_SHEETS_INTEGRATION.md](GOOGLE_SHEETS_INTEGRATION.md).

