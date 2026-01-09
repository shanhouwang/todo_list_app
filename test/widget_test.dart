import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/features/todo/domain/entities/todo.dart';
import 'package:todo_list_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list_app/features/todo/domain/usecases/create_todo.dart';
import 'package:todo_list_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_list_app/features/todo/presentation/pages/todo_list_page.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_notifier.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_providers.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_state.dart';

class FakeTodoRepository implements TodoRepository {
  @override
  Future<List<Todo>> getTodos() async {
    return const [Todo(id: 1, title: 'Sample task', completed: false)];
  }

  @override
  Future<Todo> createTodo(String title) async {
    return Todo(id: 2, title: title, completed: false);
  }
}

class FakeTodoNotifier extends TodoNotifier {
  FakeTodoNotifier()
      : super(
          getTodos: GetTodos(FakeTodoRepository()),
          createTodo: CreateTodo(FakeTodoRepository()),
        ) {
    state = const TodoState(
      todos: [Todo(id: 1, title: 'Sample task', completed: false)],
    );
  }

  @override
  Future<void> loadTodos() async {}
}

void main() {
  testWidgets('Todo list shows items', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todoNotifierProvider.overrideWith((ref) => FakeTodoNotifier()),
        ],
        child: const MaterialApp(home: TodoListPage()),
      ),
    );

    expect(find.text('Todo List'), findsOneWidget);
    expect(find.text('Sample task'), findsOneWidget);
  });
}
