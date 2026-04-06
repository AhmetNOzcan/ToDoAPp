import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_feature/src/data/datasources/todo_local_data_source.dart';
import 'package:todo_feature/src/data/models/todo_model.dart';
import 'package:todo_feature/src/data/repositories/todo_repository_impl.dart';
import 'package:todo_feature/src/domain/entities/todo.dart';

class MockTodoLocalDataSource extends Mock implements TodoLocalDataSource {}

void main() {
  late TodoRepositoryImpl repository;
  late MockTodoLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockTodoLocalDataSource();
    repository = TodoRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  final tCreatedAt = DateTime(2025, 1, 15, 10, 30);

  final tTodoModel = TodoModel(
    id: 1,
    title: 'Test Todo',
    description: 'Test Description',
    isCompleted: false,
    createdAt: tCreatedAt,
  );

  final tTodoModels = [
    tTodoModel,
    TodoModel(
      id: 2,
      title: 'Test Todo 2',
      description: 'Description 2',
      isCompleted: true,
      createdAt: tCreatedAt,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(tTodoModel);
  });

  group('getTodos', () {
    test('should return list of todos from local data source', () async {
      when(() => mockLocalDataSource.getTodos())
          .thenAnswer((_) async => tTodoModels);

      final result = await repository.getTodos();

      expect(result, tTodoModels);
      verify(() => mockLocalDataSource.getTodos()).called(1);
    });

    test('should return empty list when no todos exist', () async {
      when(() => mockLocalDataSource.getTodos())
          .thenAnswer((_) async => []);

      final result = await repository.getTodos();

      expect(result, isEmpty);
    });
  });

  group('getTodoById', () {
    test('should return a todo when it exists', () async {
      when(() => mockLocalDataSource.getTodoById(1))
          .thenAnswer((_) async => tTodoModel);

      final result = await repository.getTodoById(1);

      expect(result, tTodoModel);
      verify(() => mockLocalDataSource.getTodoById(1)).called(1);
    });

    test('should return null when todo does not exist', () async {
      when(() => mockLocalDataSource.getTodoById(999))
          .thenAnswer((_) async => null);

      final result = await repository.getTodoById(999);

      expect(result, isNull);
    });
  });

  group('addTodo', () {
    test('should convert entity to model and insert via local data source', () async {
      final todo = Todo(
        title: 'New Todo',
        description: 'New Description',
        createdAt: tCreatedAt,
      );

      when(() => mockLocalDataSource.insertTodo(any()))
          .thenAnswer((_) async => 1);

      final result = await repository.addTodo(todo);

      expect(result, 1);
      final captured = verify(() => mockLocalDataSource.insertTodo(captureAny()))
          .captured
          .single as TodoModel;
      expect(captured.title, todo.title);
      expect(captured.description, todo.description);
      expect(captured.isCompleted, todo.isCompleted);
      expect(captured.createdAt, todo.createdAt);
    });
  });

  group('updateTodo', () {
    test('should convert entity to model and update via local data source', () async {
      final todo = Todo(
        id: 1,
        title: 'Updated Todo',
        description: 'Updated Description',
        isCompleted: true,
        createdAt: tCreatedAt,
      );

      when(() => mockLocalDataSource.updateTodo(any()))
          .thenAnswer((_) async {});

      await repository.updateTodo(todo);

      final captured = verify(() => mockLocalDataSource.updateTodo(captureAny()))
          .captured
          .single as TodoModel;
      expect(captured.id, todo.id);
      expect(captured.title, todo.title);
      expect(captured.description, todo.description);
      expect(captured.isCompleted, todo.isCompleted);
    });
  });

  group('deleteTodo', () {
    test('should delegate to local data source', () async {
      when(() => mockLocalDataSource.deleteTodo(any()))
          .thenAnswer((_) async {});

      await repository.deleteTodo(1);

      verify(() => mockLocalDataSource.deleteTodo(1)).called(1);
    });
  });

  group('toggleTodo', () {
    test('should delegate to local data source', () async {
      when(() => mockLocalDataSource.toggleTodo(any()))
          .thenAnswer((_) async {});

      await repository.toggleTodo(1);

      verify(() => mockLocalDataSource.toggleTodo(1)).called(1);
    });
  });

  group('getCompletedTodoCount', () {
    test('should return count from local data source', () async {
      when(() => mockLocalDataSource.getCompletedTodoCount())
          .thenAnswer((_) async => 3);

      final result = await repository.getCompletedTodoCount();

      expect(result, 3);
      verify(() => mockLocalDataSource.getCompletedTodoCount()).called(1);
    });
  });
}
