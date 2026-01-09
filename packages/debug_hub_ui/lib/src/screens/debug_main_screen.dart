import 'package:flutter/material.dart';
import '../debug_hub_config.dart';
import 'network_screen.dart';
import 'logs_screen.dart';
import 'crashes_screen.dart';
import 'events_screen.dart';
import 'more_screen.dart';

class DebugMainScreen extends StatefulWidget {
  final DebugHubConfig config;

  const DebugMainScreen({
    super.key,
    required this.config,
  });

  @override
  State<DebugMainScreen> createState() => _DebugMainScreenState();
}

class _DebugMainScreenState extends State<DebugMainScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    NetworkScreen(config: widget.config),
    LogsScreen(config: widget.config),
    CrashesScreen(config: widget.config),
    EventsScreen(config: widget.config),
    MoreScreen(config: widget.config),
    if (widget.config.additionalTab != null)
      widget.config.additionalTab!,
  ];

  List<BottomNavigationBarItem> get _navItems => [
    const BottomNavigationBarItem(
      icon: Icon(Icons.network_check),
      label: 'Network',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.article),
      label: 'Logs',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.warning_amber),
      label: 'Crash',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.analytics),
      label: 'Events',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.more_horiz),
      label: 'More',
    ),
    if (widget.config.additionalTab != null)
      BottomNavigationBarItem(
        icon: Icon(widget.config.additionalTabIcon ?? Icons.extension),
        label: widget.config.additionalTabLabel ?? 'Custom',
      ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DebugHub'),
          backgroundColor: widget.config.mainColor,
          foregroundColor: Colors.white,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: _navItems,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: widget.config.mainColor,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12,
            unselectedFontSize: 11,
            showUnselectedLabels: true,
          ),
        ),
      ),
    );
  }
}

