import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final ValueChanged<bool> onToggleReminders;

  const SettingsScreen({
    super.key,
    required this.prefs,
    required this.onToggleReminders,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool remindersEnabled = true;

  @override
  void initState() {
    super.initState();
    remindersEnabled = widget.prefs.getBool('remindersEnabled') ?? true;
  }

  void _toggle(bool val) {
    setState(() {
      remindersEnabled = val;
      widget.prefs.setBool('remindersEnabled', val);
    });
    widget.onToggleReminders(val);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ListTile(
            title: const Text('Notifications'),
            trailing: Switch(value: remindersEnabled, onChanged: _toggle),
          ),
          const ListTile(
            title: Text('Storage'),
            subtitle: Text('shared_preferences (JSON)'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tip: Long-press the reminder row when editing a task to clear the reminder.',
          ),
        ],
      ),
    );
  }
}
