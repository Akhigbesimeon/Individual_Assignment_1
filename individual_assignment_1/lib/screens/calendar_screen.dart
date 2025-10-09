import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_repository.dart';
import '../widgets/task_tile.dart';
import 'task_form_screen.dart';

class CalendarScreen extends StatefulWidget {
  final TaskRepository repo;
  final VoidCallback onChanged;

  const CalendarScreen({
    super.key,
    required this.repo,
    required this.onChanged,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime displayed = DateTime.now();
  DateTime? selected;
  Map<String, List<Task>> tasksByDate = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  String _keyForDate(DateTime d) =>
      DateTime(d.year, d.month, d.day).toIso8601String();

  Future<void> _load() async {
    final all = await widget.repo.loadTasks();
    final map = <String, List<Task>>{};
    for (var t in all) {
      final k = _keyForDate(t.dueDate);
      map.putIfAbsent(k, () => []).add(t);
    }
    setState(() {
      tasksByDate = map;
    });
  }

  void _prevMonth() {
    setState(() {
      displayed = DateTime(displayed.year, displayed.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      displayed = DateTime(displayed.year, displayed.month + 1, 1);
    });
  }

  List<DateTime> _daysInMonth(DateTime date) {
    final last = DateTime(date.year, date.month + 1, 0);
    return List.generate(
      last.day,
      (i) => DateTime(date.year, date.month, i + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat.yMMMM().format(displayed);
    final days = _daysInMonth(displayed);
    final firstWeekday = DateTime(displayed.year, displayed.month, 1).weekday;

    return RefreshIndicator(
      onRefresh: () async {
        await _load();
        widget.onChanged();
      },
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _prevMonth,
              ),
              Text(monthName, style: Theme.of(context).textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final label = DateFormat.E().format(DateTime(2020, 1, 6 + i));
              return Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length + (firstWeekday - 1),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, idx) {
              if (idx < firstWeekday - 1) return Container();
              final day = days[idx - (firstWeekday - 1)];
              final k = _keyForDate(day);
              final hasTasks = tasksByDate.containsKey(k);
              final isSelected =
                  selected != null && _keyForDate(selected!) == k;
              return GestureDetector(
                onTap: () async {
                  setState(() => selected = day);
                  await _load();
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromARGB(255, 198, 233, 197)
                        : null,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      if (hasTasks)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 0, 255, 72),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Text('Tasks', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (selected == null) const Text('Tap a date to view tasks.'),
          if (selected != null) ..._buildTasksForSelected(),
        ],
      ),
    );
  }

  List<Widget> _buildTasksForSelected() {
    final k = _keyForDate(selected!);
    final list = tasksByDate[k] ?? [];
    if (list.isEmpty) {
      return [Text('No tasks for ${DateFormat.yMMMd().format(selected!)}')];
    }

    return list
        .map(
          (t) => TaskTile(
            task: t,
            onEdit: () async {
              final res = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TaskFormScreen(repo: widget.repo, initial: t),
                ),
              );
              if (res == true) await _load();
              widget.onChanged();
            },
            onDelete: () async {
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
            },
          ),
        )
        .toList();
  }
}
