import 'package:flutter/material.dart';

import 'package:todo_list_app/core/theme/app_theme.dart';
import 'package:todo_list_app/features/todo/presentation/pages/todo_list_page.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp 负责全局主题、路由和基础 UI 配置。
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(), // 集中配置主题。
      home: const TodoListPage(), // 用户看到的第一个页面。
    );
  }
}
