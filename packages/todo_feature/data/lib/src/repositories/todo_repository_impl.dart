import 'package:injectable/injectable.dart';
import 'package:todo_feature_domain/todo_feature_domain.dart';

import '../datasources/todo_local_data_source.dart';
import '../models/todo_model.dart';

@lazySingleton
class TodoRepositoryImpl implements TodoRepository, TodoStatsProvider {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Todo>> getTodos() => localDataSource.getTodos();

  @override
  Future<Todo?> getTodoById(int id) => localDataSource.getTodoById(id);

  @override
  Future<int> addTodo(Todo todo) {
    final model = TodoModel.fromEntity(todo);
    return localDataSource.insertTodo(model);
  }

  @override
  Future<void> updateTodo(Todo todo) {
    final model = TodoModel.fromEntity(todo);
    return localDataSource.updateTodo(model);
  }

  @override
  Future<void> deleteTodo(int id) => localDataSource.deleteTodo(id);

  @override
  Future<void> toggleTodo(int id) => localDataSource.toggleTodo(id);

  @override
  Future<int> getCompletedTodoCount() =>
      localDataSource.getCompletedTodoCount();
}
