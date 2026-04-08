import 'package:injectable/injectable.dart';

import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

@injectable
class GetTodoById {
  final TodoRepository repository;

  GetTodoById(this.repository);

  Future<Todo?> call(int id) => repository.getTodoById(id);
}
