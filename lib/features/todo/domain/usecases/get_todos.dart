import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class GetTodos {
  GetTodos(this.repository);

  final TodoRepository repository;

  Future<List<Todo>> call() => repository.getTodos();
}
