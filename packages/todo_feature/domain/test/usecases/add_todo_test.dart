import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_feature_domain/src/entities/todo.dart';
import 'package:todo_feature_domain/src/repositories/todo_repository.dart';
import 'package:todo_feature_domain/src/usecases/add_todo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late AddTodo useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = AddTodo(mockRepository);
  });

  final tTodo = Todo(
    title: 'New Todo',
    description: 'New Description',
    createdAt: DateTime(2025, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(tTodo);
  });

  test('should add a todo via the repository and return the inserted id', () async {
    // arrange
    when(() => mockRepository.addTodo(any())).thenAnswer((_) async => 1);

    // act
    final result = await useCase(tTodo);

    // assert
    expect(result, 1);
    verify(() => mockRepository.addTodo(tTodo)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should propagate exception when repository throws', () async {
    // arrange
    when(() => mockRepository.addTodo(any())).thenThrow(Exception('Insert error'));

    // act & assert
    expect(() => useCase(tTodo), throwsA(isA<Exception>()));
    verify(() => mockRepository.addTodo(tTodo)).called(1);
  });
}
