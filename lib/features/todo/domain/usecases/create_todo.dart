import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

// 用例：通过仓库创建待办。
class CreateTodo {
  CreateTodo(this.repository);

  final TodoRepository repository;

  Future<Todo> call(String title) => repository.createTodo(title);
}
