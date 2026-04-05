import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_feature/src/domain/repositories/todo_repository.dart';
import 'package:todo_feature/src/domain/usecases/delete_todo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late DeleteTodo useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = DeleteTodo(mockRepository);
  });

  test('should delete a todo via the repository', () async {
    // arrange
    when(() => mockRepository.deleteTodo(any())).thenAnswer((_) async {});

    // act
    await useCase(1);

    // assert
    verify(() => mockRepository.deleteTodo(1)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should propagate exception when repository throws', () async {
    // arrange
    when(() => mockRepository.deleteTodo(any())).thenThrow(Exception('Delete error'));

    // act & assert
    expect(() => useCase(1), throwsA(isA<Exception>()));
    verify(() => mockRepository.deleteTodo(1)).called(1);
  });
}
