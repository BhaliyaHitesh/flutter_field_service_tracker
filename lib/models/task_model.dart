class Task {
  final int id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: "Mock task description",
      priority: "Medium",
      status: json['completed'] ? "Completed" : "Pending",
      dueDate: DateTime.now(),
    );
  }

  Task copyWith({String? status}) {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status ?? this.status,
      dueDate: dueDate,
    );
  }
}