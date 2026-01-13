import 'package:flutter/material.dart';
import '../debug_hub_config.dart';
import 'network_screen.dart';
import 'logs_screen.dart';
import 'crashes_screen.dart';
import 'events_screen.dart';
import 'more_screen.dart';
import 'notifications_screen.dart';

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
    EventsScreen(config: widget.config),
    NotificationsScreen(config: widget.config),
    LogsScreen(config: widget.config),
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
      icon: Icon(Icons.analytics),
      label: 'Events',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.notifications_active_rounded),
      label: 'Notifications',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.article),
      label: 'Logs',
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
    return Scaffold(
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
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
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

