import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/features/todo/domain/entities/todo.dart';
import 'package:todo_list_app/features/todo/presentation/pages/todo_list_page.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_notifier.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_state.dart';

class FakeTodoNotifier extends StateNotifier<TodoState> {
  FakeTodoNotifier()
      : super(
          const TodoState(
            todos: [Todo(id: 1, title: 'Sample task', completed: false)],
          ),
        );
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
