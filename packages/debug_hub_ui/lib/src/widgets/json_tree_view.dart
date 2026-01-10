import 'dart:convert';
import 'package:flutter/material.dart';

/// Interactive JSON tree node widget that recursively renders JSON data
class JsonTreeNode extends StatefulWidget {
  final dynamic data;
  final int level;
  final String? name;

  const JsonTreeNode({
    super.key,
    required this.data,
    required this.level,
    this.name,
  });

  @override
  State<JsonTreeNode> createState() => _JsonTreeNodeState();
}

class _JsonTreeNodeState extends State<JsonTreeNode> {
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    // Auto-collapse deeply nested items
    _isExpanded = widget.level < 2;
  }

  Color _getTypeColor(dynamic value) {
    if (value == null) return Colors.grey;
    if (value is String) return Colors.green[700]!;
    if (value is num) return Colors.blue[700]!;
    if (value is bool) return Colors.orange[700]!;
    return Colors.black87;
  }

  String _getTypeLabel(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return 'String';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is List) return 'Array[${value.length}]';
    if (value is Map) return 'Object{${value.length}}';
    return value.runtimeType.toString();
  }

  Widget _buildPrimitiveValue(dynamic value) {
    String displayValue;
    if (value == null) {
      displayValue = 'null';
    } else if (value is String) {
      displayValue = '"$value"';
    } else {
      displayValue = value.toString();
    }

    return SelectableText(
      displayValue,
      style: TextStyle(
        color: _getTypeColor(value),
        fontFamily: 'monospace',
        fontSize: 13,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leftPadding = widget.level * 20.0;

    // Primitive values (leaf nodes)
    if (widget.data == null ||
        widget.data is String ||
        widget.data is num ||
        widget.data is bool) {
      return Padding(
        padding: EdgeInsets.only(left: leftPadding, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.name != null) ...[
              SelectableText(
                '${widget.name}: ',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
              ),
            ],
            Expanded(child: _buildPrimitiveValue(widget.data)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getTypeColor(widget.data).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getTypeLabel(widget.data),
                style: TextStyle(
                  fontSize: 10,
                  color: _getTypeColor(widget.data),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Complex values (Maps and Lists)
    final isMap = widget.data is Map;
    final isList = widget.data is List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with expand/collapse button
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.only(left: leftPadding, bottom: 4),
            child: Row(
              children: [
                Icon(
                  _isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                if (widget.name != null) ...[
                  SelectableText(
                    '${widget.name}: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.purple[200]!),
                  ),
                  child: Text(
                    _getTypeLabel(widget.data),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.purple[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!_isExpanded) ...[
                  const SizedBox(width: 8),
                  Text(
                    '...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // Children (when expanded)
        if (_isExpanded) ...[
          if (isMap)
            ...(widget.data as Map).entries.map((entry) {
              return JsonTreeNode(
                data: entry.value,
                level: widget.level + 1,
                name: entry.key.toString(),
              );
            })
          else if (isList)
            ...(widget.data as List).asMap().entries.map((entry) {
              return JsonTreeNode(
                data: entry.value,
                level: widget.level + 1,
                name: '[${entry.key}]',
              );
            }),
        ],
      ],
    );
  }
}

/// Builder widget that handles JSON parsing and displays tree view
class JsonTreeView extends StatelessWidget {
  final dynamic data;
  final bool isRequest;

  const JsonTreeView({
    super.key,
    required this.data,
    this.isRequest = true,
  });

  @override
  Widget build(BuildContext context) {
    try {
      // Try to parse as JSON
      dynamic jsonData;
      if (data is String) {
        try {
          jsonData = jsonDecode(data);
        } catch (e) {
          // Not JSON, return error widget
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Not valid JSON data',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          );
        }
      } else {
        jsonData = data;
      }

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          JsonTreeNode(
            data: jsonData,
            level: 0,
            name: isRequest ? 'request' : 'response',
          ),
        ],
      );
    } catch (e) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Unable to parse data: $e',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }
}

