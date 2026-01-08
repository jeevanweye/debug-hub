# DebugHub Changes

## Latest Update: Always Visible Debug Bubble

### What Changed?

The debug bubble is now **always visible** in debug mode by default. The shake gesture to hide/show the bubble has been disabled by default.

### Why?

- **Better UX**: Developers want easy access to debug tools without having to shake the device
- **More Reliable**: No need to worry about the bubble disappearing
- **Easier Testing**: QA and testers can always access debug information
- **Mobile Friendly**: Shake gesture can be unreliable on some devices

### Configuration

The default configuration is now:

```dart
DebugHub().init(
  config: const DebugHubConfig(
    enableShakeGesture: false, // Bubble stays visible (default)
    showBubbleOnStart: true,
  ),
);
```

### Want Shake Gesture?

If you prefer the shake-to-hide/show behavior, you can enable it:

```dart
DebugHub().init(
  config: const DebugHubConfig(
    enableShakeGesture: true, // Enable shake to hide/show
  ),
);
```

### Features

✅ **Always Visible** - Bubble stays on screen in debug mode
✅ **Draggable** - Move the bubble anywhere on screen
✅ **Long Press** - Long press to clear all debug data
✅ **Tap** - Tap to open DebugHub interface
✅ **Optional Shake** - Can be enabled if needed

### Benefits

1. **Instant Access** - No need to shake device to access debug tools
2. **Better for Testing** - QA can always see and access debug information
3. **More Predictable** - Bubble behavior is consistent
4. **Works Everywhere** - No reliance on device sensors

### Migration

If you were using the shake gesture:

**Before:**
```dart
// Bubble would hide/show on shake
DebugHub().init(
  config: const DebugHubConfig(
    enableShakeGesture: true,
  ),
);
```

**After (Default):**
```dart
// Bubble always visible (no change needed)
DebugHub().init();
```

**To Keep Shake Gesture:**
```dart
// Explicitly enable shake gesture
DebugHub().init(
  config: const DebugHubConfig(
    enableShakeGesture: true,
  ),
);
```

### Summary

- ✅ Debug bubble is now always visible by default
- ✅ Shake gesture is disabled by default
- ✅ Can be re-enabled with `enableShakeGesture: true`
- ✅ Better developer experience
- ✅ More reliable access to debug tools

---

**Date**: January 8, 2026
**Version**: 1.0.0

