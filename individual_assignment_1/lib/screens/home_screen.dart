import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/task_repository.dart';
import 'today_screen.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  final TaskRepository repo;
  final SharedPreferences prefs;
  final ValueChanged<bool> onToggleReminders;

  const HomeScreen({
    super.key,
    required this.repo,
    required this.prefs,
    required this.onToggleReminders,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _idx = 0;

  void _navigateToAdd() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TaskFormScreen(repo: widget.repo)),
    );
    if (result == true) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      TodayScreen(repo: widget.repo, onChanged: () => setState(() {})),
      CalendarScreen(repo: widget.repo, onChanged: () => setState(() {})),
      SettingsScreen(
        prefs: widget.prefs,
        onToggleReminders: widget.onToggleReminders,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Study Planner')),
      body: pages[_idx],
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        tooltip: 'New Task',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
