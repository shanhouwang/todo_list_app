import 'package:todo_list_app/core/constants/app_constants.dart';
import 'package:todo_list_app/core/network/api_client.dart';
import 'package:todo_list_app/features/todo/data/models/todo_model.dart';

// 远程数据源负责调用 HTTP API 并解析 JSON。
class TodoRemoteDataSource {
  TodoRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<TodoModel>> fetchTodos({
    int limit = AppConstants.todoPageSize,
  }) async {
    // 调用 GET /todos 并带上数量限制。
    final result = await _client.getList(
      '/todos',
      query: {'_limit': limit.toString()},
    );

    return result
        .map((item) => TodoModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<TodoModel> createTodo(String title) async {
    // 调用 POST /todos 创建新任务。
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
