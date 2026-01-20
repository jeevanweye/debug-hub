import 'dart:io';
import 'package:debug_hub_ui/debug_hub_ui.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/network_info_card.dart';

class DeviceDetailsScreen extends StatefulWidget {

  const DeviceDetailsScreen({
    super.key,
  });

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  Map<String, dynamic> dataItems = {};
  @override
  void initState() {
    dataItems = DebugHub().config.userProperties ?? {};
    super.initState();
    _loadData();
  }

  void _loadData() async {
    dataItems.addAll(_getDeviceData());
    final appInfo = await _getAppData();
    dataItems.addAll(appInfo);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                final shareableString =
                dataItems.entries.map((e) => '${e.key}: ${e.value}').join('\n');
                Share.share(shareableString);
              },
            ),
          ],
        ),
        body: dataItems.entries.isEmpty ?
            Center(
              child: Text('No data available'),
            )
            : ListView(
                padding: const EdgeInsets.all(16),
          children: [
            NetworkInfoCard(
              title: 'User data',
              items: dataItems.entries
                  .map((entry) => NetworkInfoItem(entry.key, entry.value.toString()))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getDeviceData() {
    Map<String, dynamic> deviceData = {};
    deviceData = {
      'Platform': Platform.operatingSystem,
    };
    return deviceData;
  }

  Future<Map<String, dynamic>> _getAppData() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      Map<String, dynamic> appData = {};
      appData = {
        'App version': '${packageInfo.version}',
        'Package Name': '${packageInfo.packageName}',
      };
      return appData;
    } catch (e) {
      return {};
    }
  }
}
