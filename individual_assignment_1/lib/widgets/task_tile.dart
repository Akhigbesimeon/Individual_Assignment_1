import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskTile({super.key, required this.task, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: task.description != null && task.description!.isNotEmpty
            ? Text(task.description!)
            : null,
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'edit' && onEdit != null) onEdit!();
            if (v == 'del' && onDelete != null) onDelete!();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'del', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
