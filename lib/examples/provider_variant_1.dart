import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/core/network/api_client.dart';
import 'package:todo_list_app/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:todo_list_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_list_app/features/todo/domain/usecases/create_todo.dart';
import 'package:todo_list_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_notifier.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_state.dart';

// 示例方案 1：把所有依赖装配放在一个 Provider 里。
final todoNotifierProviderVariant1 =
    StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  final client = ApiClient();
  ref.onDispose(client.dispose);

  final remote = TodoRemoteDataSource(client);
  final repository = TodoRepositoryImpl(remote);

  return TodoNotifier(
    getTodos: GetTodos(repository),
    createTodo: CreateTodo(repository),
  );
});
