import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/core/network/api_client.dart';
import 'package:todo_list_app/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:todo_list_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_list_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list_app/features/todo/domain/usecases/create_todo.dart';
import 'package:todo_list_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_notifier.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_state.dart';

// Provider 用来串起从底层 API 到 UI 状态的依赖关系。
// 让 Riverpod 管理它的生命周期和依赖
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  // ref.onDispose 负责自动释放
  ref.onDispose(client.dispose);
  return client;
});

final todoRemoteDataSourceProvider = Provider<TodoRemoteDataSource>((ref) {
  // ref.watch 的意思是“订阅并读取”
  // 当它依赖的 Provider 发生变化时，当前 Provider 会重新计算，或 Widget 会重新 build
  return TodoRemoteDataSource(ref.watch(apiClientProvider));
});

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(ref.watch(todoRemoteDataSourceProvider));
});

final getTodosProvider = Provider<GetTodos>((ref) {
  return GetTodos(ref.watch(todoRepositoryProvider));
});

final createTodoProvider = Provider<CreateTodo>((ref) {
  return CreateTodo(ref.watch(todoRepositoryProvider));
});

// StateNotifier 持有界面状态，并暴露异步操作。
final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  return TodoNotifier(
    getTodos: ref.watch(getTodosProvider),
    createTodo: ref.watch(createTodoProvider),
  );
});
