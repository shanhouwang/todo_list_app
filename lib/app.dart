import 'package:flutter/material.dart';

import 'package:todo_list_app/core/theme/app_theme.dart';
import 'package:todo_list_app/features/todo/presentation/pages/todo_list_page.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const TodoListPage(),
    );
  }
}
