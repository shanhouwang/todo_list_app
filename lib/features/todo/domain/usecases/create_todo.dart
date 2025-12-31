import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class CreateTodo {
  CreateTodo(this.repository);

  final TodoRepository repository;

  Future<Todo> call(String title) => repository.createTodo(title);
}
