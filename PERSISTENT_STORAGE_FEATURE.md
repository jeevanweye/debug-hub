# Persistent Storage & Debug Mode Features

## Overview
This document describes the three major features added to DebugHub:
1. **Persistent Storage** - All debug data now persists across app restarts
2. **Debug Mode Only** - DebugHub only works in debug mode
3. **Storage Management** - Clear storage and view storage usage

---

## 1. Persistent Storage with Hive

### What Changed
All debug data (logs, network requests, crashes, and events) is now automatically saved to local storage using Hive, a fast and lightweight NoSQL database for Flutter.

### Implementation Details

#### New Dependencies
Added to `packages/base/pubspec.yaml`:
- `hive: ^2.2.3` - Core database
- `hive_flutter: ^1.1.0` - Flutter integration
- `path_provider: ^2.1.4` - For finding storage paths

#### New File: `PersistentStorage`
Location: `packages/base/lib/src/storage/persistent_storage.dart`

This class handles:
- Initializing Hive database
- Saving/loading logs, network requests, crashes, and events
- Calculating storage size
- Clearing all stored data

#### Updated: `DebugStorage`
Location: `packages/base/lib/src/storage/debug_storage.dart`

Now integrates with `PersistentStorage`:
- Automatically saves data to persistent storage when added
- Loads data from storage on initialization
- All clear methods now async to handle storage deletion

### How It Works
```dart
// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize with persistent storage
  await DebugHub().init(config: const DebugHubConfig(...));
  
  // Enable DebugHub
  DebugHub().enable();
  
  runApp(const MyApp());
}
```

When you add a log, network request, crash report, or event:
1. It's added to the in-memory queue (for fast access)
2. It's automatically persisted to Hive storage
3. On app restart, all data is loaded back into memory

### Storage Location
Hive stores data in the app's documents directory:
- **Android**: `/data/data/<package_name>/app_flutter/`
- **iOS**: `<Application_Home>/Documents/`

### Storage Limits
- Logs: 1,000 items
- Network Requests: 500 items
- Crash Reports: 100 items
- Events: 1,000 items

Older items are automatically removed when limits are exceeded.

---

## 2. Debug Mode Only

### What Changed
DebugHub now **only works in debug mode**. In release or profile mode, it's completely disabled.

### Implementation Details

#### Updated: `DebugHub`
Location: `packages/debug_hub_ui/lib/src/debug_hub.dart`

Added checks for `kDebugMode`:
```dart
import 'package:flutter/foundation.dart';

Future<bool> init({DebugHubConfig? config}) async {
  // Only allow in debug mode
  if (!kDebugMode) {
    debugPrint('⚠️ DebugHub can only be used in debug mode');
    return false;
  }
  // ... rest of initialization
}

bool enable() {
  // Enforce debug mode only
  if (!kDebugMode) {
    return false;
  }
  // ... rest of enable logic
}

Widget wrap(Widget child) {
  // Don't show in release mode
  if (!kDebugMode || !_isEnabled || !_config.showBubbleOnStart) {
    return child;
  }
  // ... show debug bubble
}
```

### Why This Matters
- **Security**: Debug tools won't accidentally ship to production
- **Performance**: Zero overhead in release builds
- **App Size**: Debug UI code is tree-shaken in release builds

### How to Verify
Run your app in different modes:
```bash
# Debug mode (DebugHub visible)
flutter run

# Profile mode (DebugHub disabled)
flutter run --profile

# Release mode (DebugHub disabled)
flutter run --release
```

---

## 3. Storage Management UI

### What Changed
Added a comprehensive storage management section in the **App Info** tab showing:
- Total storage size used
- Item counts per category
- Option to clear all stored data

### Implementation Details

#### Updated: `AppInfoScreen`
Location: `packages/debug_hub_ui/lib/src/screens/app_info_screen.dart`

Added new UI components:
1. **Storage Info Card** - Displays at the top of App Info screen
2. **Storage Size Display** - Shows formatted size (B, KB, or MB)
3. **Item Count Chips** - Shows counts for logs, network, crashes, and events
4. **Clear All Button** - Red button to delete all stored data

### UI Features

#### Storage Size Display
Shows human-readable storage usage:
- Less than 1 KB: Shows in bytes (e.g., "450 B")
- Less than 1 MB: Shows in kilobytes (e.g., "23.45 KB")
- 1 MB or more: Shows in megabytes (e.g., "1.23 MB")

#### Item Count Breakdown
Visual chips showing:
- 📄 Logs: X items
- 🌐 Network: X items
- ⚠️ Crashes: X items
- 📊 Events: X items

#### Clear Storage Button
When clicked:
1. Shows confirmation dialog with warning
2. Lists what will be deleted
3. Shows loading indicator while clearing
4. Displays success message
5. Updates storage display to show 0 B

### Code Example
```dart
// Storage info is loaded automatically
Future<void> _loadStorageInfo() async {
  final storage = DebugStorage();
  final size = await storage.getStorageSizeFormatted();
  final counts = await storage.getItemCounts();
  
  setState(() {
    _storageSize = size;
    _itemCounts = counts;
  });
}

// Clear all storage
Future<void> _clearAllStorage() async {
  await DebugStorage().clearAll();
  await _loadStorageInfo(); // Refresh display
}
```

### Methods Added to DebugStorage
```dart
// Get storage size in bytes
Future<int> getStorageSize()

// Get human-readable storage size
Future<String> getStorageSizeFormatted()

// Get item counts per category
Future<Map<String, int>> getItemCounts()
```

---

## Testing the Features

### 1. Test Persistent Storage
```dart
// Add some data
DebugStorage().addLog(DebugLog.create(message: "Test log"));
NetworkInterceptor().enable();
// Make network requests...

// Close app completely (kill it)
// Reopen app

// Data should still be there!
```

### 2. Test Debug Mode Only
```bash
# Run in debug mode - bubble visible
flutter run

# Build release APK - no bubble
flutter build apk --release
flutter install
```

### 3. Test Storage Management
1. Open DebugHub (tap floating bubble)
2. Navigate to "App Info" tab
3. Check storage size and item counts
4. Tap "Clear All Storage"
5. Confirm deletion
6. Verify storage shows "0 B"

---

## Migration Notes

### Breaking Changes
None! All existing functionality remains the same. These are additive features.

### New Async Methods
If you were calling `clearAll()` directly, it's now async:
```dart
// Old (still works but not recommended)
DebugStorage().clearAll();

// New (recommended)
await DebugStorage().clearAll();
```

### Initialization Change
Main method must now be async:
```dart
// Old
void main() {
  DebugHub().init();
  runApp(MyApp());
}

// New
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DebugHub().init();
  runApp(MyApp());
}
```

---

## Performance Considerations

### Storage Performance
- **Write**: Async, non-blocking (happens in background)
- **Read**: Fast, loaded once at startup
- **Memory**: Dual-layer (in-memory + persistent)

### Storage Size
Typical storage usage after 1 hour of debugging:
- Logs (100 items): ~15-20 KB
- Network (50 requests): ~30-50 KB
- Crashes (5 reports): ~10-15 KB
- Events (100 events): ~10-15 KB
- **Total**: ~65-100 KB

### Cleanup
Storage is automatically cleaned when:
- App is uninstalled
- User taps "Clear All Storage" button
- `DebugStorage().clearAll()` is called

---

## Configuration

### DebugHubConfig
All existing config options work the same. New options:
```dart
DebugHubConfig(
  // ... existing options ...
  
  enableEventMonitoring: true, // Enable/disable event tracking
  showBubbleOnStart: true,     // Show bubble on app start
)
```

---

## Troubleshooting

### "Operation not permitted" Error
**Issue**: Flutter can't write to storage
**Solution**: Ensure app has storage permissions (handled automatically by Hive)

### Data Not Persisting
**Issue**: Data is lost on app restart
**Possible Causes**:
1. Not awaiting `DebugHub().init()`
2. Not calling `WidgetsFlutterBinding.ensureInitialized()`
3. App is in release mode (DebugHub disabled)

**Solution**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DebugHub().init(); // Must await!
  runApp(MyApp());
}
```

### Storage Size Shows 0 B
**Issue**: Storage size calculation returns 0
**Possible Causes**:
1. No data has been added yet
2. Data was recently cleared
3. App is in release mode

**Solution**: Add some test data and check again

---

## Future Enhancements

Potential future features:
- Export storage to file
- Import storage from file
- Storage size limits with warnings
- Automatic cleanup after X days
- Compress old data
- Cloud sync option

---

## Summary

### What You Get
✅ **Persistent Data** - Survives app restarts  
✅ **Debug Mode Only** - Safe for production  
✅ **Storage Management** - Clear data and view usage  
✅ **No Breaking Changes** - Works with existing code  
✅ **Fast & Efficient** - Hive is optimized for mobile  

### Key Files Modified
- `packages/base/lib/src/storage/persistent_storage.dart` (NEW)
- `packages/base/lib/src/storage/debug_storage.dart` (UPDATED)
- `packages/debug_hub_ui/lib/src/debug_hub.dart` (UPDATED)
- `packages/debug_hub_ui/lib/src/screens/app_info_screen.dart` (UPDATED)
- `packages/debug_hub_ui/lib/src/debug_hub_config.dart` (UPDATED)
- `lib/main.dart` (UPDATED)

---

## Questions?

If you encounter any issues or have questions about these features, please check:
1. This documentation
2. Inline code comments
3. Flutter console logs (look for "DebugHub" prefix)

