import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_list_app/app.dart';

void main() {
  // Flutter 入口；ProviderScope 启用 Riverpod 状态管理。
  runApp(const ProviderScope(child: TodoApp()));
}
