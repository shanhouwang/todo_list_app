import 'package:todo_list_app/core/constants/app_constants.dart';
import 'package:todo_list_app/core/network/api_client.dart';
import 'package:todo_list_app/features/todo/data/models/todo_model.dart';

class TodoRemoteDataSource {
  TodoRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<TodoModel>> fetchTodos({
    int limit = AppConstants.todoPageSize,
  }) async {
    final result = await _client.getList(
      '/todos',
      query: {'_limit': limit.toString()},
    );

    return result
        .map((item) => TodoModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<TodoModel> createTodo(String title) async {
    final result = await _client.post(
      '/todos',
      {
        'title': title,
        'completed': false,
      },
    );

    return TodoModel.fromJson(result);
  }
}
