import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_feature/src/domain/entities/todo.dart';
import 'package:todo_feature/src/domain/repositories/todo_repository.dart';
import 'package:todo_feature/src/domain/usecases/get_todos.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late GetTodos useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = GetTodos(mockRepository);
  });

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

  test('should get list of todos from the repository', () async {
    // arrange
    when(() => mockRepository.getTodos()).thenAnswer((_) async => tTodos);

    // act
    final result = await useCase();

    // assert
    expect(result, tTodos);
    verify(() => mockRepository.getTodos()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list when repository has no todos', () async {
    // arrange
    when(() => mockRepository.getTodos()).thenAnswer((_) async => []);

    // act
    final result = await useCase();

    // assert
    expect(result, isEmpty);
    verify(() => mockRepository.getTodos()).called(1);
  });

  test('should propagate exception when repository throws', () async {
    // arrange
    when(() => mockRepository.getTodos()).thenThrow(Exception('DB error'));

    // act & assert
    expect(() => useCase(), throwsA(isA<Exception>()));
    verify(() => mockRepository.getTodos()).called(1);
  });
}
