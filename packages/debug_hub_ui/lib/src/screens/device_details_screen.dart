import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/network_info_card.dart';

class DeviceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> dataItems;

  const DeviceDetailsScreen({
    super.key,
    required this.dataItems,
  });

  @override
  Widget build(BuildContext context) {
    final shareableString =
        dataItems.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(shareableString);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NetworkInfoCard(
            title: 'Device Data',
            items: dataItems.entries
                .map((entry) => NetworkInfoItem(entry.key, entry.value.toString()))
                .toList(),
          ),
        ],
      ),
    );
  }
}
