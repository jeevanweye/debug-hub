# Memory Monitor Package

A memory usage monitoring package for DebugHub.

## Features

- **Real-time Monitoring**: Track memory usage at configurable intervals
- **Memory Statistics**: Calculate average, peak, and minimum usage
- **Dart Heap Tracking**: Monitor Dart heap and external memory
- **Snapshot History**: Keep history of memory snapshots
- **Force GC**: Trigger garbage collection for testing

## Usage

```dart
import 'package:memory_monitor/memory_monitor.dart';

// Start monitoring
await MemoryMonitor().startMonitoring(
  interval: Duration(seconds: 5),
);

// Get current snapshot
final snapshot = MemoryMonitor().getCurrentSnapshot();

// Get statistics
final stats = MemoryMonitor().getStatistics();

// Stop monitoring
MemoryMonitor().stopMonitoring();
```

## Models

### MemorySnapshot
Represents memory usage at a specific point in time.

### MemoryStatistics
Provides aggregated statistics over a period.

