import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/base.dart';
import 'package:share_plus/share_plus.dart';
import '../debug_hub_config.dart';

enum CrashFilterType {
  all,
  fatal,
  nonFatal,
}

class CrashesScreen extends StatefulWidget {
  final DebugHubConfig config;

  const CrashesScreen({
    super.key,
    required this.config,
  });

  @override
  State<CrashesScreen> createState() => _CrashesScreenState();
}

class _CrashesScreenState extends State<CrashesScreen> {
  final DebugStorage _storage = DebugStorage();
  CrashFilterType _selectedFilter = CrashFilterType.all;

  List<CrashReport> get _filteredCrashes {
    final allCrashes = _storage.getCrashReports().reversed.toList();
    
    switch (_selectedFilter) {
      case CrashFilterType.all:
        return allCrashes;
      case CrashFilterType.fatal:
        return allCrashes.where((crash) => crash.isFatal).toList();
      case CrashFilterType.nonFatal:
        return allCrashes.where((crash) => !crash.isFatal).toList();
    }
  }

  void _clearAll() {
    final filterLabel = _getFilterLabel(_selectedFilter);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear $filterLabel'),
        content: Text('Are you sure you want to clear all $filterLabel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _storage.clearCrashReports();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  String _getFilterLabel(CrashFilterType filter) {
    switch (filter) {
      case CrashFilterType.all:
        return 'Crashes';
      case CrashFilterType.fatal:
        return 'Fatal Crashes';
      case CrashFilterType.nonFatal:
        return 'Non-Fatal Crashes';
    }
  }

  void _shareAll() {
    final crashes = _filteredCrashes;
    final errorType = _getFilterLabel(_selectedFilter);
    
    if (crashes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No $errorType to share')),
      );
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('DebugHub $errorType');
    buffer.writeln('=' * 50);
    buffer.writeln('Total: ${crashes.length}');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (var crash in crashes) {
      buffer.writeln('Time: ${crash.timestamp}');
      buffer.writeln('Type: ${crash.isFatal ? 'Fatal' : 'Non-Fatal'}');
      if (crash.context != null) buffer.writeln('Context: ${crash.context}');
      buffer.writeln('Error: ${crash.error}');
      buffer.writeln('Stack Trace:\n${crash.stackTrace}');
      buffer.writeln('-' * 50);
    }

    Share.share(buffer.toString(), subject: 'DebugHub $errorType');
  }

  void _showCrashDetail(CrashReport crash) {
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
                      'Crash Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: 'Error: ${crash.error}\n\nStack Trace:\n${crash.stackTrace}',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Crash details copied to clipboard')),
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
                      _buildDetailRow('Time', crash.timestamp.toString()),
                      _buildDetailRow('Type', crash.isFatal ? 'Fatal' : 'Non-Fatal'),
                      if (crash.context != null)
                        _buildDetailRow('Context', crash.context!),
                      const SizedBox(height: 16),
                      const Text(
                        'Error',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        crash.error.toString(),
                        style: const TextStyle(fontSize: 14, color: Colors.red),
                      ),
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
                          crash.stackTrace.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
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

  Widget _buildDetailRow(String label, String value) {
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
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crashes = _filteredCrashes;
    final errorType = _getFilterLabel(_selectedFilter);

    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crashes'),
          backgroundColor: widget.config.mainColor,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // Filter chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.grey[100],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedFilter == CrashFilterType.all,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = CrashFilterType.all;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Fatal'),
                      selected: _selectedFilter == CrashFilterType.fatal,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = CrashFilterType.fatal;
                        });
                      },
                      selectedColor: Colors.red.withAlpha(25),
                      checkmarkColor: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Non-Fatal'),
                      selected: _selectedFilter == CrashFilterType.nonFatal,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = CrashFilterType.nonFatal;
                        });
                      },
                      selectedColor: Colors.orange.withAlpha(25),
                      checkmarkColor: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            // Crash count and actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${crashes.length} ${errorType.toLowerCase()}${crashes.length != 1 ? 's' : ''}',
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

            // Crash list
            Expanded(
              child:               crashes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: Colors.green[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No ${errorType.toLowerCase()}s',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedFilter == CrashFilterType.fatal
                                ? 'No fatal crashes recorded!'
                                : _selectedFilter == CrashFilterType.nonFatal
                                    ? 'No non-fatal errors recorded!'
                                    : 'Your app is running smoothly!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: crashes.length,
                      itemBuilder: (context, index) {
                        final crash = crashes[index];
                        return InkWell(
                          onTap: () => _showCrashDetail(crash),
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
                                  crash.isFatal ? Icons.error : Icons.warning_amber,
                                  color: crash.isFatal ? Colors.red : Colors.orange,
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
                                                color: crash.isFatal ? Colors.red : Colors.orange,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                crash.isFatal ? 'FATAL' : 'NON-FATAL',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          const Spacer(),
                                          Text(
                                            '${crash.timestamp.hour.toString().padLeft(2, '0')}:'
                                            '${crash.timestamp.minute.toString().padLeft(2, '0')}:'
                                            '${crash.timestamp.second.toString().padLeft(2, '0')}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        crash.error.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        crash.stackTrace.toString().split('\n').first,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontFamily: 'monospace',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
      ),
    );
  }
}

