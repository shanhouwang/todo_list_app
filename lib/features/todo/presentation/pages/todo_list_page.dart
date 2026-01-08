import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_notifier.dart';
import 'package:todo_list_app/features/todo/presentation/state/todo_state.dart';
import 'package:todo_list_app/features/todo/presentation/widgets/todo_item.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听状态，todos 变化时触发重建。
    final state = ref.watch(todoNotifierProvider);
    // 读取 notifier 以执行加载、添加、切换等操作。
    final notifier = ref.read(todoNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Column(
        children: [
          if (state.isSubmitting)
            const LinearProgressIndicator(minHeight: 2),
          if (state.errorMessage != null)
            _ErrorBanner(message: state.errorMessage!),
          Expanded(
            child: _buildBody(context, state, notifier),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isSubmitting
            ? null
            : () => _showAddDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TodoState state,
    TodoNotifier notifier,
  ) {
    if (state.isLoading && state.todos.isEmpty) {
      // 首次加载：没有数据时显示加载指示器。
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.todos.isEmpty) {
      // 错误且无数据：显示重试界面。
      return _ErrorView(onRetry: notifier.loadTodos);
    }

    return RefreshIndicator(
      // 下拉刷新触发重新拉取网络数据。
      onRefresh: notifier.loadTodos,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.todos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final todo = state.todos[index];
          return TodoItem(
            todo: todo,
            onChanged: (value) {
              // 复选框切换本地完成状态。
              notifier.toggleTodo(index, value ?? false);
            },
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // showDialog 返回的 Future 在对话框关闭时完成。
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('New Todo'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'What needs to be done?',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task.';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(dialogContext).pop(controller.text.trim());
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(dialogContext).pop(controller.text.trim());
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      await ref.read(todoNotifierProvider.notifier).addTodo(result);
    }
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.errorContainer,
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48),
            const SizedBox(height: 12),
            Text(
              'Failed to load todos.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
