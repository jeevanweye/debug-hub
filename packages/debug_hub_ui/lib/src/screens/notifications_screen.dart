import 'dart:convert';

import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../debug_hub_config.dart';

class NotificationsScreen extends StatefulWidget {
  final DebugHubConfig config;

  const NotificationsScreen({super.key, required this.config});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final DebugStorage _storage = DebugStorage();

  String _searchQuery = '';
  NotificationSource? _selectedSource;
  NotificationMode? _selectedMode;

  List<NotificationLog> get _filteredLogs {
    var logs = _storage.getNotificationLogs().reversed.toList();

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      logs = logs.where((log) {
        return (log.title?.toLowerCase().contains(query) ?? false) ||
            (log.body?.toLowerCase().contains(query) ?? false) ||
            (log.notificationId?.toLowerCase().contains(query) ?? false) ||
            log.source.name.toLowerCase().contains(query) ||
            log.mode.name.toLowerCase().contains(query);
      }).toList();
    }

    // Source filter
    if (_selectedSource != null) {
      logs = logs.where((log) => log.source == _selectedSource).toList();
    }

    // Mode filter
    if (_selectedMode != null) {
      logs = logs.where((log) => log.mode == _selectedMode).toList();
    }

    return logs;
  }

  Color _getSourceColor(NotificationMode mode) {
    switch (mode) {
      case NotificationMode.foreground:
        return Colors.blue;
      case NotificationMode.background:
        return Colors.green;
    }
  }



  IconData _getModeIcon(NotificationMode mode) {
    switch (mode) {
      case NotificationMode.foreground:
        return Icons.mobile_friendly;
      case NotificationMode.background:
        return Icons.notifications_active_outlined;
    }
  }

  String _getModeLabel(NotificationMode mode) {
    switch (mode) {
      case NotificationMode.foreground:
        return 'Foreground';
      case NotificationMode.background:
        return 'Background';
    }
  }

  String _getSourceLabel(NotificationSource source) {
    switch (source) {
      case NotificationSource.firebase:
        return 'Firebase';
      case NotificationSource.clevertap:
        return 'CleverTap';
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
      UpperToast.show(context, 'No notification logs to share');
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('DebugHub Notification Logs');
    buffer.writeln('=' * 50);
    buffer.writeln('Total Logs: ${logs.length}');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (final log in logs) {
      buffer.writeln(
        '[${_getModeLabel(log.mode).toUpperCase()}] ${log.timestamp.toIso8601String()}',
      );
      buffer.writeln('Source: ${log.source.name}');
      if (log.notificationId != null) buffer.writeln('Notification ID: ${log.notificationId}');
      if (log.title != null) buffer.writeln('Title: ${log.title}');
      if (log.body != null) buffer.writeln('Body: ${log.body}');
      if (log.payload != null && log.payload!.isNotEmpty) {
        buffer.writeln('Payload:');
        buffer.writeln(JsonEncoder.withIndent('  ').convert(_normalizePayload(log.payload!)));
      }
      buffer.writeln('-' * 50);
    }

    Share.share(buffer.toString(), subject: 'DebugHub Notification Logs');
  }

  dynamic _tryDecode(dynamic value) {
    if (value is String) {
      try {
        return jsonDecode(value);
      } catch (_) {
        return value;
      }
    }
    return value;
  }

  Map<String, dynamic> _normalizePayload(Map<String, dynamic> payload) {
    final result = <String, dynamic>{};
    payload.forEach((key, value) {
      result[key] = _tryDecode(value);
    });
    return result;
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
                            UpperToast.show(context, 'Notification log copied to clipboard');
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
                        'Mode',
                        _getModeLabel(log.mode),
                        null,
                      ),
                      _buildDetailRow(
                        'Source',
                        _getSourceLabel(log.source),
                        _getSourceColor(log.mode),
                      ),
                      _buildDetailRow('Time', log.timestamp.toString(), null),
                      _buildDetailRow('Log ID', log.id, null),
                      if (log.notificationId != null)
                        _buildDetailRow('Notification ID', log.notificationId!, null),
                      if (log.title != null) _buildDetailRow('Title', log.title!, null),
                      if (log.body != null) _buildDetailRow('Body', log.body!, null),
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
                            const JsonEncoder.withIndent('  ')
                                .convert(_normalizePayload(log.payload!)),
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
            child: SelectableText(value, style: TextStyle(color: valueColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logs = _filteredLogs;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[100],
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search notifications...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Filters (Source + Mode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.grey[100],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // MODE FILTERS
                  FilterChip(
                    label: const Text('All Modes'),
                    selected: _selectedMode == null,
                    onSelected: (_) => setState(() => _selectedMode = null),
                  ),
                  const SizedBox(width: 8),
                  ...NotificationMode.values.map((mode) {
                    final isSelected = _selectedMode == mode;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(_getModeLabel(mode)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedMode = selected ? mode : null);
                        },
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
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No notification logs',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Notification logs will appear here',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
                          _getModeIcon(log.mode),
                          color: _getSourceColor(log.mode),
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
                                      color: _getSourceColor(log.mode),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${_getSourceLabel(log.source)} • ${_getModeLabel(log.mode)}'
                                          .toUpperCase(),
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
                              const SizedBox(height: 4),
                              Text(
                                'source: ${log.source.name} | mode: ${log.mode.name}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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
