import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/base.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../debug_hub_config.dart';

class NotificationsScreen extends StatefulWidget {
  final DebugHubConfig config;

  const NotificationsScreen({
    super.key,
    required this.config,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final DebugStorage _storage = DebugStorage();
  String _searchQuery = '';
  NotificationType? _selectedType;

  List<NotificationLog> get _filteredLogs {
    var logs = _storage.getNotificationLogs().reversed.toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      logs = logs.where((log) {
        return (log.title?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
            (log.body?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
            (log.notificationId?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    // Apply type filter
    if (_selectedType != null) {
      logs = logs.where((log) => log.type == _selectedType).toList();
    }

    return logs;
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.received:
        return Colors.blue;
      case NotificationType.tapped:
        return Colors.green;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.received:
        return Icons.notifications;
      case NotificationType.tapped:
        return Icons.touch_app;
    }
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.received:
        return 'Received';
      case NotificationType.tapped:
        return 'Tapped';
    }
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Notification Logs'),
        content: const Text('Are you sure you want to clear all notification logs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _storage.clearNotificationLogs();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _shareAll() {
    final logs = _filteredLogs;
    if (logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No notification logs to share')),
      );
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('DebugHub Notification Logs');
    buffer.writeln('=' * 50);
    buffer.writeln('Total Logs: ${logs.length}');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (var log in logs) {
      buffer.writeln('[${_getTypeLabel(log.type).toUpperCase()}] ${log.timestamp}');
      if (log.notificationId != null) buffer.writeln('ID: ${log.notificationId}');
      if (log.title != null) buffer.writeln('Title: ${log.title}');
      if (log.body != null) buffer.writeln('Body: ${log.body}');
      if (log.payload != null && log.payload!.isNotEmpty) {
        buffer.writeln('Payload:');
        buffer.writeln(JsonEncoder.withIndent('  ').convert(log.payload));
      }
      if (log.wasTapped && log.tappedAt != null) {
        buffer.writeln('Tapped At: ${log.tappedAt}');
      }
      buffer.writeln('-' * 50);
    }

    Share.share(buffer.toString(), subject: 'DebugHub Notification Logs');
  }

  void _showLogDetail(NotificationLog log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notification Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: JsonEncoder.withIndent('  ').convert(log.toJson()),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Notification log copied to clipboard')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      _buildDetailRow(
                        'Type',
                        _getTypeLabel(log.type),
                        _getTypeColor(log.type),
                      ),
                      _buildDetailRow('Time', log.timestamp.toString(), null),
                      if (log.notificationId != null)
                        _buildDetailRow('Notification ID', log.notificationId!, null),
                      if (log.title != null)
                        _buildDetailRow('Title', log.title!, null),
                      if (log.body != null)
                        _buildDetailRow('Body', log.body!, null),
                      if (log.wasTapped && log.tappedAt != null)
                        _buildDetailRow('Tapped At', log.tappedAt!.toString(), Colors.green),
                      if (log.payload != null && log.payload!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Payload',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: SelectableText(
                            JsonEncoder.withIndent('  ').convert(log.payload),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logs = _filteredLogs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: widget.config.mainColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[100],
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search notifications...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Type filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[100],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedType == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedType = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...NotificationType.values.map((type) {
                    final isSelected = _selectedType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(_getTypeLabel(type)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedType = selected ? type : null;
                          });
                        },
                        selectedColor: _getTypeColor(type).withAlpha(25),
                        checkmarkColor: _getTypeColor(type),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Log count and actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${logs.length} notification${logs.length != 1 ? 's' : ''}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
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
              ],
            ),
          ),

          // Log list
          Expanded(
            child: logs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notification logs',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Notification logs will appear here',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return InkWell(
                        onTap: () => _showLogDetail(log),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                _getTypeIcon(log.type),
                                color: _getTypeColor(log.type),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getTypeColor(log.type),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            _getTypeLabel(log.type).toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${log.timestamp.hour.toString().padLeft(2, '0')}:'
                                          '${log.timestamp.minute.toString().padLeft(2, '0')}:'
                                          '${log.timestamp.second.toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    if (log.title != null) ...[
                                      Text(
                                        log.title!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                    ],
                                    if (log.body != null)
                                      Text(
                                        log.body!,
                                        style: const TextStyle(fontSize: 13),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (log.notificationId != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'ID: ${log.notificationId}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                    if (log.payload != null && log.payload!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        '${log.payload!.length} payload key${log.payload!.length != 1 ? 's' : ''}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

