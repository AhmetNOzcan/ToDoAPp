import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/todo.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/toggle_todo.dart';
import 'todo_list_event.dart';
import 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final ToggleTodo toggleTodo;
  final DeleteTodo deleteTodo;

  TodoListBloc({
    required this.getTodos,
    required this.addTodo,
    required this.toggleTodo,
    required this.deleteTodo,
  }) : super(const TodoListState()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoRequested>(_onAddTodo);
    on<ToggleTodoRequested>(_onToggleTodo);
    on<DeleteTodoRequested>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(
    LoadTodos event,
    Emitter<TodoListState> emit,
  ) async {
    emit(state.copyWith(status: TodoListStatus.loading));
    try {
      final todos = await getTodos();
      emit(state.copyWith(status: TodoListStatus.loaded, todos: todos));
    } catch (e) {
      emit(state.copyWith(
        status: TodoListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddTodo(
    AddTodoRequested event,
    Emitter<TodoListState> emit,
  ) async {
    try {
      final todo = Todo(
        title: event.title,
        description: event.description,
        createdAt: DateTime.now(),
      );
      await addTodo(todo);
      add(const LoadTodos());
    } catch (e) {
      emit(state.copyWith(
        status: TodoListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleTodo(
    ToggleTodoRequested event,
    Emitter<TodoListState> emit,
  ) async {
    try {
      await toggleTodo(event.id);
      add(const LoadTodos());
    } catch (e) {
      emit(state.copyWith(
        status: TodoListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteTodo(
    DeleteTodoRequested event,
    Emitter<TodoListState> emit,
  ) async {
    try {
      await deleteTodo(event.id);
      add(const LoadTodos());
    } catch (e) {
      emit(state.copyWith(
        status: TodoListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
