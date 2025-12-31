import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/core/network/api_client.dart';
import 'package:todo_list_app/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:todo_list_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_list_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list_app/features/todo/domain/usecases/create_todo.dart';
import 'package:todo_list_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_state.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  ref.onDispose(client.dispose);
  return client;
});

final todoRemoteDataSourceProvider = Provider<TodoRemoteDataSource>((ref) {
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

final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  return TodoNotifier(
    getTodos: ref.watch(getTodosProvider),
    createTodo: ref.watch(createTodoProvider),
  );
});

class TodoNotifier extends StateNotifier<TodoState> {
  TodoNotifier({
    required this.getTodos,
    required this.createTodo,
  }) : super(const TodoState()) {
    loadTodos();
  }

  final GetTodos getTodos;
  final CreateTodo createTodo;

  Future<void> loadTodos() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final todos = await getTodos();
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
      final todo = await createTodo(title.trim());
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
}
