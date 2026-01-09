import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:base/base.dart';
import '../debug_hub_config.dart';

class AppInfoScreen extends StatefulWidget {
  final DebugHubConfig config;

  const AppInfoScreen({super.key, required this.config});

  @override
  State<AppInfoScreen> createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends State<AppInfoScreen> {
  PackageInfo? _packageInfo;
  Map<String, dynamic>? _deviceInfo;
  bool _isLoading = true;
  String _storageSize = '0 B';
  Map<String, int> _itemCounts = {};

  @override
  void initState() {
    super.initState();
    _loadInfo();
    _loadStorageInfo();
  }

  Future<void> _loadStorageInfo() async {
    final storage = DebugStorage();
    final size = await storage.getStorageSizeFormatted();
    final counts = await storage.getItemCounts();

    if (mounted) {
      setState(() {
        _storageSize = size;
        _itemCounts = counts;
      });
    }
  }

  Future<void> _loadInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfoPlugin = DeviceInfoPlugin();
      Map<String, dynamic> deviceData = {};

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceData = {
          'Platform': 'Android',
          'Device': androidInfo.model,
          'Manufacturer': androidInfo.manufacturer,
          'OS Version':
              'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})',
          'Brand': androidInfo.brand,
          'Product': androidInfo.product,
          'Hardware': androidInfo.hardware,
          'Is Physical Device': androidInfo.isPhysicalDevice.toString(),
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceData = {
          'Platform': 'iOS',
          'Device': iosInfo.model,
          'Name': iosInfo.name,
          'OS Version': '${iosInfo.systemName} ${iosInfo.systemVersion}',
          'Model': iosInfo.utsname.machine,
          'Is Physical Device': iosInfo.isPhysicalDevice.toString(),
        };
      }

      setState(() {
        _packageInfo = packageInfo;
        _deviceInfo = deviceData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading info: $e')));
      }
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label copied to clipboard')));
  }

  void _copyAllInfo() {
    final buffer = StringBuffer();
    buffer.writeln('DebugHub App Information');
    buffer.writeln('=' * 50);
    buffer.writeln();

    if (_packageInfo != null) {
      buffer.writeln('Application Info:');
      buffer.writeln('  App Name: ${_packageInfo!.appName}');
      buffer.writeln('  Package Name: ${_packageInfo!.packageName}');
      buffer.writeln('  Version: ${_packageInfo!.version}');
      buffer.writeln('  Build Number: ${_packageInfo!.buildNumber}');
      buffer.writeln();
    }

    if (_deviceInfo != null) {
      buffer.writeln('Device Info:');
      _deviceInfo!.forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
      buffer.writeln();
    }

    buffer.writeln('Flutter Info:');
    buffer.writeln('  Dart Version: ${Platform.version}');
    buffer.writeln('  Platform: ${Platform.operatingSystem}');
    buffer.writeln('  OS Version: ${Platform.operatingSystemVersion}');

    buffer.writeln();
    buffer.writeln('Storage Info:');
    buffer.writeln('  Size: $_storageSize');
    buffer.writeln('  Logs: ${_itemCounts['logs'] ?? 0}');
    buffer.writeln('  Network Requests: ${_itemCounts['network'] ?? 0}');
    buffer.writeln('  Crashes: ${_itemCounts['crashes'] ?? 0}');
    buffer.writeln('  Events: ${_itemCounts['events'] ?? 0}');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All info copied to clipboard')),
    );
  }

  Future<void> _clearAllStorage() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Storage'),
        content: const Text(
          'This will permanently delete all stored debug data including:\n\n'
          '• Network requests\n'
          '• Logs\n'
          '• Crash reports\n'
          '• Analytics events\n\n'
          'This action cannot be undone. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Clearing storage...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      await DebugStorage().clearAll();
      await _loadStorageInfo();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ All storage cleared successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info'),
        backgroundColor: widget.config.mainColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _copyAllInfo,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.config.mainColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Storage Info Card (at top)
            _buildStorageCard(),
            const SizedBox(height: 16),

            // App Info
            if (_packageInfo != null) ...[
              _buildInfoCard(
                title: 'Application',
                icon: Icons.apps,
                items: [
                  _InfoItem('App Name', _packageInfo!.appName),
                  _InfoItem('Package Name', _packageInfo!.packageName),
                  _InfoItem('Version', _packageInfo!.version),
                  _InfoItem('Build Number', _packageInfo!.buildNumber),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Device Info
            if (_deviceInfo != null) ...[
              _buildInfoCard(
                title: 'Device',
                icon: Icons.phone_android,
                items: _deviceInfo!.entries
                    .map((e) => _InfoItem(e.key, e.value.toString()))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Flutter Info
            _buildInfoCard(
              title: 'Flutter',
              icon: Icons.flutter_dash,
              items: [
                _InfoItem('Dart Version', Platform.version.split(' ')[0]),
                _InfoItem('Platform', Platform.operatingSystem),
                _InfoItem('OS Version', Platform.operatingSystemVersion),
                _InfoItem(
                  'Number of Processors',
                  Platform.numberOfProcessors.toString(),
                ),
                _InfoItem('Path Separator', Platform.pathSeparator),
                _InfoItem('Locale', Platform.localeName),
              ],
            ),
            const SizedBox(height: 16),

            // Environment Info
            _buildInfoCard(
              title: 'Environment',
              icon: Icons.settings,
              items: [
                _InfoItem('Script', Platform.script.toString()),
                _InfoItem('Executable', Platform.executable),
                _InfoItem('Resolved Executable', Platform.resolvedExecutable),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<_InfoItem> items,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: widget.config.mainColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              item.value,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 16),
                            onPressed: () =>
                                _copyToClipboard(item.value, item.label),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageCard() {
    final totalItems = _itemCounts.values.fold(0, (sum, count) => sum + count);

    return Card(
      elevation: 2,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: widget.config.mainColor),
                const SizedBox(width: 8),
                const Text(
                  'Debug Storage',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Storage Used',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _storageSize,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.config.mainColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total Items',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalItems.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Item breakdown
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStorageChip(
                  'Logs',
                  _itemCounts['logs'] ?? 0,
                  Icons.article,
                ),
                _buildStorageChip(
                  'Network',
                  _itemCounts['network'] ?? 0,
                  Icons.network_check,
                ),
                _buildStorageChip(
                  'Crashes',
                  _itemCounts['crashes'] ?? 0,
                  Icons.warning_amber,
                ),
                _buildStorageChip(
                  'Events',
                  _itemCounts['events'] ?? 0,
                  Icons.analytics,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Clear storage button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _clearAllStorage,
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Clear All Storage'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageChip(String label, int count, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text('$label: $count'),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem(this.label, this.value);
}
