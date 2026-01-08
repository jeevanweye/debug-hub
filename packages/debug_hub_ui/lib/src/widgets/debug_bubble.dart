import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:base/base.dart';
import '../debug_hub_config.dart';
import '../screens/debug_main_screen.dart';

class DebugBubble extends StatefulWidget {
  final DebugHubConfig config;
  final GlobalKey<NavigatorState> navigatorKey;

  const DebugBubble({
    super.key,
    required this.config,
    required this.navigatorKey,
  });

  @override
  State<DebugBubble> createState() => _DebugBubbleState();
}

class _DebugBubbleState extends State<DebugBubble> {
  Offset? _position;
  bool _isVisible = true;
  bool _isDragging = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  static const double _shakeThreshold = 25.0;

  @override
  void initState() {
    super.initState();
    // Shake gesture is disabled by default to keep bubble always visible
    // if (widget.config.enableShakeGesture) {
    //   _setupShakeDetection();
    // }
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

  void _setupShakeDetection() {
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      final now = DateTime.now();
      if (_lastShakeTime != null &&
          now.difference(_lastShakeTime!) < const Duration(milliseconds: 500)) {
        return;
      }

      final acceleration = event.x.abs() + event.y.abs() + event.z.abs();
      if (acceleration > _shakeThreshold) {
        _lastShakeTime = now;
        _toggleVisibility();
      }
    });
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _openDebugScreen() {
    final navigator = widget.navigatorKey.currentState;
    if (navigator != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) => DebugMainScreen(config: widget.config),
        ),
      );
    }
  }

  void _onLongPress() {
    final navigator = widget.navigatorKey.currentState;
    final context = navigator?.context;
    
    if (navigator != null && context != null) {
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
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            width: 60,
            height: 60,
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
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

