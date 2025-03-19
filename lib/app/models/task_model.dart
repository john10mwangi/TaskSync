class TaskModel {
  final int id;
  final String title;
  final String priority;
  bool completed;
  final String? dueDate;

  TaskModel(
      {required this.title,
      required this.id,
      required this.priority,
      required this.completed,
      this.dueDate});

  // Convert JSON to TaskModel
  factory TaskModel.fromJson(Map<String, dynamic> data) => TaskModel(
        title: data['title'],
        id: data['id'],
        priority: data['priority'],
        completed: data['completed'],
        dueDate: data['dueDate'],
      );

  // Convert TaskModel to a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "priority": priority,
      "completed": completed,
      "dueDate": dueDate,
    };
  }
}
