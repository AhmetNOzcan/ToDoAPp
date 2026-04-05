import '../repositories/todo_repository.dart';

class ToggleTodo {
  final TodoRepository repository;

  ToggleTodo(this.repository);

  Future<void> call(int id) => repository.toggleTodo(id);
}
