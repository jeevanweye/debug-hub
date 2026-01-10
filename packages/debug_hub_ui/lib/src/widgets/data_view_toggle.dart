import 'package:flutter/material.dart';

enum DataViewMode { tree, text }

/// Toggle widget for switching between Tree and Text view modes
class DataViewToggle extends StatelessWidget {
  final DataViewMode selectedMode;
  final ValueChanged<DataViewMode> onModeChanged;
  final String label;
  final VoidCallback? onCopy;
  final bool showCopyButton;

  const DataViewToggle({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
    required this.label,
    this.onCopy,
    this.showCopyButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              SegmentedButton<DataViewMode>(
                segments: const [
                  ButtonSegment(
                    value: DataViewMode.tree,
                    label: Text('Tree'),
                    icon: Icon(Icons.account_tree, size: 16),
                  ),
                  ButtonSegment(
                    value: DataViewMode.text,
                    label: Text('Text'),
                    icon: Icon(Icons.code, size: 16),
                  ),
                ],
                selected: {selectedMode},
                onSelectionChanged: (Set<DataViewMode> newSelection) {
                  onModeChanged(newSelection.first);
                },
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              if (showCopyButton && onCopy != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: onCopy,
                  tooltip: 'Copy',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

