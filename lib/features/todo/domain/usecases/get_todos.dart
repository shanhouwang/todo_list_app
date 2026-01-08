import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

// 用例：通过仓库获取全部待办。
class GetTodos {
  GetTodos(this.repository);

  final TodoRepository repository;

  Future<List<Todo>> call() => repository.getTodos();
}
