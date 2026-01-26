import 'package:flutter/material.dart';
import 'package:base/base.dart';
import 'package:share_plus/share_plus.dart';
import '../debug_hub_config.dart';
import '../widgets/network_request_tile.dart';
import 'network_detail_screen.dart';

class NetworkScreen extends StatefulWidget {
  final DebugHubConfig config;

  const NetworkScreen({
    super.key,
    required this.config,
  });

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  final DebugStorage _storage = DebugStorage();
  String _searchQuery = '';
  String _filterType = 'all'; // all, success, error, pending

  List<NetworkRequest> get _filteredRequests {
    var requests = _storage.getNetworkRequests().reversed.toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      requests = requests.where((req) {
        return req.url.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            req.method.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply status filter
    if (_filterType != 'all') {
      requests = requests.where((req) {
        switch (_filterType) {
          case 'success':
            return req.isSuccess;
          case 'error':
            return req.isError;
          case 'pending':
            return req.isPending;
          default:
            return true;
        }
      }).toList();
    }

    return requests;
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Network Logs'),
        content: const Text('Are you sure you want to clear all network requests?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _storage.clearNetworkRequests();
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
    final requests = _filteredRequests;
    if (requests.isEmpty) {
      UpperToast.show(context, 'No requests to share');
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('DebugHub Network Requests');
    buffer.writeln('=' * 50);
    buffer.writeln('Total Requests: ${requests.length}');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('=' * 50);
    buffer.writeln();

    for (var request in requests) {
      buffer.writeln('${request.method.name.toUpperCase()} ${request.url}');
      buffer.writeln('Status: ${request.statusCode ?? 'Pending'}');
      buffer.writeln('Time: ${request.timestamp}');
      if (request.duration != null) {
        buffer.writeln('Duration: ${request.duration!.inMilliseconds}ms');
      }
      buffer.writeln('-' * 50);
    }

    Share.share(buffer.toString(), subject: 'DebugHub Network Requests');
  }

  @override
  Widget build(BuildContext context) {
    final requests = _filteredRequests;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Search and filter bar
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[100],
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search URL or method...',
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'all', label: Text('All')),
                          ButtonSegment(value: 'success', label: Text('Success')),
                          ButtonSegment(value: 'error', label: Text('Error')),
                          ButtonSegment(value: 'pending', label: Text('Pending')),
                        ],
                        selected: {_filterType},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _filterType = newSelection.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Request count and actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${requests.length} request${requests.length != 1 ? 's' : ''}',
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

          // Request list
          Expanded(
            child: requests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.network_check,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No network requests',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Network requests will appear here',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return NetworkRequestTile(
                        request: request,
                        config: widget.config,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NetworkDetailScreen(
                                request: request,
                                config: widget.config,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

