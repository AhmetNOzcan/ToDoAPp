import 'package:equatable/equatable.dart';
import 'package:todo_feature_domain/todo_feature_domain.dart';

enum TodoListStatus { initial, loading, loaded, error }

class TodoListState extends Equatable {
  final TodoListStatus status;
  final List<Todo> todos;
  final String? errorMessage;

  const TodoListState({
    this.status = TodoListStatus.initial,
    this.todos = const [],
    this.errorMessage,
  });

  TodoListState copyWith({
    TodoListStatus? status,
    List<Todo>? todos,
    String? errorMessage,
  }) {
    return TodoListState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, todos, errorMessage];
}
