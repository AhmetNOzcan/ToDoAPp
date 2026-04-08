//@GeneratedMicroModule;TodoFeaturePresentationPackageModule;package:todo_feature_presentation/src/di/todo_feature_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:todo_feature_domain/todo_feature_domain.dart' as _i41;
import 'package:todo_feature_presentation/src/bloc/todo_detail_bloc.dart'
    as _i1039;
import 'package:todo_feature_presentation/src/bloc/todo_list_bloc.dart'
    as _i428;

class TodoFeaturePresentationPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i1039.TodoDetailBloc>(() => _i1039.TodoDetailBloc(
          getTodoById: gh<_i41.GetTodoById>(),
          updateTodo: gh<_i41.UpdateTodo>(),
          toggleTodo: gh<_i41.ToggleTodo>(),
          deleteTodo: gh<_i41.DeleteTodo>(),
        ));
    gh.factory<_i428.TodoListBloc>(() => _i428.TodoListBloc(
          getTodos: gh<_i41.GetTodos>(),
          addTodo: gh<_i41.AddTodo>(),
          toggleTodo: gh<_i41.ToggleTodo>(),
          deleteTodo: gh<_i41.DeleteTodo>(),
        ));
  }
}
