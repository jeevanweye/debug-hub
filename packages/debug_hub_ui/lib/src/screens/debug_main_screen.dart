import 'package:flutter/material.dart';
import '../debug_hub_config.dart';
import 'network_screen.dart';
import 'logs_screen.dart';
import 'crashes_screen.dart';
import 'storage_screen.dart';
import 'app_info_screen.dart';

class DebugMainScreen extends StatefulWidget {
  final DebugHubConfig config;

  const DebugMainScreen({
    super.key,
    required this.config,
  });

  @override
  State<DebugMainScreen> createState() => _DebugMainScreenState();
}

class _DebugMainScreenState extends State<DebugMainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final tabCount = widget.config.additionalTab != null ? 6 : 5;
    _tabController = TabController(length: tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DebugHub'),
        backgroundColor: widget.config.mainColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            const Tab(icon: Icon(Icons.network_check), text: 'Network'),
            const Tab(icon: Icon(Icons.article), text: 'Logs'),
            const Tab(icon: Icon(Icons.error_outline), text: 'Crashes'),
            const Tab(icon: Icon(Icons.folder), text: 'Storage'),
            const Tab(icon: Icon(Icons.info), text: 'App Info'),
            if (widget.config.additionalTab != null)
              Tab(
                icon: Icon(widget.config.additionalTabIcon ?? Icons.extension),
                text: widget.config.additionalTabLabel ?? 'Custom',
              ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NetworkScreen(config: widget.config),
          LogsScreen(config: widget.config),
          CrashesScreen(config: widget.config),
          StorageScreen(config: widget.config),
          AppInfoScreen(config: widget.config),
          if (widget.config.additionalTab != null)
            widget.config.additionalTab!,
        ],
      ),
    );
  }
}

