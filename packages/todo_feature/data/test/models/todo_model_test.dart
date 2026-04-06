import 'package:flutter_test/flutter_test.dart';
import 'package:todo_feature/src/data/models/todo_model.dart';
import 'package:todo_feature/src/domain/entities/todo.dart';

void main() {
  final tCreatedAt = DateTime(2025, 1, 15, 10, 30);

  group('TodoModel', () {
    group('fromMap', () {
      test('should return a valid TodoModel from a map with is_completed = 0', () {
        final map = {
          'id': 1,
          'title': 'Test Todo',
          'description': 'Test Description',
          'is_completed': 0,
          'created_at': tCreatedAt.toIso8601String(),
        };

        final result = TodoModel.fromMap(map);

        expect(result.id, 1);
        expect(result.title, 'Test Todo');
        expect(result.description, 'Test Description');
        expect(result.isCompleted, false);
        expect(result.createdAt, tCreatedAt);
      });

      test('should return a valid TodoModel from a map with is_completed = 1', () {
        final map = {
          'id': 2,
          'title': 'Completed Todo',
          'description': 'Done Description',
          'is_completed': 1,
          'created_at': tCreatedAt.toIso8601String(),
        };

        final result = TodoModel.fromMap(map);

        expect(result.id, 2);
        expect(result.title, 'Completed Todo');
        expect(result.description, 'Done Description');
        expect(result.isCompleted, true);
        expect(result.createdAt, tCreatedAt);
      });

      test('should handle null id in map', () {
        final map = {
          'id': null,
          'title': 'No ID Todo',
          'description': 'Description',
          'is_completed': 0,
          'created_at': tCreatedAt.toIso8601String(),
        };

        final result = TodoModel.fromMap(map);

        expect(result.id, isNull);
        expect(result.title, 'No ID Todo');
      });
    });

    group('toMap', () {
      test('should return a map containing all fields when id is present', () {
        final model = TodoModel(
          id: 1,
          title: 'Test Todo',
          description: 'Test Description',
          isCompleted: false,
          createdAt: tCreatedAt,
        );

        final result = model.toMap();

        expect(result, {
          'id': 1,
          'title': 'Test Todo',
          'description': 'Test Description',
          'is_completed': 0,
          'created_at': tCreatedAt.toIso8601String(),
        });
      });

      test('should not include id in map when id is null', () {
        final model = TodoModel(
          title: 'No ID Todo',
          description: 'Description',
          isCompleted: false,
          createdAt: tCreatedAt,
        );

        final result = model.toMap();

        expect(result.containsKey('id'), false);
        expect(result['title'], 'No ID Todo');
        expect(result['description'], 'Description');
        expect(result['is_completed'], 0);
        expect(result['created_at'], tCreatedAt.toIso8601String());
      });

      test('should map isCompleted true to 1', () {
        final model = TodoModel(
          id: 1,
          title: 'Completed',
          description: 'Done',
          isCompleted: true,
          createdAt: tCreatedAt,
        );

        final result = model.toMap();

        expect(result['is_completed'], 1);
      });

      test('should map isCompleted false to 0', () {
        final model = TodoModel(
          id: 1,
          title: 'Not Completed',
          description: 'Not Done',
          isCompleted: false,
          createdAt: tCreatedAt,
        );

        final result = model.toMap();

        expect(result['is_completed'], 0);
      });
    });

    group('fromEntity', () {
      test('should create a TodoModel from a Todo entity', () {
        final todo = Todo(
          id: 1,
          title: 'Entity Title',
          description: 'Entity Description',
          isCompleted: true,
          createdAt: tCreatedAt,
        );

        final result = TodoModel.fromEntity(todo);

        expect(result, isA<TodoModel>());
        expect(result.id, todo.id);
        expect(result.title, todo.title);
        expect(result.description, todo.description);
        expect(result.isCompleted, todo.isCompleted);
        expect(result.createdAt, todo.createdAt);
      });

      test('should create a TodoModel from a Todo entity with null id', () {
        final todo = Todo(
          title: 'No ID',
          description: 'Description',
          createdAt: tCreatedAt,
        );

        final result = TodoModel.fromEntity(todo);

        expect(result.id, isNull);
        expect(result.title, 'No ID');
        expect(result.description, 'Description');
        expect(result.isCompleted, false);
      });

      test('should preserve default isCompleted value from entity', () {
        final todo = Todo(
          title: 'Default',
          description: 'Default Description',
          createdAt: tCreatedAt,
        );

        final result = TodoModel.fromEntity(todo);

        expect(result.isCompleted, false);
      });
    });

    group('round-trip', () {
      test('should produce equal model after toMap then fromMap', () {
        final original = TodoModel(
          id: 5,
          title: 'Round Trip',
          description: 'Round Trip Description',
          isCompleted: true,
          createdAt: tCreatedAt,
        );

        final map = original.toMap();
        final restored = TodoModel.fromMap(map);

        expect(restored.id, original.id);
        expect(restored.title, original.title);
        expect(restored.description, original.description);
        expect(restored.isCompleted, original.isCompleted);
        expect(restored.createdAt, original.createdAt);
      });
    });
  });
}
