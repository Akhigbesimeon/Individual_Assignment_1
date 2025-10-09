import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskRepository {
  final SharedPreferences prefs;
  static const _key = 'tasks_json';
  TaskRepository(this.prefs);

  Future<List<Task>> loadTasks() async {
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Task.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final str = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_key, str);
  }

  Future<void> addOrUpdate(Task task) async {
    final tasks = await loadTasks();
    final idx = tasks.indexWhere((t) => t.id == task.id);
    if (idx >= 0) {
      tasks[idx] = task;
    } else {
      tasks.add(task);
    }
    await saveTasks(tasks);
  }

  Future<void> deleteTask(String id) async {
    final tasks = await loadTasks();
    tasks.removeWhere((t) => t.id == id);
    await saveTasks(tasks);
  }
}
