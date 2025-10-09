import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_repository.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskRepository repo;
  final Task? initial;

  const TaskFormScreen({super.key, required this.repo, this.initial});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  String? description;
  late DateTime dueDate;
  DateTime? reminderAt;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    if (widget.initial != null) {
      title = widget.initial!.title;
      description = widget.initial!.description;
      dueDate = widget.initial!.dueDate;
      reminderAt = widget.initial!.reminderAt;
    } else {
      title = '';
      dueDate = DateTime(now.year, now.month, now.day);
    }
  }

  Future<void> _pickDueDate() async {
    final r = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (r != null) setState(() => dueDate = r);
  }

  Future<void> _pickReminder() async {
    final date = await showDatePicker(
      context: context,
      initialDate: reminderAt ?? dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    final dt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() => reminderAt = dt);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final id = widget.initial?.id ?? UniqueKey().toString();
    final t = Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      reminderAt: reminderAt,
      reminderShown: widget.initial?.reminderShown ?? false,
    );
    await widget.repo.addOrUpdate(t);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd();
    final tf = DateFormat.jm();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? 'New Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title required' : null,
                onSaved: (v) => title = v!.trim(),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (v) => description = v?.trim(),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text(df.format(dueDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDueDate,
              ),
              ListTile(
                title: const Text('Reminder (optional)'),
                subtitle: reminderAt == null
                    ? const Text('None')
                    : Text(
                        '${df.format(reminderAt!)} ${tf.format(reminderAt!)}',
                      ),
                trailing: const Icon(Icons.alarm),
                onTap: _pickReminder,
                onLongPress: () => setState(() => reminderAt = null),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
