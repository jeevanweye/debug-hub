import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/base.dart';
import 'package:share_plus/share_plus.dart';
import 'package:events/events.dart';
import 'dart:convert';
import '../debug_hub_config.dart';

class EventsScreen extends StatefulWidget {
  final DebugHubConfig config;

  const EventsScreen({
    super.key,
    required this.config,
  });

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final DebugStorage _storage = DebugStorage();
  String _searchQuery = '';
  String? _selectedSource;

  List<AnalyticsEvent> get _filteredEvents {
    var events = _storage.getEvents().reversed.toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      events = events.where((event) {
        return event.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (event.source?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    // Apply source filter
    if (_selectedSource != null) {
      events = events.where((event) => event.source == _selectedSource).toList();
    }

    return events;
  }

  Set<String> get _availableSources {
    return _storage.getEvents()
        .where((e) => e.source != null)
        .map((e) => e.source!)
        .toSet();
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Events'),
        content: const Text('Are you sure you want to clear all analytics events?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _storage.clearEvents();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _openEventValidation() {
    final packageName = widget.config.packageName ?? 'com.example.app';
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventValidationDashboardScreen(
          packageName: packageName,
          config: EventValidationConfig(
            mainColor: widget.config.mainColor,
          ),
        ),
      ),
    );
  }

  void _shareAll() {
    final events = _filteredEvents;
    if (events.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No events to share')),
      );
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('DebugHub Analytics Events');
    buffer.writeln('=' * 50);
    buffer.writeln('Total Events: ${events.length}');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (var event in events) {
      buffer.writeln('Event: ${event.name}');
      if (event.source != null) buffer.writeln('Source: ${event.source}');
      buffer.writeln('Time: ${event.timestamp}');
      if (event.userId != null) buffer.writeln('User ID: ${event.userId}');
      if (event.sessionId != null) buffer.writeln('Session ID: ${event.sessionId}');
      if (event.properties != null && event.properties!.isNotEmpty) {
        buffer.writeln('Properties:');
        buffer.writeln(JsonEncoder.withIndent('  ').convert(event.properties));
      }
      buffer.writeln('-' * 50);
    }

    Share.share(buffer.toString(), subject: 'DebugHub Analytics Events');
  }

  void _showEventDetail(AnalyticsEvent event) {
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
                      'Event Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: JsonEncoder.withIndent('  ').convert(event.toJson())),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Event copied to clipboard')),
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
                      _buildDetailRow('Event Name', event.name),
                      if (event.source != null)
                        _buildDetailRow('Source', event.source!),
                      _buildDetailRow('Time', event.timestamp.toString()),
                      if (event.userId != null)
                        _buildDetailRow('User ID', event.userId!),
                      if (event.sessionId != null)
                        _buildDetailRow('Session ID', event.sessionId!),
                      if (event.properties != null && event.properties!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Properties',
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
                            JsonEncoder.withIndent('  ').convert(event.properties),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SelectableText(value),
          ),
        ],
      ),
    );
  }

  Color _getSourceColor(String? source) {
    if (source == null) return Colors.grey;
    switch (source.toLowerCase()) {
      case 'clevertap':
        return Colors.blue;
      case 'firebase':
        return Colors.orange;
      case 'custom':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = _filteredEvents;
    final sources = _availableSources;

    return Column(
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.grey[100],
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search events...',
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

        // Source filter chips
        if (sources.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[100],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedSource == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSource = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...sources.map((source) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(source),
                      selected: _selectedSource == source,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSource = selected ? source : null;
                        });
                      },
                      selectedColor: _getSourceColor(source).withOpacity(0.3),
                      checkmarkColor: _getSourceColor(source),
                    ),
                  )),
                ],
              ),
            ),
          ),

        // Event count and actions
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${events.length} event${events.length != 1 ? 's' : ''}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.table_chart),
                    onPressed: _openEventValidation,
                    tooltip: 'Validate with Google Sheets',
                    color: Colors.green[700],
                  ),
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

        // Event list
        Expanded(
          child: events.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No events',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Analytics events will appear here',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return InkWell(
                      onTap: () => _showEventDetail(event),
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
                              Icons.analytics,
                              color: _getSourceColor(event.source),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (event.source != null) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getSourceColor(event.source),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            event.source!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      Expanded(
                                        child: Text(
                                          event.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '${event.timestamp.hour.toString().padLeft(2, '0')}:'
                                        '${event.timestamp.minute.toString().padLeft(2, '0')}:'
                                        '${event.timestamp.second.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (event.properties != null && event.properties!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Screen Name: ${event.screenName} :: ${event.properties!.length} propert${event.properties!.length != 1 ? 'ies' : 'y'}',
                                      style: TextStyle(
                                        fontSize: 12,
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
    );
  }
}

