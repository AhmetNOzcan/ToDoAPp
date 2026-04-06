import '../entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo?> getTodoById(int id);
  Future<int> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(int id);
  Future<void> toggleTodo(int id);
  Future<int> getCompletedTodoCount();
}
