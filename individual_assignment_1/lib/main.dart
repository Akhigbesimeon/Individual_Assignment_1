import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/task_repository.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final repo = TaskRepository(prefs);
  runApp(StudyPlannerApp(repo: repo, prefs: prefs));
}

class StudyPlannerApp extends StatelessWidget {
  final TaskRepository repo;
  final SharedPreferences prefs;

  const StudyPlannerApp({super.key, required this.repo, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(
        repo: repo,
        prefs: prefs,
        onToggleReminders: (val) {
          prefs.setBool('reminders', val);
        },
      ),
    );
  }
}
