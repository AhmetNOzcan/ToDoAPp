//@GeneratedMicroModule;TodoFeatureDomainPackageModule;package:todo_feature_domain/src/di/todo_feature_domain_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:todo_feature_domain/src/repositories/todo_repository.dart'
    as _i518;
import 'package:todo_feature_domain/src/usecases/add_todo.dart' as _i146;
import 'package:todo_feature_domain/src/usecases/delete_todo.dart' as _i1012;
import 'package:todo_feature_domain/src/usecases/get_todo_by_id.dart' as _i289;
import 'package:todo_feature_domain/src/usecases/get_todos.dart' as _i271;
import 'package:todo_feature_domain/src/usecases/toggle_todo.dart' as _i102;
import 'package:todo_feature_domain/src/usecases/update_todo.dart' as _i33;

class TodoFeatureDomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i146.AddTodo>(() => _i146.AddTodo(gh<_i518.TodoRepository>()));
    gh.factory<_i1012.DeleteTodo>(
        () => _i1012.DeleteTodo(gh<_i518.TodoRepository>()));
    gh.factory<_i289.GetTodoById>(
        () => _i289.GetTodoById(gh<_i518.TodoRepository>()));
    gh.factory<_i271.GetTodos>(
        () => _i271.GetTodos(gh<_i518.TodoRepository>()));
    gh.factory<_i102.ToggleTodo>(
        () => _i102.ToggleTodo(gh<_i518.TodoRepository>()));
    gh.factory<_i33.UpdateTodo>(
        () => _i33.UpdateTodo(gh<_i518.TodoRepository>()));
  }
}
