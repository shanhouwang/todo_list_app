import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/core/network/api_client.dart';
import 'package:todo_list_app/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:todo_list_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_list_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list_app/features/todo/domain/usecases/create_todo.dart';
import 'package:todo_list_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_notifier.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_state.dart';

// 示例方案 2：保留仓库 Provider，其它依赖在上层组装。
final todoRepositoryProviderVariant2 = Provider<TodoRepository>((ref) {
  final client = ApiClient();
  ref.onDispose(client.dispose);

  final remote = TodoRemoteDataSource(client);
  return TodoRepositoryImpl(remote);
});

final todoNotifierProviderVariant2 =
    StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  final repository = ref.watch(todoRepositoryProviderVariant2);
  return TodoNotifier(
    getTodos: GetTodos(repository),
    createTodo: CreateTodo(repository),
  );
});
