import 'package:injectable/injectable.dart';

import '../repositories/todo_repository.dart';

@injectable
class DeleteTodo {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<void> call(int id) => repository.deleteTodo(id);
}
