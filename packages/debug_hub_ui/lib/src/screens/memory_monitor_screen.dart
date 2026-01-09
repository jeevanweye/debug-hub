import 'package:flutter/material.dart';
import 'package:memory_monitor/memory_monitor.dart';
import '../debug_hub_config.dart';
import 'dart:async';

class MemoryMonitorScreen extends StatefulWidget {
  final DebugHubConfig config;

  const MemoryMonitorScreen({
    super.key,
    required this.config,
  });

  @override
  State<MemoryMonitorScreen> createState() => _MemoryMonitorScreenState();
}

class _MemoryMonitorScreenState extends State<MemoryMonitorScreen> {
  final MemoryMonitor _monitor = MemoryMonitor();
  Timer? _uiUpdateTimer;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _monitor.startMonitoring(interval: const Duration(seconds: 5));
    
    // Update UI every second for smooth display
    _uiUpdateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _uiUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSnapshot = _monitor.getCurrentSnapshot();
    final stats = _monitor.getStatistics();
    final isMonitoring = _monitor.isMonitoring;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Monitor'),
        backgroundColor: widget.config.mainColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isMonitoring ? Icons.stop : Icons.play_arrow),
            onPressed: () {
              setState(() {
                if (isMonitoring) {
                  _monitor.stopMonitoring();
                  _uiUpdateTimer?.cancel();
                } else {
                  _startMonitoring();
                }
              });
            },
            tooltip: isMonitoring ? 'Stop Monitoring' : 'Start Monitoring',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              _monitor.clearSnapshots();
              setState(() {});
            },
            tooltip: 'Clear Snapshots',
          ),
        ],
      ),
      body: currentSnapshot == null
          ? _buildEmptyState()
          : _buildContent(currentSnapshot, stats),
    );
  }

  Widget _buildEmptyState() {
    final isMonitoring = _monitor.isMonitoring;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMonitoring ? Icons.memory : Icons.error_outline,
              size: 64,
              color: isMonitoring ? Colors.grey[400] : Colors.orange[400],
            ),
            const SizedBox(height: 16),
            Text(
              isMonitoring 
                  ? 'No memory data available'
                  : 'Memory monitoring unavailable',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isMonitoring
                  ? 'Memory monitoring is starting...\nPlease wait a moment.'
                  : 'Memory monitoring requires:\n'
                    '• Debug or Profile mode\n'
                    '• VM Service connection\n'
                    '• Active Flutter session',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            if (!isMonitoring) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _startMonitoring();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Connection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.config.mainColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(MemorySnapshot snapshot, MemoryStatistics stats) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCurrentUsageCard(snapshot),
        const SizedBox(height: 16),
        if (snapshot.deviceTotalRAMMB != null) ...[
          _buildDeviceMemoryCard(snapshot),
          const SizedBox(height: 16),
        ],
        _buildStatisticsCard(stats),
        const SizedBox(height: 16),
        _buildMemoryBreakdownCard(snapshot),
        const SizedBox(height: 16),
        _buildSnapshotHistoryCard(stats.snapshots),
      ],
    );
  }

  Widget _buildCurrentUsageCard(MemorySnapshot snapshot) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.memory, color: widget.config.mainColor),
                const SizedBox(width: 8),
                const Text(
                  'Current Memory Usage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMemoryBar(snapshot),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMemoryInfo(
                  'Used',
                  '${snapshot.usedMemoryMB} MB',
                  Colors.blue,
                ),
                _buildMemoryInfo(
                  'Free',
                  '${snapshot.freeMemoryMB} MB',
                  Colors.green,
                ),
                _buildMemoryInfo(
                  'Total',
                  '${snapshot.totalMemoryMB} MB',
                  Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryBar(MemorySnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Memory Usage',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '${snapshot.usagePercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getUsageColor(snapshot.usagePercentage),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: snapshot.usagePercentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getUsageColor(snapshot.usagePercentage),
            ),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryInfo(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard(MemoryStatistics stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Average Usage', '${stats.averageUsageMB.toStringAsFixed(1)} MB'),
            _buildStatRow('Peak Usage', '${stats.peakUsageMB.toStringAsFixed(1)} MB'),
            _buildStatRow('Minimum Usage', '${stats.minUsageMB.toStringAsFixed(1)} MB'),
            _buildStatRow('Average %', '${stats.averagePercentage.toStringAsFixed(1)}%'),
            _buildStatRow('Snapshots', '${stats.snapshots.length}'),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryBreakdownCard(MemorySnapshot snapshot) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Memory Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Dart Heap', '${snapshot.dartHeapMB} MB'),
            _buildStatRow('Dart Heap Capacity', '${snapshot.dartHeapCapacityMB} MB'),
            _buildStatRow('External Memory', '${snapshot.externalMemoryMB} MB'),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceMemoryCard(MemorySnapshot snapshot) {
    if (snapshot.deviceTotalRAMMB == null) {
      return const SizedBox.shrink();
    }

    final deviceUsage = snapshot.deviceMemoryUsagePercentage ?? 0.0;
    final deviceUsed = snapshot.deviceUsedRAMMB ?? 0;
    final deviceAvailable = snapshot.deviceAvailableRAMMB ?? 0;
    final deviceTotal = snapshot.deviceTotalRAMMB ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.phone_android, color: widget.config.mainColor),
                const SizedBox(width: 8),
                const Text(
                  'Device Memory',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDeviceMemoryBar(deviceUsage, deviceUsed, deviceTotal),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMemoryInfo(
                  'Used',
                  '$deviceUsed MB',
                  Colors.blue,
                ),
                _buildMemoryInfo(
                  'Available',
                  '$deviceAvailable MB',
                  Colors.green,
                ),
                _buildMemoryInfo(
                  'Total',
                  '$deviceTotal MB',
                  Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'App Memory vs Device',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${snapshot.usedMemoryMB} MB / $deviceTotal MB',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${((snapshot.usedMemoryMB / deviceTotal) * 100).toStringAsFixed(2)}% of device memory',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceMemoryBar(double percentage, int usedMB, int totalMB) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Device Memory Usage',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getUsageColor(percentage),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getUsageColor(percentage),
            ),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSnapshotHistoryCard(List<MemorySnapshot> snapshots) {
    if (snapshots.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Snapshots',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...snapshots.reversed.take(10).map((snapshot) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTime(snapshot.timestamp),
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${snapshot.usedMemoryMB} MB (${snapshot.usagePercentage.toStringAsFixed(1)}%)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Color _getUsageColor(double percentage) {
    if (percentage < 50) return Colors.green;
    if (percentage < 75) return Colors.orange;
    return Colors.red;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
           '${time.minute.toString().padLeft(2, '0')}:'
           '${time.second.toString().padLeft(2, '0')}';
  }
}

