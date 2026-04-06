import 'package:equatable/equatable.dart';

sealed class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoListEvent {
  const LoadTodos();
}

class AddTodoRequested extends TodoListEvent {
  final String title;
  final String description;

  const AddTodoRequested({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

class ToggleTodoRequested extends TodoListEvent {
  final int id;

  const ToggleTodoRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteTodoRequested extends TodoListEvent {
  final int id;

  const DeleteTodoRequested(this.id);

  @override
  List<Object?> get props => [id];
}
