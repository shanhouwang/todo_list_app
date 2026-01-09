import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/core/network/api_client.dart';
import 'package:todo_list_app/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:todo_list_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_list_app/features/todo/domain/entities/todo.dart';
import 'package:todo_list_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list_app/features/todo/domain/usecases/create_todo.dart';
import 'package:todo_list_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_state.dart';

// 示例方案 3：在 Notifier 内部直接创建依赖。
class SimpleTodoNotifier extends StateNotifier<TodoState> {
  SimpleTodoNotifier()
      : _client = ApiClient(),
        super(const TodoState()) {
    _remoteDataSource = TodoRemoteDataSource(_client);
    _repository = TodoRepositoryImpl(_remoteDataSource);
    _getTodos = GetTodos(_repository);
    _createTodo = CreateTodo(_repository);
    loadTodos();
  }

  final ApiClient _client;
  late final TodoRemoteDataSource _remoteDataSource;
  late final TodoRepository _repository;
  late final GetTodos _getTodos;
  late final CreateTodo _createTodo;

  Future<void> loadTodos() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final todos = await _getTodos();
      state = state.copyWith(
        isLoading: false,
        todos: todos,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) {
      return;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final todo = await _createTodo(title.trim());
      state = state.copyWith(
        isSubmitting: false,
        todos: [todo, ...state.todos],
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );
    }
  }

  void toggleTodo(int index, bool value) {
    final updated = [...state.todos];
    final todo = updated[index];
    updated[index] = todo.copyWith(completed: value);
    state = state.copyWith(todos: updated, errorMessage: state.errorMessage);
  }

  void close() => _client.dispose();
}

final simpleTodoNotifierProviderVariant3 =
    StateNotifierProvider<SimpleTodoNotifier, TodoState>((ref) {
  final notifier = SimpleTodoNotifier();
  ref.onDispose(notifier.close);
  return notifier;
});
