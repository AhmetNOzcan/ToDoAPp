import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_feature_domain/todo_feature_domain.dart';

import 'todo_detail_event.dart';
import 'todo_detail_state.dart';

import 'package:flutter/material.dart';

class TodoDetailBloc extends Bloc<TodoDetailEvent, TodoDetailState> {
  final GetTodoById _getTodoById;
  final UpdateTodo _updateTodo;
  final ToggleTodo _toggleTodo;
  final DeleteTodo _deleteTodo;

  TodoDetailBloc({
    required GetTodoById getTodoById,
    required UpdateTodo updateTodo,
    required ToggleTodo toggleTodo,
    required DeleteTodo deleteTodo,
  }) : _getTodoById = getTodoById,
       _updateTodo = updateTodo,
       _toggleTodo = toggleTodo,
       _deleteTodo = deleteTodo,
       super(const TodoDetailState()) {
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
      final todo = await _getTodoById(event.id);
      if (todo != null) {
        emit(state.copyWith(status: TodoDetailStatus.loaded, todo: todo));
      } else {
        emit(
          state.copyWith(
            status: TodoDetailStatus.error,
            errorMessage: 'Todo not found',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoDetailStatus.error,
          errorMessage: e.toString(),
        ),
      );
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
      await _updateTodo(updated);
      emit(state.copyWith(status: TodoDetailStatus.saved, todo: updated));
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoDetailStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onToggleTodo(
    ToggleTodoDetailRequested event,
    Emitter<TodoDetailState> emit,
  ) async {
    final current = state.todo;
    if (current?.id == null) return;

    try {
      await _toggleTodo(current!.id!);
      final updated = current.copyWith(isCompleted: !current.isCompleted);
      emit(state.copyWith(status: TodoDetailStatus.loaded, todo: updated));
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoDetailStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteTodo(
    DeleteTodoDetailRequested event,
    Emitter<TodoDetailState> emit,
  ) async {
    final current = state.todo;
    if (current?.id == null) return;

    try {
      await _deleteTodo(current!.id!);
      emit(state.copyWith(status: TodoDetailStatus.deleted));
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoDetailStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
