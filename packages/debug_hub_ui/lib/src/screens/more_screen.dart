import 'package:flutter/material.dart';
import '../debug_hub_config.dart';
import 'app_info_screen.dart';
import 'crashes_screen.dart';
import 'package:base/base.dart';
import 'device_details_screen.dart';

class MoreScreen extends StatelessWidget {
  final DebugHubConfig config;

  const MoreScreen({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildSectionHeader('Debug Tools'),
        _buildFeatureTile(
          context,
          icon: Icons.notifications,
          title: 'Crashes',
          subtitle: 'View Crash logs',
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CrashesScreen(config: config),
              ),
            );
          },
        ),

        _buildFeatureTile(
          context,
          icon: Icons.network_check,
          title: 'Device Details',
          subtitle: 'View device ID and FCM token',
          color: Colors.purple,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DeviceDetailsScreen(
                  dataItems: {
                    'Device Name': 'Pixel 7',
                    'Device ID': '1234567890',
                    'Platform': 'Android',
                    'App Version': '1.0.0',
                    'FCM Token': 'fcm_token_goes_here',
                    'Access Token': 'access_token_goes_here',
                  },
                ),
              ),
            );
          },
        ),

        _buildFeatureTile(
          context,
          icon: Icons.info_outline,
          title: 'App Info',
          subtitle: 'Device and app information',
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppInfoScreen(config: config),
              ),
            );
          },
        ),

        const Divider(height: 32),

        _buildSectionHeader('Advanced'),
        _buildFeatureTile(
          context,
          icon: Icons.delete_sweep,
          title: 'Clear All Data',
          subtitle: 'Remove all debug data',
          color: Colors.red,
          onTap: () {
            _showClearAllDialog(context);
          },
        ),
        const SizedBox(height: 50),
        const Divider(height: 50),
        _buildVersionInfo(),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildFeatureTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  Widget _buildVersionInfo() {
    return Center(
      child: Column(
        children: [
          const Text(
            'DebugHub',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showStorageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Manager'),
        content: const Text(
          'Storage management features coming soon!\n\n'
          'You can clear all data using the "Clear All Data" option.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all debug data:\n\n'
          '• All logs\n'
          '• Network requests\n'
          '• Crash reports\n'
          '• Analytics events\n'
          '• Notifications\n'
          '• Memory snapshots\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await DebugStorage().clearAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All debug data cleared'),
                ),
              );
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Text(
          'Settings features coming soon!\n\n'
          'Future features:\n'
          '• Auto-clear old data\n'
          '• Memory monitoring interval\n'
          '• Export settings\n'
          '• Theme customization',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
