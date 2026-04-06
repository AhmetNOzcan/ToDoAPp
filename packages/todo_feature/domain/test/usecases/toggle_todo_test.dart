import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_feature_domain/src/repositories/todo_repository.dart';
import 'package:todo_feature_domain/src/usecases/toggle_todo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late ToggleTodo useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = ToggleTodo(mockRepository);
  });

  test('should toggle a todo via the repository', () async {
    // arrange
    when(() => mockRepository.toggleTodo(any())).thenAnswer((_) async {});

    // act
    await useCase(1);

    // assert
    verify(() => mockRepository.toggleTodo(1)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should propagate exception when repository throws', () async {
    // arrange
    when(() => mockRepository.toggleTodo(any())).thenThrow(Exception('Toggle error'));

    // act & assert
    expect(() => useCase(1), throwsA(isA<Exception>()));
    verify(() => mockRepository.toggleTodo(1)).called(1);
  });
}
