import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../database/todo_database.dart';
import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel?> getTodoById(int id);
  Future<int> insertTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(int id);
  Future<void> toggleTodo(int id);
  Future<int> getCompletedTodoCount();
}

@LazySingleton(as: TodoLocalDataSource)
class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final TodoDatabase _db;

  TodoLocalDataSourceImpl({required TodoDatabase db}) : _db = db;

  @override
  Future<List<TodoModel>> getTodos() async {
    final database = await _db.database;
    final maps = await database.query('todos', orderBy: 'created_at DESC');
    return maps.map(TodoModel.fromMap).toList();
  }

  @override
  Future<TodoModel?> getTodoById(int id) async {
    final database = await _db.database;
    final maps = await database.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return TodoModel.fromMap(maps.first);
  }

  @override
  Future<int> insertTodo(TodoModel todo) async {
    final database = await _db.database;
    return database.insert('todos', todo.toMap());
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    final database = await _db.database;
    await database.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  @override
  Future<void> deleteTodo(int id) async {
    final database = await _db.database;
    await database.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> toggleTodo(int id) async {
    final database = await _db.database;
    await database.rawUpdate(
      'UPDATE todos SET is_completed = CASE WHEN is_completed = 1 THEN 0 ELSE 1 END WHERE id = ?',
      [id],
    );
  }

  @override
  Future<int> getCompletedTodoCount() async {
    final database = await _db.database;
    final result = await database.rawQuery(
      'SELECT COUNT(*) as count FROM todos WHERE is_completed = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
