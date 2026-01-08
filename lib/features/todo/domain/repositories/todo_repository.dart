import '../entities/todo.dart';

// 领域层契约；UI 和用例依赖它而非具体实现。
abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> createTodo(String title);
}
