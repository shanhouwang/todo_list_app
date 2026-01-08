import 'package:todo_list_app/features/todo/domain/entities/todo.dart';

// 数据层模型，提供 JSON 解析/序列化，并继承领域实体。
class TodoModel extends Todo {
  const TodoModel({
    required super.title,
    required super.completed,
    super.id,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as int?,
      title: (json['title'] ?? '') as String,
      completed: json['completed'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }

  // 转换为应用内部使用的领域实体。
  Todo toEntity() {
    return Todo(id: id, title: title, completed: completed);
  }

  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      completed: todo.completed,
    );
  }
}
