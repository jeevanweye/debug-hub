import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/base.dart';
import 'package:share_plus/share_plus.dart';
import '../debug_hub_config.dart';

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

class _NetworkDetailScreenState extends State<NetworkDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
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
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          title: 'General',
          items: [
            _InfoItem('URL', widget.request.url),
            _InfoItem('Method', widget.request.method.name.toUpperCase()),
            _InfoItem('Status', widget.request.statusCode?.toString() ?? 'Pending'),
            _InfoItem('Time', widget.request.timestamp.toString()),
            if (widget.request.duration != null)
              _InfoItem('Duration', '${widget.request.duration!.inMilliseconds}ms'),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'Size',
          items: [
            _InfoItem('Request Size', _formatSize(widget.request.requestSize)),
            _InfoItem('Response Size', _formatSize(widget.request.responseSize)),
          ],
        ),
        if (widget.request.error != null) ...[
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Error',
            items: [
              _InfoItem('Error', widget.request.error!, isError: true),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildRequestTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Request Body',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (widget.request.requestBody != null)
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _copyToClipboard(
                  widget.request.getFormattedRequestBody(),
                  'Request body',
                ),
              ),
          ],
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
            widget.request.requestBody != null
                ? widget.request.getFormattedRequestBody()
                : 'No request body',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResponseTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Response Body',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (widget.request.responseBody != null)
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _copyToClipboard(
                  widget.request.getFormattedResponseBody(),
                  'Response body',
                ),
              ),
          ],
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
            widget.request.responseBody != null
                ? widget.request.getFormattedResponseBody()
                : 'No response body',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeadersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (widget.request.headers != null && widget.request.headers!.isNotEmpty) ...[
          _buildInfoCard(
            title: 'Request Headers',
            items: widget.request.headers!.entries
                .map((e) => _InfoItem(e.key, e.value.toString()))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (widget.request.responseHeaders != null && widget.request.responseHeaders!.isNotEmpty)
          _buildInfoCard(
            title: 'Response Headers',
            items: widget.request.responseHeaders!.entries
                .map((e) => _InfoItem(e.key, e.value.toString()))
                .toList(),
          ),
        if (widget.request.headers == null && widget.request.responseHeaders == null)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No headers available'),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<_InfoItem> items,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty) ...[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No items',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700] ?? Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SelectableText(
                        item.value,
                        style: TextStyle(
                          color: item.isError ? Colors.red : Colors.black87,
                          fontFamily: item.value.length > 50 ? 'monospace' : null,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  String _formatSize(int? size) {
    if (size == null || size == 0) return '0 B';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(2)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

class _InfoItem {
  final String label;
  final String value;
  final bool isError;

  _InfoItem(this.label, this.value, {this.isError = false});
}

