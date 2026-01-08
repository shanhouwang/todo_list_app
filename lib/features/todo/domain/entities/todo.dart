// 领域实体，表示应用中的待办项。
class Todo {
  const Todo({
    required this.title,
    required this.completed,
    this.id,
  });

  final int? id;
  final String title;
  final bool completed;

  Todo copyWith({
    int? id,
    String? title,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
