class Task {
  String id;
  String title;
  String? description;
  DateTime dueDate;
  DateTime? reminderAt;
  bool reminderShown;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.reminderAt,
    this.reminderShown = false,
  });

  factory Task.fromJson(Map<String, dynamic> j) {
    return Task(
      id: j['id'],
      title: j['title'],
      description: j['description'],
      dueDate: DateTime.parse(j['dueDate']),
      reminderAt: j['reminderAt'] == null
          ? null
          : DateTime.parse(j['reminderAt']),
      reminderShown: j['reminderShown'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate.toIso8601String(),
    'reminderAt': reminderAt?.toIso8601String(),
    'reminderShown': reminderShown,
  };
}
