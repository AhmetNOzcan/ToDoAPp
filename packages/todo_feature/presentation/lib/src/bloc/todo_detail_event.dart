import 'package:equatable/equatable.dart';

sealed class TodoDetailEvent extends Equatable {
  const TodoDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodoDetail extends TodoDetailEvent {
  final int id;

  const LoadTodoDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateTodoRequested extends TodoDetailEvent {
  final String title;
  final String description;

  const UpdateTodoRequested({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

class ToggleTodoDetailRequested extends TodoDetailEvent {
  const ToggleTodoDetailRequested();
}

class DeleteTodoDetailRequested extends TodoDetailEvent {
  const DeleteTodoDetailRequested();
}
