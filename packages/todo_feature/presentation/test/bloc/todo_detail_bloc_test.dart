import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_feature_domain/src/entities/todo.dart';
import 'package:todo_feature_domain/src/usecases/delete_todo.dart';
import 'package:todo_feature_domain/src/usecases/get_todo_by_id.dart';
import 'package:todo_feature_domain/src/usecases/toggle_todo.dart';
import 'package:todo_feature_domain/src/usecases/update_todo.dart';
import 'package:todo_feature_presentation/src/bloc/todo_detail_bloc.dart';
import 'package:todo_feature_presentation/src/bloc/todo_detail_event.dart';
import 'package:todo_feature_presentation/src/bloc/todo_detail_state.dart';

class MockGetTodoById extends Mock implements GetTodoById {}

class MockUpdateTodo extends Mock implements UpdateTodo {}

class MockToggleTodo extends Mock implements ToggleTodo {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

void main() {
  late MockGetTodoById mockGetTodoById;
  late MockUpdateTodo mockUpdateTodo;
  late MockToggleTodo mockToggleTodo;
  late MockDeleteTodo mockDeleteTodo;

  final tTodo = Todo(
    id: 1,
    title: 'Test Todo',
    description: 'Test Description',
    isCompleted: false,
    createdAt: DateTime(2025, 1, 1),
  );

  setUp(() {
    mockGetTodoById = MockGetTodoById();
    mockUpdateTodo = MockUpdateTodo();
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

  TodoDetailBloc buildBloc() {
    return TodoDetailBloc(
      getTodoById: mockGetTodoById,
      updateTodo: mockUpdateTodo,
      toggleTodo: mockToggleTodo,
      deleteTodo: mockDeleteTodo,
    );
  }

  group('TodoDetailBloc', () {
    test('initial state is TodoDetailState with initial status', () {
      final bloc = buildBloc();
      expect(bloc.state, const TodoDetailState());
      expect(bloc.state.status, TodoDetailStatus.initial);
      expect(bloc.state.todo, isNull);
      expect(bloc.state.errorMessage, isNull);
    });

    group('LoadTodoDetail', () {
      blocTest<TodoDetailBloc, TodoDetailState>(
        'emits [loading, loaded] when LoadTodoDetail succeeds',
        setUp: () {
          when(() => mockGetTodoById(1)).thenAnswer((_) async => tTodo);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const LoadTodoDetail(1)),
        expect: () => [
          const TodoDetailState(status: TodoDetailStatus.loading),
          TodoDetailState(status: TodoDetailStatus.loaded, todo: tTodo),
        ],
        verify: (_) {
          verify(() => mockGetTodoById(1)).called(1);
        },
      );

      blocTest<TodoDetailBloc, TodoDetailState>(
        'emits [loading, error] when todo is not found (null)',
        setUp: () {
          when(() => mockGetTodoById(999)).thenAnswer((_) async => null);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const LoadTodoDetail(999)),
        expect: () => [
          const TodoDetailState(status: TodoDetailStatus.loading),
          const TodoDetailState(
            status: TodoDetailStatus.error,
            errorMessage: 'Todo not found',
          ),
        ],
      );

      blocTest<TodoDetailBloc, TodoDetailState>(
        'emits [loading, error] when LoadTodoDetail throws',
        setUp: () {
          when(() => mockGetTodoById(any())).thenThrow(Exception('DB error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const LoadTodoDetail(1)),
        expect: () => [
          const TodoDetailState(status: TodoDetailStatus.loading),
          isA<TodoDetailState>()
              .having((s) => s.status, 'status', TodoDetailStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', contains('DB error')),
        ],
      );
    });

    group('UpdateTodoRequested', () {
      blocTest<TodoDetailBloc, TodoDetailState>(
        'emits [saved] with updated todo when update succeeds',
        setUp: () {
          when(() => mockUpdateTodo(any())).thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => TodoDetailState(status: TodoDetailStatus.loaded, todo: tTodo),
        act: (bloc) => bloc.add(
          const UpdateTodoRequested(
            title: 'Updated Title',
            description: 'Updated Description',
          ),
        ),
        expect: () => [
          TodoDetailState(
            status: TodoDetailStatus.saved,
            todo: tTodo.copyWith(
              title: 'Updated Title',
              description: 'Updated Description',
            ),
          ),
        ],
        verify: (_) {
          verify(() => mockUpdateTodo(any())).called(1);
        },
      );

      blocTest<TodoDetailBloc, TodoDetailState>(
        'does nothing when current todo is null',
        build: buildBloc,
        seed: () => const TodoDetailState(status: TodoDetailStatus.initial),
        act: (bloc) => bloc.add(
          const UpdateTodoRequested(
            title: 'Updated Title',
            description: 'Updated Description',
          ),
        ),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockUpdateTodo(any()));
        },
      );

      blocTest<TodoDetailBloc, TodoDetailState>(
        'emits error when update fails',
        setUp: () {
          when(() => mockUpdateTodo(any())).thenThrow(Exception('Update error'));
        },
        build: buildBloc,
        seed: () => TodoDetailState(status: TodoDetailStatus.loaded, todo: tTodo),
        act: (bloc) => bloc.add(
          const UpdateTodoRequested(
            title: 'Updated Title',
            description: 'Updated Description',
          ),
        ),
        expect: () => [
          isA<TodoDetailState>()
              .having((s) => s.status, 'status', TodoDetailStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', contains('Update error')),
        ],
      );
    });

    group('ToggleTodoDetailRequested', () {
      blocTest<TodoDetailBloc, TodoDetailState>(
        'emits [loaded] with toggled isCompleted when toggle succeeds',
        setUp: () {
          when(() => mockToggleTodo(any())).thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => TodoDetailState(status: TodoDetailStatus.loaded, todo: tTodo),
        act: (bloc) => bloc.add(const ToggleTodoDetailRequested()),
        expect: () => [
          TodoDetailState(
            status: TodoDetailStatus.loaded,
            todo: tTodo.copyWith(isCompleted: true),
          ),
        ],
        verify: (_) {
          verify(() => mockToggleTodo(1)).called(1);
        },
      );

      blocTest<TodoDetailBloc, TodoDetailState>(
        'toggles back from completed to not completed',
        setUp: () {
          when(() => mockToggleTodo(any())).thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => TodoDetailState(
          status: TodoDetailStatus.loaded,
          todo: tTodo.copyWith(isCompleted: true),
        ),
        act: (bloc) => bloc.add(const ToggleTodoDetailRequested()),
        expect: () => [
          TodoDetailState(
            status: TodoDetailStatus.loaded,
            todo: tTodo.copyWith(isCompleted: false),
          ),
        ],
      );

      blocTest<TodoDetailBloc, TodoDetailState>(
        'does nothing when current todo is null',
        build: buildBloc,
        seed: () => const TodoDetailState(status: TodoDetailStatus.initial),
        act: (bloc) => bloc.add(const ToggleTodoDetailRequested()),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockToggleTodo(any()));
        },
      );

      blocTest<TodoDetailBloc, TodoDetailState>(
        'does nothing when todo id is null',
        build: buildBloc,
        seed: () => TodoDetailState(
          status: TodoDetailStatus.loaded,
          todo: Todo(
            title: 'No ID',
            description: 'Desc',
            createdAt: DateTime(2025),
          ),
        ),
        act: (bloc) => bloc.add(const ToggleTodoDetailRequested()),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockToggleTodo(any()));
        },
      );

      blocTest<TodoDetailBloc, TodoDetailState>(
        'emits error when toggle fails',
        setUp: () {
          when(() => mockToggleTodo(any())).thenThrow(Exception('Toggle error'));
        },
        build: buildBloc,
        seed: () => TodoDetailState(status: TodoDetailStatus.loaded, todo: tTodo),
        act: (bloc) => bloc.add(const ToggleTodoDetailRequested()),
        expect: () => [
          isA<TodoDetailState>()
              .having((s) => s.status, 'status', TodoDetailStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', contains('Toggle error')),
        ],
      );
    });

    group('DeleteTodoDetailRequested', () {
      blocTest<TodoDetailBloc, TodoDetailState>(
        'emits [deleted] when delete succeeds',
        setUp: () {
          when(() => mockDeleteTodo(any())).thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => TodoDetailState(status: TodoDetailStatus.loaded, todo: tTodo),
        act: (bloc) => bloc.add(const DeleteTodoDetailRequested()),
        expect: () => [
          isA<TodoDetailState>()
              .having((s) => s.status, 'status', TodoDetailStatus.deleted),
        ],
        verify: (_) {
          verify(() => mockDeleteTodo(1)).called(1);
        },
      );

      blocTest<TodoDetailBloc, TodoDetailState>(
        'does nothing when current todo is null',
        build: buildBloc,
        seed: () => const TodoDetailState(status: TodoDetailStatus.initial),
        act: (bloc) => bloc.add(const DeleteTodoDetailRequested()),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockDeleteTodo(any()));
        },
      );

      blocTest<TodoDetailBloc, TodoDetailState>(
        'does nothing when todo id is null',
        build: buildBloc,
        seed: () => TodoDetailState(
          status: TodoDetailStatus.loaded,
          todo: Todo(
            title: 'No ID',
            description: 'Desc',
            createdAt: DateTime(2025),
          ),
        ),
        act: (bloc) => bloc.add(const DeleteTodoDetailRequested()),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockDeleteTodo(any()));
        },
      );

      blocTest<TodoDetailBloc, TodoDetailState>(
        'emits error when delete fails',
        setUp: () {
          when(() => mockDeleteTodo(any())).thenThrow(Exception('Delete error'));
        },
        build: buildBloc,
        seed: () => TodoDetailState(status: TodoDetailStatus.loaded, todo: tTodo),
        act: (bloc) => bloc.add(const DeleteTodoDetailRequested()),
        expect: () => [
          isA<TodoDetailState>()
              .having((s) => s.status, 'status', TodoDetailStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', contains('Delete error')),
        ],
      );
    });
  });
}
