import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Model for info card items
class NetworkInfoItem {
  final String label;
  final String value;
  final bool isError;

  NetworkInfoItem(this.label, this.value, {this.isError = false});
}

/// Reusable card widget for displaying network information
class NetworkInfoCard extends StatelessWidget {
  final String title;
  final List<NetworkInfoItem> items;
  final bool showCopyButtons;

  const NetworkInfoCard({
    super.key,
    required this.title,
    required this.items,
    this.showCopyButtons = true,
  });

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    UpperToast.show(context, '$label copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
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
                child: Text('No items', style: TextStyle(color: Colors.grey)),
              )
            else
              ...items.map(
                (item) => Padding(
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    item.value,
                                    style: TextStyle(
                                      color: item.isError
                                          ? Colors.red
                                          : Colors.black87,
                                      fontFamily: item.value.length > 50
                                          ? 'monospace'
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (showCopyButtons)
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2),
                                child: GestureDetector(
                                  onTap: () => _copyToClipboard(
                                    context,
                                    item.value,
                                    item.label,
                                  ),
                                  child: const Icon(Icons.copy, size: 16),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
