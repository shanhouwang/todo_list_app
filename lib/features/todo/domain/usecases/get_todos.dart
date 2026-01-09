import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

// 用例：通过仓库获取全部待办。
class GetTodos {
  GetTodos(this.repository);

  final TodoRepository repository;

  // Dart 的 call 语法让实例像函数一样被调用：getTodos() 等同于 getTodos.call()。
  Future<List<Todo>> call() => repository.getTodos();
}
