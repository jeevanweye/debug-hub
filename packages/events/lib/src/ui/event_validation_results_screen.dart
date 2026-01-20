import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../models/event_report_info.dart';
import '../utils/event_comparator.dart';

/// Screen to display event validation results
class EventValidationResultsScreen extends StatefulWidget {
  final List<EventReportInfo> results;
  final String versionName;
  final dynamic config;

  const EventValidationResultsScreen({
    super.key,
    required this.results,
    required this.versionName,
    this.config,
  });

  @override
  State<EventValidationResultsScreen> createState() =>
      _EventValidationResultsScreenState();
}

class _EventValidationResultsScreenState
    extends State<EventValidationResultsScreen> {
  String _filter = 'all'; // all, correct, incorrect, notFound

  List<EventReportInfo> get _filteredResults {
    switch (_filter) {
      case 'correct':
        return widget.results.where((r) => r.isCorrect).toList();
      case 'incorrect':
        return widget.results
            .where((r) => r.isFound && !r.isCorrect)
            .toList();
      case 'notFound':
        return widget.results.where((r) => !r.isFound).toList();
      default:
        return widget.results;
    }
  }

  EventComparisonStats get _stats {
    return EventComparator.getStats(widget.results);
  }

  void _shareResults() {
    final stats = _stats;
    final buffer = StringBuffer();
    
    buffer.writeln('Event Validation Report');
    buffer.writeln('=' * 50);
    buffer.writeln('Version: ${widget.versionName}');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('=' * 50);
    buffer.writeln();
    
    buffer.writeln('Summary:');
    buffer.writeln('Total Events: ${stats.total}');
    buffer.writeln('Found: ${stats.found} (${stats.foundPercentage.toStringAsFixed(1)}%)');
    buffer.writeln('Correct: ${stats.correct} (${stats.correctPercentage.toStringAsFixed(1)}%)');
    buffer.writeln('Not Found: ${stats.notFound} (${stats.notFoundPercentage.toStringAsFixed(1)}%)');
    buffer.writeln('Found but Incorrect: ${stats.foundButIncorrect} (${stats.foundButIncorrectPercentage.toStringAsFixed(1)}%)');
    buffer.writeln();
    buffer.writeln('=' * 50);
    buffer.writeln();
    
    // Group by status
    final correct = widget.results.where((r) => r.isCorrect).toList();
    final incorrect = widget.results.where((r) => r.isFound && !r.isCorrect).toList();
    final notFound = widget.results.where((r) => !r.isFound).toList();
    
    if (correct.isNotEmpty) {
      buffer.writeln('✓ CORRECT EVENTS (${correct.length}):');
      buffer.writeln('-' * 50);
      for (var event in correct) {
        buffer.writeln('  • ${event.sheetEvent?.eventName ?? 'Unknown'}');
      }
      buffer.writeln();
    }
    
    if (incorrect.isNotEmpty) {
      buffer.writeln('⚠ INCORRECT EVENTS (${incorrect.length}):');
      buffer.writeln('-' * 50);
      for (var event in incorrect) {
        buffer.writeln('  • ${event.sheetEvent?.eventName ?? 'Unknown'}');
        buffer.writeln('    Expected: ${_formatEventDetails(event.sheetEvent)}');
        buffer.writeln('    Found: ${_formatEventDetails(event.devEvent)}');
      }
      buffer.writeln();
    }
    
    if (notFound.isNotEmpty) {
      buffer.writeln('✗ NOT FOUND EVENTS (${notFound.length}):');
      buffer.writeln('-' * 50);
      for (var event in notFound) {
        buffer.writeln('  • ${event.sheetEvent?.eventName ?? 'Unknown'}');
        buffer.writeln('    Expected: ${_formatEventDetails(event.sheetEvent)}');
      }
      buffer.writeln();
    }
    
    Share.share(buffer.toString(), subject: 'Event Validation Report - ${widget.versionName}');
  }

  String _formatEventDetails(dynamic event) {
    if (event == null) return 'N/A';
    final buffer = StringBuffer();
    buffer.write('Action: ${event.eventAction ?? 'N/A'}, ');
    buffer.write('Category: ${event.eventCategory ?? 'N/A'}, ');
    buffer.write('Screen: ${event.screenName ?? 'N/A'}');
    return buffer.toString();
  }

  void _showEventDetail(EventReportInfo event) {
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
                            final data = {
                              'sheetEvent': event.sheetEvent?.toJson(),
                              'devEvent': event.devEvent?.toJson(),
                              'isFound': event.isFound,
                              'isCorrect': event.isCorrect,
                            };
                            Clipboard.setData(
                              ClipboardData(
                                text: JsonEncoder.withIndent('  ').convert(data),
                              ),
                            );
                            UpperToast.show(context, 'Event copied to clipboard');
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
                      _buildStatusChip(event),
                      const SizedBox(height: 16),
                      const Text(
                        'Expected (Sheet)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildEventInfoCard(event.sheetEvent),
                      const SizedBox(height: 16),
                      const Text(
                        'Found (Device)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      event.devEvent != null
                          ? _buildEventInfoCard(event.devEvent!)
                          : const Card(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Event not found in device logs',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
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

  Widget _buildStatusChip(EventReportInfo event) {
    Color color;
    IconData icon;
    String label;

    if (event.isCorrect) {
      color = Colors.green;
      icon = Icons.check_circle;
      label = 'CORRECT';
    } else if (event.isFound) {
      color = Colors.orange;
      icon = Icons.warning;
      label = 'FOUND BUT INCORRECT';
    } else {
      color = Colors.red;
      icon = Icons.cancel;
      label = 'NOT FOUND';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventInfoCard(dynamic event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Event Name', event.eventName),
            _buildDetailRow('Event Action', event.eventAction),
            _buildDetailRow('Event Category', event.eventCategory),
            _buildDetailRow('Screen Name', event.screenName),
            if (event.vehicleId != null)
              _buildDetailRow('Vehicle ID', event.vehicleId),
            if (event.entity != null) _buildDetailRow('Entity', event.entity),
            if (event.miscellaneous != null)
              _buildDetailRow('Miscellaneous', event.miscellaneous),
            if (event.targetProduct != null)
              _buildDetailRow('Target Product', event.targetProduct),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 13,
                color: value != null ? Colors.black87 : Colors.grey,
                fontStyle: value != null ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(EventReportInfo event) {
    if (event.isCorrect) return Colors.green;
    if (event.isFound) return Colors.orange;
    return Colors.red;
  }

  IconData _getStatusIcon(EventReportInfo event) {
    if (event.isCorrect) return Icons.check_circle;
    if (event.isFound) return Icons.warning;
    return Icons.cancel;
  }

  @override
  Widget build(BuildContext context) {
    final stats = _stats;
    final filteredResults = _filteredResults;
    final mainColor = (widget.config as dynamic)?.mainColor ?? Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text('Results - ${widget.versionName}'),
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareResults,
            tooltip: 'Share Results',
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Card
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Total',
                        stats.total.toString(),
                        Colors.blue,
                      ),
                      _buildStatItem(
                        'Correct',
                        '${stats.correct}\n${stats.correctPercentage.toStringAsFixed(1)}%',
                        Colors.green,
                      ),
                      _buildStatItem(
                        'Not Found',
                        '${stats.notFound}\n${stats.notFoundPercentage.toStringAsFixed(1)}%',
                        Colors.red,
                      ),
                      _buildStatItem(
                        'Incorrect',
                        '${stats.foundButIncorrect}\n${stats.foundButIncorrectPercentage.toStringAsFixed(1)}%',
                        Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[100],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all', stats.total),
                  const SizedBox(width: 8),
                  _buildFilterChip('Correct', 'correct', stats.correct),
                  const SizedBox(width: 8),
                  _buildFilterChip('Incorrect', 'incorrect', stats.foundButIncorrect),
                  const SizedBox(width: 8),
                  _buildFilterChip('Not Found', 'notFound', stats.notFound),
                ],
              ),
            ),
          ),

          // Results List
          Expanded(
            child: filteredResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_list_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events in this filter',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      final event = filteredResults[index];
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
                            children: [
                              Icon(
                                _getStatusIcon(event),
                                color: _getStatusColor(event),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.sheetEvent?.eventName ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatEventDetails(event.sheetEvent),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
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

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value, int count) {
    final isSelected = _filter == value;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filter = value;
        });
      },
    );
  }
}

