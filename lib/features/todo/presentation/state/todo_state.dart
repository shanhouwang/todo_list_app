import 'package:todo_list_app/features/todo/domain/entities/todo.dart';

const Object _unset = Object();

class TodoState {
  const TodoState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.todos = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final bool isSubmitting;
  final List<Todo> todos;
  final String? errorMessage;

  TodoState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<Todo>? todos,
    Object? errorMessage = _unset,
  }) {
    return TodoState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      todos: todos ?? this.todos,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }
}
