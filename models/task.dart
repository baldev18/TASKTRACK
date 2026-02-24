
class Task {
  int? id;
  String title;
  String description;
  String dueDate;
  String status;
  String priority;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'status': status,
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['due_date'],
      status: map['status'],
      priority: map['priority'],
    );
  }
}