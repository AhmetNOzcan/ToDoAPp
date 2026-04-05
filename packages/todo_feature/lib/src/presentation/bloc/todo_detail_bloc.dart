import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todo_by_id.dart';
import '../../domain/usecases/toggle_todo.dart';
import '../../domain/usecases/update_todo.dart';
import 'todo_detail_event.dart';
import 'todo_detail_state.dart';

class TodoDetailBloc extends Bloc<TodoDetailEvent, TodoDetailState> {
  final GetTodoById getTodoById;
  final UpdateTodo updateTodo;
  final ToggleTodo toggleTodo;
  final DeleteTodo deleteTodo;

  TodoDetailBloc({
    required this.getTodoById,
    required this.updateTodo,
    required this.toggleTodo,
    required this.deleteTodo,
  }) : super(const TodoDetailState()) {
    on<LoadTodoDetail>(_onLoadTodoDetail);
    on<UpdateTodoRequested>(_onUpdateTodo);
    on<ToggleTodoDetailRequested>(_onToggleTodo);
    on<DeleteTodoDetailRequested>(_onDeleteTodo);
  }

  Future<void> _onLoadTodoDetail(
    LoadTodoDetail event,
    Emitter<TodoDetailState> emit,
  ) async {
    emit(state.copyWith(status: TodoDetailStatus.loading));
    try {
      final todo = await getTodoById(event.id);
      if (todo != null) {
        emit(state.copyWith(status: TodoDetailStatus.loaded, todo: todo));
      } else {
        emit(state.copyWith(
          status: TodoDetailStatus.error,
          errorMessage: 'Todo not found',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TodoDetailStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateTodo(
    UpdateTodoRequested event,
    Emitter<TodoDetailState> emit,
  ) async {
    final current = state.todo;
    if (current == null) return;

    try {
      final updated = current.copyWith(
        title: event.title,
        description: event.description,
      );
      await updateTodo(updated);
      emit(state.copyWith(status: TodoDetailStatus.saved, todo: updated));
    } catch (e) {
      emit(state.copyWith(
        status: TodoDetailStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleTodo(
    ToggleTodoDetailRequested event,
    Emitter<TodoDetailState> emit,
  ) async {
    final current = state.todo;
    if (current?.id == null) return;

    try {
      await toggleTodo(current!.id!);
      final updated = current.copyWith(isCompleted: !current.isCompleted);
      emit(state.copyWith(status: TodoDetailStatus.loaded, todo: updated));
    } catch (e) {
      emit(state.copyWith(
        status: TodoDetailStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteTodo(
    DeleteTodoDetailRequested event,
    Emitter<TodoDetailState> emit,
  ) async {
    final current = state.todo;
    if (current?.id == null) return;

    try {
      await deleteTodo(current!.id!);
      emit(state.copyWith(status: TodoDetailStatus.deleted));
    } catch (e) {
      emit(state.copyWith(
        status: TodoDetailStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
