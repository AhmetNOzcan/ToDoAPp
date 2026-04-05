import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_feature/src/domain/entities/todo.dart';
import 'package:todo_feature/src/domain/repositories/todo_repository.dart';
import 'package:todo_feature/src/domain/usecases/get_todo_by_id.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late GetTodoById useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = GetTodoById(mockRepository);
  });

  final tTodo = Todo(
    id: 1,
    title: 'Test Todo',
    description: 'Test Description',
    createdAt: DateTime(2025, 1, 1),
  );

  test('should get a todo by id from the repository', () async {
    // arrange
    when(() => mockRepository.getTodoById(1)).thenAnswer((_) async => tTodo);

    // act
    final result = await useCase(1);

    // assert
    expect(result, tTodo);
    verify(() => mockRepository.getTodoById(1)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return null when todo is not found', () async {
    // arrange
    when(() => mockRepository.getTodoById(999)).thenAnswer((_) async => null);

    // act
    final result = await useCase(999);

    // assert
    expect(result, isNull);
    verify(() => mockRepository.getTodoById(999)).called(1);
  });

  test('should propagate exception when repository throws', () async {
    // arrange
    when(() => mockRepository.getTodoById(any())).thenThrow(Exception('DB error'));

    // act & assert
    expect(() => useCase(1), throwsA(isA<Exception>()));
    verify(() => mockRepository.getTodoById(1)).called(1);
  });
}
