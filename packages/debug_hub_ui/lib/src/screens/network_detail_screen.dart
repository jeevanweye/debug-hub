import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/base.dart';
import 'package:share_plus/share_plus.dart';
import '../debug_hub_config.dart';
import '../widgets/data_view_toggle.dart';
import '../widgets/json_tree_view.dart';
import '../widgets/json_text_view.dart';
import '../widgets/network_info_card.dart';

class NetworkDetailScreen extends StatefulWidget {
  final NetworkRequest request;
  final DebugHubConfig config;

  const NetworkDetailScreen({
    super.key,
    required this.request,
    required this.config,
  });

  @override
  State<NetworkDetailScreen> createState() => _NetworkDetailScreenState();
}

class _NetworkDetailScreenState extends State<NetworkDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DataViewMode _requestViewMode = DataViewMode.tree;
  DataViewMode _responseViewMode = DataViewMode.tree;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard')),
    );
  }

  void _shareRequest() {
    final buffer = StringBuffer();
    buffer.writeln('DebugHub Network Request Details');
    buffer.writeln('=' * 50);
    buffer.writeln('URL: ${widget.request.url}');
    buffer.writeln('Method: ${widget.request.method.name.toUpperCase()}');
    buffer.writeln('Status: ${widget.request.statusCode ?? 'Pending'}');
    buffer.writeln('Time: ${widget.request.timestamp}');
    if (widget.request.duration != null) {
      buffer.writeln('Duration: ${widget.request.duration!.inMilliseconds}ms');
    }
    buffer.writeln();

    if (widget.request.headers != null) {
      buffer.writeln('Request Headers:');
      widget.request.headers!.forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
      buffer.writeln();
    }

    if (widget.request.requestBody != null) {
      buffer.writeln('Request Body:');
      buffer.writeln(widget.request.getFormattedRequestBody());
      buffer.writeln();
    }

    if (widget.request.responseHeaders != null) {
      buffer.writeln('Response Headers:');
      widget.request.responseHeaders!.forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
      buffer.writeln();
    }

    if (widget.request.responseBody != null) {
      buffer.writeln('Response Body:');
      buffer.writeln(widget.request.getFormattedResponseBody());
    }

    Share.share(buffer.toString(), subject: 'Network Request Details');
  }

  void _shareAsCurl() {
    final curlCommand = widget.request.toCurl();
    Share.share(curlCommand, subject: 'cURL Command');
  }

  void _copyAsCurl() {
    final curlCommand = widget.request.toCurl();
    Clipboard.setData(ClipboardData(text: curlCommand));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('cURL command copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('API Details'),
          backgroundColor: widget.config.mainColor,
          foregroundColor: Colors.white,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.share),
              onSelected: (value) {
                switch (value) {
                  case 'share':
                    _shareRequest();
                    break;
                  case 'share_curl':
                    _shareAsCurl();
                    break;
                  case 'copy_curl':
                    _copyAsCurl();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 8),
                      Text('Share Details'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share_curl',
                  child: Row(
                    children: [
                      Icon(Icons.terminal),
                      SizedBox(width: 8),
                      Text('Share as cURL'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'copy_curl',
                  child: Row(
                    children: [
                      Icon(Icons.copy),
                      SizedBox(width: 8),
                      Text('Copy as cURL'),
                    ],
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontSize: 14),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Request'),
              Tab(text: 'Response'),
              Tab(text: 'Headers'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildRequestTab(),
            _buildResponseTab(),
            _buildHeadersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        NetworkInfoCard(
          title: 'General',
          items: [
            NetworkInfoItem('URL', widget.request.url),
            NetworkInfoItem('Method', widget.request.method.name.toUpperCase()),
            NetworkInfoItem(
                'Status', widget.request.statusCode?.toString() ?? 'Pending'),
            NetworkInfoItem('Time', DateFormatter.formatDate(widget.request.timestamp) + DateFormatter.formatTime12Hour(widget.request.timestamp)),
            if (widget.request.duration != null)
              NetworkInfoItem(
                  'Duration', '${widget.request.duration!.inMilliseconds}ms'),
          ],
        ),
        const SizedBox(height: 16),
        NetworkInfoCard(
          title: 'Size',
          items: [
            NetworkInfoItem('Request Size', _formatSize(widget.request.requestSize)),
            NetworkInfoItem(
                'Response Size', _formatSize(widget.request.responseSize)),
          ],
        ),
        if (widget.request.error != null) ...[
          const SizedBox(height: 16),
          NetworkInfoCard(
            title: 'Error',
            items: [
              NetworkInfoItem('Error', widget.request.error!, isError: true),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildRequestTab() {
    return Column(
      children: [
        DataViewToggle(
          selectedMode: _requestViewMode,
          onModeChanged: (mode) {
            setState(() {
              _requestViewMode = mode;
            });
          },
          label: 'Body',
          onCopy: widget.request.requestBody != null
              ? () => _copyToClipboard(
                    widget.request.getFormattedRequestBody(),
                    'Request body',
                  )
              : null,
          showCopyButton: widget.request.requestBody != null,
        ),
        Expanded(
          child: widget.request.requestBody != null
              ? _requestViewMode == DataViewMode.tree
                  ? JsonTreeView(
                      data: widget.request.requestBody,
                      isRequest: true,
                    )
                  : JsonTextView(
                      text: widget.request.getFormattedRequestBody(),
                    )
              : const Center(child: Text('No request body')),
        ),
      ],
    );
  }

  Widget _buildResponseTab() {
    return Column(
      children: [
        DataViewToggle(
          selectedMode: _responseViewMode,
          onModeChanged: (mode) {
            setState(() {
              _responseViewMode = mode;
            });
          },
          label:  'Body',
          onCopy: widget.request.responseBody != null
              ? () => _copyToClipboard(
                    widget.request.getFormattedResponseBody(),
                    'Response body',
                  )
              : null,
          showCopyButton: widget.request.responseBody != null,
        ),
        Expanded(
          child: widget.request.responseBody != null
              ? _responseViewMode == DataViewMode.tree
                  ? JsonTreeView(
                      data: widget.request.responseBody,
                      isRequest: false,
                    )
                  : JsonTextView(
                      text: widget.request.getFormattedResponseBody(),
                    )
              : const Center(child: Text('No response body')),
        ),
      ],
    );
  }

  Widget _buildHeadersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (widget.request.headers != null &&
            widget.request.headers!.isNotEmpty) ...[
          NetworkInfoCard(
            title: 'Request Headers',
            items: widget.request.headers!.entries
                .map((e) => NetworkInfoItem(e.key, e.value.toString()))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (widget.request.responseHeaders != null &&
            widget.request.responseHeaders!.isNotEmpty)
          NetworkInfoCard(
            title: 'Response Headers',
            items: widget.request.responseHeaders!.entries
                .map((e) => NetworkInfoItem(e.key, e.value.toString()))
                .toList(),
          ),
        if (widget.request.headers == null &&
            widget.request.responseHeaders == null)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No headers available'),
            ),
          ),
      ],
    );
  }

  String _formatSize(int? size) {
    if (size == null || size == 0) return '0 B';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(2)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
