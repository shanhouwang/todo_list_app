import 'package:flutter/material.dart';
import 'package:todo_list_app/features/todo/domain/entities/todo.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
    required this.onChanged,
  });

  final Todo todo;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          decoration: todo.completed ? TextDecoration.lineThrough : null,
          color: todo.completed
              ? Theme.of(context).colorScheme.outline
              : Theme.of(context).colorScheme.onSurface,
        );

    return Card(
      child: ListTile(
        leading: Checkbox(value: todo.completed, onChanged: onChanged),
        title: Text(todo.title, style: textStyle),
        subtitle: todo.id == null
            ? const Text('Local item')
            : Text('Remote #${todo.id}'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
