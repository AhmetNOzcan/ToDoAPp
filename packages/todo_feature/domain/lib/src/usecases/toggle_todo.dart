import 'package:injectable/injectable.dart';

import '../repositories/todo_repository.dart';

@injectable
class ToggleTodo {
  final TodoRepository repository;

  ToggleTodo(this.repository);

  Future<void> call(int id) => repository.toggleTodo(id);
}
