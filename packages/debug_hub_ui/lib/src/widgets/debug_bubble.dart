import 'package:flutter/material.dart';
import 'package:base/base.dart';
import '../debug_hub_config.dart';
import '../screens/debug_main_screen.dart';
import '../navigation/debug_hub_navigator_observer.dart';

class DebugBubble extends StatefulWidget {
  final DebugHubConfig config;

  const DebugBubble({
    super.key,
    required this.config,
  });

  @override
  State<DebugBubble> createState() => _DebugBubbleState();
}

class _DebugBubbleState extends State<DebugBubble> {
  Offset? _position;
  bool _isVisible = true;
  bool _isDragging = false;
  final DebugHubNavigatorObserver _observer = DebugHubNavigatorObserver();

  @override
  void initState() {
    super.initState();
  }

  Offset _getPosition(BuildContext context) {
    if (_position != null) return _position!;
    
    final size = MediaQuery.of(context).size;
    final alignment = widget.config.bubbleAlignment;
    
    // Default position: bottom-right corner
    return Offset(
      alignment.x > 0 ? size.width - 80 : 20,
      alignment.y > 0 ? size.height - 150 : 100,
    );
  }

  void _openDebugScreen() {
    // Use NavigatorState from NavigatorObserver (similar to WEChucker)
    final navigatorState = _observer.navigatorState;
    
    if (navigatorState != null) {
      navigatorState.push(
        MaterialPageRoute(
          builder: (context) => DebugMainScreen(config: widget.config),
        ),
      );
    } else {
      debugPrint('⚠️ DebugHub: NavigatorState not available. Make sure DebugHubNavigatorObserver is added to navigatorObservers.');
    }
  }

  void _onLongPress() {
    // Use widget's build context for dialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('DebugHub'),
        content: const Text('Do you want to clear all debug data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Clear all data
              DebugStorage().clearAll();
              Navigator.of(dialogContext).pop();
              
              // Show snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All debug data cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // navigatorContext should be provided from MaterialAppExtension's builder
    // which is inside the Navigator tree
    if (!_isVisible) return const SizedBox.shrink();

    final position = _getPosition(context);

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanStart: (_) {
          setState(() {
            _isDragging = true;
          });
        },
        onPanUpdate: (details) {
          final size = MediaQuery.of(context).size;
          setState(() {
            final currentPos = _position ?? position;
            _position = Offset(
              (currentPos.dx + details.delta.dx).clamp(0.0, size.width - 60),
              (currentPos.dy + details.delta.dy).clamp(0.0, size.height - 60),
            );
          });
        },
        onPanEnd: (_) {
          setState(() {
            _isDragging = false;
          });
        },
        onTap: _openDebugScreen,
        onLongPress: _onLongPress,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: _isDragging 
                  ? widget.config.mainColor.withOpacity(0.8)
                  : widget.config.mainColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.bug_report,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

