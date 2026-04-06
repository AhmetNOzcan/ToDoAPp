import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_feature_domain/todo_feature_domain.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: () => context.push('/todos/${todo.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Checkbox(
                  value: todo.isCompleted,
                  onChanged: (_) => onToggle(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.isCompleted
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                              : null,
                        ),
                      ),
                      Text(
                        todo.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
