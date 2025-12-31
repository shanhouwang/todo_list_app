import 'package:todo_list_app/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:todo_list_app/features/todo/domain/entities/todo.dart';
import 'package:todo_list_app/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._remoteDataSource);

  final TodoRemoteDataSource _remoteDataSource;

  @override
  Future<List<Todo>> getTodos() async {
    final models = await _remoteDataSource.fetchTodos();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Todo> createTodo(String title) async {
    final model = await _remoteDataSource.createTodo(title);
    return model.toEntity();
  }
}
