import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/todo_detail_bloc.dart';
import '../bloc/todo_detail_event.dart';
import '../bloc/todo_detail_state.dart';

class TodoDetailPage extends StatefulWidget {
  const TodoDetailPage({super.key});

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoDetailBloc, TodoDetailState>(
      listener: (context, state) {
        if (state.status == TodoDetailStatus.loaded && !_isEditing) {
          _titleController.text = state.todo?.title ?? '';
          _descriptionController.text = state.todo?.description ?? '';
        }
        if (state.status == TodoDetailStatus.saved) {
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Todo updated')));
        }
        if (state.status == TodoDetailStatus.deleted) {
          context.pop(true);
        }
        if (state.status == TodoDetailStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
          );
        }
      },
      builder: (context, state) {
        final todo = state.todo;
        final isLoading = state.status == TodoDetailStatus.loading;

        return Scaffold(
          appBar: AppBar(
            title: Text(_isEditing ? 'Edit Todo' : 'Todo Detail'),
            actions: [
              if (todo != null && !_isEditing)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => setState(() => _isEditing = true),
                ),
              if (todo != null && !_isEditing)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context),
                ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : todo == null
              ? const Center(child: Text('Todo not found'))
              : _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, TodoDetailState state) {
    final todo = state.todo!;
    final theme = Theme.of(context);

    if (_isEditing) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _titleController.text = todo.title;
                        _descriptionController.text = todo.description;
                        setState(() => _isEditing = false);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<TodoDetailBloc>().add(
                            UpdateTodoRequested(
                              title: _titleController.text.trim(),
                              description: _descriptionController.text.trim(),
                            ),
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          todo.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: todo.isCompleted
                                ? theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) => context.read<TodoDetailBloc>().add(
                          const ToggleTodoDetailRequested(),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    todo.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: todo.isCompleted
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Created ${_formatDate(todo.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: todo.isCompleted
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          todo.isCompleted ? 'Completed' : 'Pending',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: todo.isCompleted
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<TodoDetailBloc>().add(
                const DeleteTodoDetailRequested(),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
