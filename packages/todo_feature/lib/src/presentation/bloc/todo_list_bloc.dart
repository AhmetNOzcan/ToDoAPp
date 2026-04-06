import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/todo.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/toggle_todo.dart';
import 'todo_list_event.dart';
import 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final GetTodos _getTodos;
  final AddTodo _addTodo;
  final ToggleTodo _toggleTodo;
  final DeleteTodo _deleteTodo;

  TodoListBloc({
    required GetTodos getTodos,
    required AddTodo addTodo,
    required ToggleTodo toggleTodo,
    required DeleteTodo deleteTodo,
  })  : _getTodos = getTodos,
        _addTodo = addTodo,
        _toggleTodo = toggleTodo,
        _deleteTodo = deleteTodo,
        super(const TodoListState()) {
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
      final todos = await _getTodos();
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
      await _addTodo(todo);
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
      await _toggleTodo(event.id);
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
      await _deleteTodo(event.id);
      add(const LoadTodos());
    } catch (e) {
      emit(state.copyWith(
        status: TodoListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
