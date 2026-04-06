import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_feature_data/src/database/todo_database.dart';
import 'package:todo_feature_data/src/datasources/todo_local_data_source.dart';
import 'package:todo_feature_data/src/models/todo_model.dart';

class MockDatabase extends Mock implements Database {}

class MockTodoDatabase extends Mock implements TodoDatabase {}

void main() {
  late TodoLocalDataSourceImpl dataSource;
  late MockDatabase mockDatabase;
  late MockTodoDatabase mockTodoDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    mockTodoDatabase = MockTodoDatabase();
    when(() => mockTodoDatabase.database)
        .thenAnswer((_) async => mockDatabase);
    dataSource = TodoLocalDataSourceImpl(db: mockTodoDatabase);
  });

  final tCreatedAt = DateTime(2025, 1, 15, 10, 30);

  final tTodoMap = {
    'id': 1,
    'title': 'Test Todo',
    'description': 'Test Description',
    'is_completed': 0,
    'created_at': tCreatedAt.toIso8601String(),
  };

  final tTodoModel = TodoModel(
    id: 1,
    title: 'Test Todo',
    description: 'Test Description',
    isCompleted: false,
    createdAt: tCreatedAt,
  );

  setUpAll(() {
    registerFallbackValue(tTodoModel.toMap());
  });

  group('getTodos', () {
    test('should return a list of TodoModel from the database', () async {
      final tTodoMap2 = {
        'id': 2,
        'title': 'Test Todo 2',
        'description': 'Description 2',
        'is_completed': 1,
        'created_at': tCreatedAt.toIso8601String(),
      };

      when(() => mockDatabase.query('todos', orderBy: 'created_at DESC'))
          .thenAnswer((_) async => [tTodoMap, tTodoMap2]);

      final result = await dataSource.getTodos();

      expect(result, isA<List<TodoModel>>());
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].title, 'Test Todo');
      expect(result[1].id, 2);
      expect(result[1].isCompleted, true);
      verify(() => mockDatabase.query('todos', orderBy: 'created_at DESC')).called(1);
    });

    test('should return empty list when database has no todos', () async {
      when(() => mockDatabase.query('todos', orderBy: 'created_at DESC'))
          .thenAnswer((_) async => []);

      final result = await dataSource.getTodos();

      expect(result, isEmpty);
      verify(() => mockDatabase.query('todos', orderBy: 'created_at DESC')).called(1);
    });
  });

  group('getTodoById', () {
    test('should return a TodoModel when a todo with the given id exists', () async {
      when(() => mockDatabase.query(
            'todos',
            where: 'id = ?',
            whereArgs: [1],
          )).thenAnswer((_) async => [tTodoMap]);

      final result = await dataSource.getTodoById(1);

      expect(result, isA<TodoModel>());
      expect(result!.id, 1);
      expect(result.title, 'Test Todo');
      verify(() => mockDatabase.query(
            'todos',
            where: 'id = ?',
            whereArgs: [1],
          )).called(1);
    });

    test('should return null when no todo with the given id exists', () async {
      when(() => mockDatabase.query(
            'todos',
            where: 'id = ?',
            whereArgs: [999],
          )).thenAnswer((_) async => []);

      final result = await dataSource.getTodoById(999);

      expect(result, isNull);
    });
  });

  group('insertTodo', () {
    test('should insert a todo into the database and return the id', () async {
      when(() => mockDatabase.insert('todos', any()))
          .thenAnswer((_) async => 1);

      final result = await dataSource.insertTodo(tTodoModel);

      expect(result, 1);
      verify(() => mockDatabase.insert('todos', tTodoModel.toMap())).called(1);
    });
  });

  group('updateTodo', () {
    test('should update a todo in the database', () async {
      when(() => mockDatabase.update(
            'todos',
            any(),
            where: 'id = ?',
            whereArgs: [1],
          )).thenAnswer((_) async => 1);

      await dataSource.updateTodo(tTodoModel);

      verify(() => mockDatabase.update(
            'todos',
            tTodoModel.toMap(),
            where: 'id = ?',
            whereArgs: [1],
          )).called(1);
    });
  });

  group('deleteTodo', () {
    test('should delete a todo from the database', () async {
      when(() => mockDatabase.delete(
            'todos',
            where: 'id = ?',
            whereArgs: [1],
          )).thenAnswer((_) async => 1);

      await dataSource.deleteTodo(1);

      verify(() => mockDatabase.delete(
            'todos',
            where: 'id = ?',
            whereArgs: [1],
          )).called(1);
    });
  });

  group('toggleTodo', () {
    test('should execute rawUpdate to toggle the is_completed field', () async {
      when(() => mockDatabase.rawUpdate(
            any(),
            any(),
          )).thenAnswer((_) async => 1);

      await dataSource.toggleTodo(1);

      verify(() => mockDatabase.rawUpdate(
            'UPDATE todos SET is_completed = CASE WHEN is_completed = 1 THEN 0 ELSE 1 END WHERE id = ?',
            [1],
          )).called(1);
    });
  });

  group('getCompletedTodoCount', () {
    test('should return the count of completed todos', () async {
      when(() => mockDatabase.rawQuery(
            'SELECT COUNT(*) as count FROM todos WHERE is_completed = 1',
          )).thenAnswer((_) async => [
            {'count': 5}
          ]);

      final result = await dataSource.getCompletedTodoCount();

      expect(result, 5);
      verify(() => mockDatabase.rawQuery(
            'SELECT COUNT(*) as count FROM todos WHERE is_completed = 1',
          )).called(1);
    });

    test('should return 0 when no completed todos exist', () async {
      when(() => mockDatabase.rawQuery(
            'SELECT COUNT(*) as count FROM todos WHERE is_completed = 1',
          )).thenAnswer((_) async => [
            {'count': 0}
          ]);

      final result = await dataSource.getCompletedTodoCount();

      expect(result, 0);
    });
  });
}
