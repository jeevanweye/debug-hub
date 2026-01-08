import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/base.dart';
import 'package:share_plus/share_plus.dart';
import '../debug_hub_config.dart';

class LogsScreen extends StatefulWidget {
  final DebugHubConfig config;

  const LogsScreen({
    super.key,
    required this.config,
  });

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final DebugStorage _storage = DebugStorage();
  String _searchQuery = '';
  final Set<LogLevel> _selectedLevels = LogLevel.values.toSet();

  List<DebugLog> get _filteredLogs {
    var logs = _storage.getLogs().reversed.toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      logs = logs.where((log) {
        return log.message.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (log.tag?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    // Apply level filter
    logs = logs.where((log) => _selectedLevels.contains(log.level)).toList();

    return logs;
  }

  Color _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return Colors.grey;
      case LogLevel.debug:
        return Colors.blue;
      case LogLevel.info:
        return Colors.green;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
      case LogLevel.wtf:
        return Colors.purple;
    }
  }

  IconData _getLevelIcon(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return Icons.text_snippet;
      case LogLevel.debug:
        return Icons.bug_report;
      case LogLevel.info:
        return Icons.info;
      case LogLevel.warning:
        return Icons.warning;
      case LogLevel.error:
        return Icons.error;
      case LogLevel.wtf:
        return Icons.dangerous;
    }
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Logs'),
        content: const Text('Are you sure you want to clear all logs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _storage.clearLogs();
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
        const SnackBar(content: Text('No logs to share')),
      );
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('DebugHub Logs');
    buffer.writeln('=' * 50);
    buffer.writeln('Total Logs: ${logs.length}');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (var log in logs) {
      buffer.writeln('[${log.level.name.toUpperCase()}] ${log.timestamp}');
      if (log.tag != null) buffer.writeln('Tag: ${log.tag}');
      buffer.writeln('Message: ${log.message}');
      if (log.error != null) buffer.writeln('Error: ${log.error}');
      if (log.stackTrace != null) buffer.writeln('Stack: ${log.stackTrace}');
      buffer.writeln('-' * 50);
    }

    Share.share(buffer.toString(), subject: 'DebugHub Logs');
  }

  void _showLogDetail(DebugLog log) {
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
                      'Log Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: log.toString()));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Log copied to clipboard')),
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
                      _buildDetailRow('Level', log.level.name.toUpperCase(), _getLevelColor(log.level)),
                      _buildDetailRow('Time', log.timestamp.toString(), null),
                      if (log.tag != null) _buildDetailRow('Tag', log.tag!, null),
                      const SizedBox(height: 16),
                      const Text(
                        'Message',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        log.message,
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (log.error != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Error',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          log.error.toString(),
                          style: const TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                      if (log.stackTrace != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Stack Trace',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SelectableText(
                            log.stackTrace.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                      if (log.metadata != null && log.metadata!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Metadata',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        ...log.metadata!.entries.map((e) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    '${e.key}:',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: SelectableText(e.value.toString()),
                                ),
                              ],
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
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
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

    return Column(
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.grey[100],
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search logs...',
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

        // Level filter chips
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Colors.grey[100],
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: LogLevel.values.map((level) {
                final isSelected = _selectedLevels.contains(level);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(level.name.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedLevels.add(level);
                        } else {
                          _selectedLevels.remove(level);
                        }
                      });
                    },
                    selectedColor: _getLevelColor(level).withOpacity(0.3),
                    checkmarkColor: _getLevelColor(level),
                  ),
                );
              }).toList(),
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
                '${logs.length} log${logs.length != 1 ? 's' : ''}',
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
                        Icons.article,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No logs',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Logs will appear here',
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
                              _getLevelIcon(log.level),
                              color: _getLevelColor(log.level),
                              size: 20,
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
                                          color: _getLevelColor(log.level),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          log.level.name.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (log.tag != null) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            log.tag!,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
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
                                  Text(
                                    log.message,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (log.error != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Error: ${log.error}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
    );
  }
}

