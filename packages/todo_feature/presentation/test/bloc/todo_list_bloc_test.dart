import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_feature_domain/src/entities/todo.dart';
import 'package:todo_feature_domain/src/usecases/add_todo.dart';
import 'package:todo_feature_domain/src/usecases/delete_todo.dart';
import 'package:todo_feature_domain/src/usecases/get_todos.dart';
import 'package:todo_feature_domain/src/usecases/toggle_todo.dart';
import 'package:todo_feature_presentation/src/bloc/todo_list_bloc.dart';
import 'package:todo_feature_presentation/src/bloc/todo_list_event.dart';
import 'package:todo_feature_presentation/src/bloc/todo_list_state.dart';

class MockGetTodos extends Mock implements GetTodos {}

class MockAddTodo extends Mock implements AddTodo {}

class MockToggleTodo extends Mock implements ToggleTodo {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

void main() {
  late MockGetTodos mockGetTodos;
  late MockAddTodo mockAddTodo;
  late MockToggleTodo mockToggleTodo;
  late MockDeleteTodo mockDeleteTodo;

  final tTodos = [
    Todo(
      id: 1,
      title: 'Test Todo 1',
      description: 'Description 1',
      createdAt: DateTime(2025, 1, 1),
    ),
    Todo(
      id: 2,
      title: 'Test Todo 2',
      description: 'Description 2',
      isCompleted: true,
      createdAt: DateTime(2025, 1, 2),
    ),
  ];

  setUp(() {
    mockGetTodos = MockGetTodos();
    mockAddTodo = MockAddTodo();
    mockToggleTodo = MockToggleTodo();
    mockDeleteTodo = MockDeleteTodo();
  });

  setUpAll(() {
    registerFallbackValue(Todo(
      title: '',
      description: '',
      createdAt: DateTime(2025),
    ));
  });

  TodoListBloc buildBloc() {
    return TodoListBloc(
      getTodos: mockGetTodos,
      addTodo: mockAddTodo,
      toggleTodo: mockToggleTodo,
      deleteTodo: mockDeleteTodo,
    );
  }

  group('TodoListBloc', () {
    test('initial state is TodoListState with initial status', () {
      final bloc = buildBloc();
      expect(bloc.state, const TodoListState());
      expect(bloc.state.status, TodoListStatus.initial);
      expect(bloc.state.todos, isEmpty);
      expect(bloc.state.errorMessage, isNull);
    });

    group('LoadTodos', () {
      blocTest<TodoListBloc, TodoListState>(
        'emits [loading, loaded] when LoadTodos succeeds',
        setUp: () {
          when(() => mockGetTodos()).thenAnswer((_) async => tTodos);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const LoadTodos()),
        expect: () => [
          const TodoListState(status: TodoListStatus.loading),
          TodoListState(status: TodoListStatus.loaded, todos: tTodos),
        ],
        verify: (_) {
          verify(() => mockGetTodos()).called(1);
        },
      );

      blocTest<TodoListBloc, TodoListState>(
        'emits [loading, loaded] with empty list when no todos exist',
        setUp: () {
          when(() => mockGetTodos()).thenAnswer((_) async => []);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const LoadTodos()),
        expect: () => [
          const TodoListState(status: TodoListStatus.loading),
          const TodoListState(status: TodoListStatus.loaded, todos: []),
        ],
      );

      blocTest<TodoListBloc, TodoListState>(
        'emits [loading, error] when LoadTodos fails',
        setUp: () {
          when(() => mockGetTodos()).thenThrow(Exception('DB error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const LoadTodos()),
        expect: () => [
          const TodoListState(status: TodoListStatus.loading),
          isA<TodoListState>()
              .having((s) => s.status, 'status', TodoListStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', contains('DB error')),
        ],
      );
    });

    group('AddTodoRequested', () {
      blocTest<TodoListBloc, TodoListState>(
        'adds todo then reloads the list',
        setUp: () {
          when(() => mockAddTodo(any())).thenAnswer((_) async => 1);
          when(() => mockGetTodos()).thenAnswer((_) async => tTodos);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const AddTodoRequested(title: 'New Todo', description: 'New Desc'),
        ),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          // After add succeeds, LoadTodos is dispatched, so we see loading + loaded
          const TodoListState(status: TodoListStatus.loading),
          TodoListState(status: TodoListStatus.loaded, todos: tTodos),
        ],
        verify: (_) {
          verify(() => mockAddTodo(any())).called(1);
          verify(() => mockGetTodos()).called(1);
        },
      );

      blocTest<TodoListBloc, TodoListState>(
        'emits error when AddTodoRequested fails',
        setUp: () {
          when(() => mockAddTodo(any())).thenThrow(Exception('Insert error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const AddTodoRequested(title: 'New Todo', description: 'New Desc'),
        ),
        expect: () => [
          isA<TodoListState>()
              .having((s) => s.status, 'status', TodoListStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', contains('Insert error')),
        ],
      );
    });

    group('ToggleTodoRequested', () {
      blocTest<TodoListBloc, TodoListState>(
        'toggles todo then reloads the list',
        setUp: () {
          when(() => mockToggleTodo(any())).thenAnswer((_) async {});
          when(() => mockGetTodos()).thenAnswer((_) async => tTodos);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const ToggleTodoRequested(1)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const TodoListState(status: TodoListStatus.loading),
          TodoListState(status: TodoListStatus.loaded, todos: tTodos),
        ],
        verify: (_) {
          verify(() => mockToggleTodo(1)).called(1);
          verify(() => mockGetTodos()).called(1);
        },
      );

      blocTest<TodoListBloc, TodoListState>(
        'emits error when ToggleTodoRequested fails',
        setUp: () {
          when(() => mockToggleTodo(any())).thenThrow(Exception('Toggle error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const ToggleTodoRequested(1)),
        expect: () => [
          isA<TodoListState>()
              .having((s) => s.status, 'status', TodoListStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', contains('Toggle error')),
        ],
      );
    });

    group('DeleteTodoRequested', () {
      blocTest<TodoListBloc, TodoListState>(
        'deletes todo then reloads the list',
        setUp: () {
          when(() => mockDeleteTodo(any())).thenAnswer((_) async {});
          when(() => mockGetTodos()).thenAnswer((_) async => [tTodos[1]]);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const DeleteTodoRequested(1)),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const TodoListState(status: TodoListStatus.loading),
          TodoListState(status: TodoListStatus.loaded, todos: [tTodos[1]]),
        ],
        verify: (_) {
          verify(() => mockDeleteTodo(1)).called(1);
          verify(() => mockGetTodos()).called(1);
        },
      );

      blocTest<TodoListBloc, TodoListState>(
        'emits error when DeleteTodoRequested fails',
        setUp: () {
          when(() => mockDeleteTodo(any())).thenThrow(Exception('Delete error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const DeleteTodoRequested(1)),
        expect: () => [
          isA<TodoListState>()
              .having((s) => s.status, 'status', TodoListStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', contains('Delete error')),
        ],
      );
    });
  });
}
