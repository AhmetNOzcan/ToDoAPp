import 'package:equatable/equatable.dart';

import '../../domain/entities/todo.dart';

enum TodoDetailStatus { initial, loading, loaded, saved, deleted, error }

class TodoDetailState extends Equatable {
  final TodoDetailStatus status;
  final Todo? todo;
  final String? errorMessage;

  const TodoDetailState({
    this.status = TodoDetailStatus.initial,
    this.todo,
    this.errorMessage,
  });

  TodoDetailState copyWith({
    TodoDetailStatus? status,
    Todo? todo,
    String? errorMessage,
  }) {
    return TodoDetailState(
      status: status ?? this.status,
      todo: todo ?? this.todo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, todo, errorMessage];
}
