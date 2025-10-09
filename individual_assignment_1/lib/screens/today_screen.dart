import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_repository.dart';
import '../widgets/task_tile.dart';
import 'task_form_screen.dart';

class TodayScreen extends StatefulWidget {
  final TaskRepository repo;
  final VoidCallback onChanged;

  const TodayScreen({super.key, required this.repo, required this.onChanged});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await widget.repo.loadTasks();
    final today = DateTime.now();
    final formattedToday = DateTime(today.year, today.month, today.day);

    setState(() {
      tasks = all.where((t) {
        final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
        return d == formattedToday;
      }).toList()..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });
  }

  Future<void> _onEdit(Task t) async {
    final res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(repo: widget.repo, initial: t),
      ),
    );
    if (res == true) await _load();
    widget.onChanged();
  }

  Future<void> _onDelete(Task t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('Delete "${t.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await widget.repo.deleteTask(t.id);
      await _load();
      widget.onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMMd();
    final today = DateTime.now();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
            'Today — ${df.format(today)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (tasks.isEmpty)
            const Center(child: Text('No tasks for today. Tap + to add.')),
          ...tasks.map(
            (t) => TaskTile(
              task: t,
              onEdit: () => _onEdit(t),
              onDelete: () => _onDelete(t),
            ),
          ),
        ],
      ),
    );
  }
}
