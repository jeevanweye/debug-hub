import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    Center(child: Text('Network')),
    Center(child: Text('Events')),
    Center(child: Text('Notification')),
    Center(child: Text('NonFatal')),
    Center(child: Text('Logs')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Debug Hub"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search, size: 24)),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete, size: 24)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.import_export, size: 24),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.menu, size: 24)),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.web), label: 'Network'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_important_outlined),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bug_report),
            label: 'NonFatal',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.error), label: 'Logs'),
        ],
      ),
    );
  }
}
