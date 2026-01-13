import 'package:flutter/material.dart';
import 'package:base/base.dart';
import '../debug_hub_config.dart';

class NetworkRequestTile extends StatelessWidget {
  final NetworkRequest request;
  final DebugHubConfig config;
  final VoidCallback onTap;

  const NetworkRequestTile({
    super.key,
    required this.request,
    required this.config,
    required this.onTap,
  });

  Color _getStatusColor() {
    if (request.isSuccess) return Colors.green;
    if (request.isError) return Colors.red;
    return Colors.orange;
  }

  IconData _getMethodIcon() {
    switch (request.method) {
      case RequestMethod.get:
        return Icons.download;
      case RequestMethod.post:
        return Icons.upload;
      case RequestMethod.put:
        return Icons.edit;
      case RequestMethod.patch:
        return Icons.edit_note;
      case RequestMethod.delete:
        return Icons.delete;
      default:
        return Icons.http;
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '-';
    if (duration.inMilliseconds < 1000) {
      return '${duration.inMilliseconds}ms';
    }
    return '${(duration.inMilliseconds / 1000).toStringAsFixed(2)}s';
  }

  String _formatSize(int? size) {
    if (size == null || size == 0) return '-';
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String _getDisplayUrl() {
    String url = request.url;
    if (config.serverURL != null && url.contains(config.serverURL!)) {
      return url.replaceAll(config.serverURL!, '');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Method badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getMethodIcon(),
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        request.method.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                
                // Status code
                if (request.statusCode != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${request.statusCode}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                
                const Spacer(),
                
                // Duration
                Text(
                  _formatDuration(request.duration),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // URL
            Text(
              _getDisplayUrl(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            
            // Metadata row
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  DateFormatter.formatTime12Hour(request.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.arrow_upward, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatSize(request.requestSize),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.arrow_downward, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatSize(request.responseSize),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                if (request.error != null) ...[
                  const SizedBox(width: 12),
                  Icon(Icons.error, size: 12, color: Colors.red[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request.error!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

