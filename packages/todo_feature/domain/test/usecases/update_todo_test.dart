import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_feature_domain/src/entities/todo.dart';
import 'package:todo_feature_domain/src/repositories/todo_repository.dart';
import 'package:todo_feature_domain/src/usecases/update_todo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late UpdateTodo useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = UpdateTodo(mockRepository);
  });

  final tTodo = Todo(
    id: 1,
    title: 'Updated Todo',
    description: 'Updated Description',
    createdAt: DateTime(2025, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(tTodo);
  });

  test('should update a todo via the repository', () async {
    // arrange
    when(() => mockRepository.updateTodo(any())).thenAnswer((_) async {});

    // act
    await useCase(tTodo);

    // assert
    verify(() => mockRepository.updateTodo(tTodo)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should propagate exception when repository throws', () async {
    // arrange
    when(() => mockRepository.updateTodo(any())).thenThrow(Exception('Update error'));

    // act & assert
    expect(() => useCase(tTodo), throwsA(isA<Exception>()));
    verify(() => mockRepository.updateTodo(tTodo)).called(1);
  });
}
