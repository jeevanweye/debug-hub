# Memory Monitor Guide 🧠

Complete guide for using the Memory Monitor feature in DebugHub.

## Overview

The Memory Monitor provides real-time tracking of your Flutter app's memory usage, helping you identify memory leaks, optimize performance, and understand memory patterns.

## Features

- ✅ Real-time memory usage tracking
- ✅ Dart heap monitoring
- ✅ External memory tracking
- ✅ Memory statistics (average, peak, minimum)
- ✅ Snapshot history
- ✅ Visual memory usage graphs
- ✅ Automatic monitoring intervals
- ✅ Manual garbage collection trigger

## Accessing Memory Monitor

### Through More Tab

1. Open DebugHub (tap floating bubble or shake device)
2. Navigate to **More** tab (bottom navigation)
3. Tap on **Memory Monitor**

## Memory Metrics

### Current Usage

- **Used Memory**: Total memory currently in use (Dart heap + external)
- **Free Memory**: Available memory capacity
- **Total Memory**: Total memory capacity
- **Usage Percentage**: Used / Total * 100

### Memory Breakdown

- **Dart Heap**: Memory used by Dart objects
- **Dart Heap Capacity**: Maximum Dart heap size
- **External Memory**: Memory used by native resources (images, plugins, etc.)

### Statistics

- **Average Usage**: Mean memory usage across all snapshots
- **Peak Usage**: Maximum memory usage recorded
- **Minimum Usage**: Lowest memory usage recorded
- **Average %**: Average usage percentage

## Using Memory Monitor

### Automatic Monitoring

Memory monitoring starts automatically when you open the Memory Monitor screen with:
- **Interval**: 5 seconds between snapshots
- **Max Snapshots**: 100 (oldest are removed automatically)

### Manual Controls

```dart
import 'package:memory_monitor/memory_monitor.dart';

final monitor = MemoryMonitor();

// Start monitoring
await monitor.startMonitoring(
  interval: Duration(seconds: 5),
);

// Stop monitoring
monitor.stopMonitoring();

// Get current snapshot
final snapshot = monitor.getCurrentSnapshot();

// Get statistics
final stats = monitor.getStatistics();

// Clear snapshots
monitor.clearSnapshots();

// Force garbage collection (for testing)
await monitor.forceGC();
```

## Understanding Memory Data

### Normal Memory Usage

```
Used: 50-150 MB
Percentage: 30-60%
```

### Warning Signs

```
Used: 150-300 MB
Percentage: 60-80%
```

⚠️ **Actions to take:**
- Check for memory leaks
- Review large data structures
- Optimize image loading

### Critical Memory Usage

```
Used: >300 MB
Percentage: >80%
```

🚨 **Immediate actions:**
- Trigger garbage collection
- Release unused resources
- Review memory-intensive operations
- Check for circular references

## Memory Leak Detection

### Signs of Memory Leaks

1. **Continuous Growth**: Memory usage increases over time without dropping
2. **High Minimum**: Minimum usage keeps increasing
3. **No Releases**: Memory doesn't decrease after operations

### Debugging Steps

1. **Take Baseline**
   - Start app
   - Note initial memory usage
   
2. **Perform Actions**
   - Navigate through screens
   - Load data
   - Execute operations
   
3. **Return to Baseline**
   - Close screens
   - Clear data
   - Check if memory returns to baseline

4. **Analyze**
   - If memory doesn't return: likely leak
   - Check snapshots for patterns
   - Review recent code changes

## Common Memory Issues

### 1. Image Loading

**Problem**: Large images not released

```dart
// ❌ Bad
Image.network('https://example.com/large-image.jpg')

// ✅ Good
Image.network(
  'https://example.com/large-image.jpg',
  cacheHeight: 400, // Limit dimensions
  cacheWidth: 400,
)
```

### 2. Stream Subscriptions

**Problem**: Streams not cancelled

```dart
// ❌ Bad
StreamSubscription? subscription;

void initState() {
  subscription = stream.listen(...);
}
// No disposal!

// ✅ Good
StreamSubscription? subscription;

void initState() {
  subscription = stream.listen(...);
}

void dispose() {
  subscription?.cancel();
  super.dispose();
}
```

### 3. Controllers

**Problem**: Controllers not disposed

```dart
// ❌ Bad
final controller = TextEditingController();
// No disposal!

// ✅ Good
final controller = TextEditingController();

void dispose() {
  controller.dispose();
  super.dispose();
}
```

### 4. Large Collections

**Problem**: Unbounded lists/maps

```dart
// ❌ Bad
final List<Data> _data = [];
void addData(Data item) {
  _data.add(item); // Grows indefinitely
}

// ✅ Good
final Queue<Data> _data = Queue();
final int _maxSize = 100;

void addData(Data item) {
  _data.add(item);
  if (_data.length > _maxSize) {
    _data.removeFirst();
  }
}
```

## Best Practices

### 1. Monitor During Development

- Keep Memory Monitor open during testing
- Watch for unusual spikes
- Check memory after each feature
- Test navigation flows

### 2. Profile Regular Workflows

- Login/logout cycles
- Screen navigation
- Data loading
- Image rendering

### 3. Test Edge Cases

- Large data sets
- Multiple images
- Long-running operations
- Background tasks

### 4. Establish Baselines

- Note normal memory ranges
- Document expected usage
- Track changes over time
- Set up alerts for abnormal usage

## Interpreting Results

### Healthy Pattern

```
📊 Memory Usage Pattern:
Time     Used    Percentage
10:00    50 MB   30%
10:05    65 MB   38%  ← Load data
10:10    55 MB   32%  ← Released
10:15    52 MB   31%  ← Stable
```

✅ Memory increases during operations, then returns to baseline

### Memory Leak Pattern

```
📊 Memory Usage Pattern:
Time     Used    Percentage
10:00    50 MB   30%
10:05    85 MB   45%  ← Load data
10:10    75 MB   42%  ← Partial release
10:15    90 MB   48%  ← Higher than before
10:20    105 MB  55%  ← Continuous growth
```

❌ Memory keeps increasing without returning to baseline

## Optimization Tips

### 1. Lazy Loading

```dart
// Load data as needed
ListView.builder(
  itemBuilder: (context, index) {
    return LazyLoadedItem(index: index);
  },
);
```

### 2. Image Caching

```dart
// Use cached network image
CachedNetworkImage(
  imageUrl: url,
  maxHeightDiskCache: 400,
  maxWidthDiskCache: 400,
);
```

### 3. Dispose Resources

```dart
class MyWidget extends StatefulWidget {
  @override
  void dispose() {
    // Dispose controllers
    // Cancel subscriptions
    // Release resources
    super.dispose();
  }
}
```

### 4. Use const Constructors

```dart
// ✅ Reuses existing instance
const Text('Hello');
const Icon(Icons.home);
```

## Integration with CI/CD

### Automated Memory Tests

```dart
testWidgets('Memory usage stays within bounds', (tester) async {
  final monitor = MemoryMonitor();
  await monitor.startMonitoring();
  
  // Perform operations
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byType(Button));
  await tester.pump();
  
  // Check memory
  final stats = monitor.getStatistics();
  expect(stats.peakUsageMB, lessThan(200.0));
  
  monitor.stopMonitoring();
});
```

## Troubleshooting

### Monitor Not Working

**Problem**: "VM Service not available"

**Solution**:
- Only works in debug mode
- Profile mode may have limited access
- Release mode: VM Service is disabled

### High Memory Usage

**Problem**: Consistently high memory

**Steps**:
1. Check snapshot history for patterns
2. Review recent code changes
3. Test on different devices
4. Use Flutter DevTools for detailed analysis
5. Profile with `flutter run --profile`

### Snapshots Not Updating

**Problem**: Snapshot count stays at 0

**Solution**:
- Check if monitoring is started
- Verify VM Service connection
- Restart app
- Check console for errors

## Advanced Usage

### Custom Monitoring Intervals

```dart
// Fast monitoring (every 1 second)
await monitor.startMonitoring(
  interval: Duration(seconds: 1),
);

// Slow monitoring (every 30 seconds)
await monitor.startMonitoring(
  interval: Duration(seconds: 30),
);
```

### Programmatic Access

```dart
// Get all snapshots
final snapshots = monitor.snapshots;

// Filter by time range
final recentSnapshots = snapshots.where((s) =>
  s.timestamp.isAfter(DateTime.now().subtract(Duration(minutes: 5)))
).toList();

// Find peak usage time
final peak = snapshots.reduce((a, b) =>
  a.usedMemoryMB > b.usedMemoryMB ? a : b
);
```

### Export Memory Data

```dart
// Export to JSON
final data = monitor.snapshots.map((s) => {
  'timestamp': s.timestamp.toIso8601String(),
  'used_mb': s.usedMemoryMB,
  'percentage': s.usagePercentage,
}).toList();

// Save or share
final json = jsonEncode(data);
```

## FAQ

### Q: When should I use Memory Monitor?

**A**: Use it when:
- Developing new features
- Investigating performance issues
- Testing for memory leaks
- Optimizing app performance
- Before releasing updates

### Q: What's a normal memory usage?

**A**: It varies by app, but generally:
- Simple apps: 30-80 MB
- Medium apps: 80-150 MB
- Complex apps: 150-300 MB
- Apps with media: 200-500 MB

### Q: How often should I check memory?

**A**: 
- During development: Every feature
- Before release: Full app test
- After reports: When users report issues
- Regular audits: Monthly or quarterly

### Q: Can I use this in production?

**A**: Memory Monitor only works in debug/profile mode. DebugHub is automatically disabled in release builds for security and performance.

## Resources

- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/best-practices)
- [Memory Profiling](https://flutter.dev/docs/development/tools/devtools/memory)
- [Dart VM Service](https://github.com/dart-lang/sdk/tree/main/runtime/vm/service)

## Support

For issues or questions:
1. Check this guide
2. Review example app
3. Open an issue on GitHub

---

**Made with ❤️ for Flutter developers**

*Monitor wisely, optimize efficiently!* 🧠✨

