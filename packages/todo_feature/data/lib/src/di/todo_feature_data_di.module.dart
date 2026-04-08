//@GeneratedMicroModule;TodoFeatureDataPackageModule;package:todo_feature_data/src/di/todo_feature_data_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:todo_feature_data/src/database/todo_database.dart' as _i843;
import 'package:todo_feature_data/src/datasources/todo_local_data_source.dart'
    as _i158;
import 'package:todo_feature_data/src/di/todo_repository_bindings.dart'
    as _i105;
import 'package:todo_feature_data/src/repositories/todo_repository_impl.dart'
    as _i192;
import 'package:todo_feature_domain/todo_feature_domain.dart' as _i41;

class TodoFeatureDataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final todoRepositoryBindings = _$TodoRepositoryBindings();
    gh.lazySingleton<_i843.TodoDatabase>(() => _i843.TodoDatabase());
    gh.lazySingleton<_i158.TodoLocalDataSource>(
        () => _i158.TodoLocalDataSourceImpl(db: gh<_i843.TodoDatabase>()));
    gh.lazySingleton<_i192.TodoRepositoryImpl>(() => _i192.TodoRepositoryImpl(
        localDataSource: gh<_i158.TodoLocalDataSource>()));
    gh.lazySingleton<_i41.TodoRepository>(() =>
        todoRepositoryBindings.todoRepository(gh<_i192.TodoRepositoryImpl>()));
    gh.lazySingleton<_i41.TodoStatsProvider>(() => todoRepositoryBindings
        .todoStatsProvider(gh<_i192.TodoRepositoryImpl>()));
  }
}

class _$TodoRepositoryBindings extends _i105.TodoRepositoryBindings {}
