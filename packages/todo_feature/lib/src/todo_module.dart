import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'data/database/todo_database.dart';
import 'data/datasources/todo_local_data_source.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'domain/repositories/todo_repository.dart';
import 'domain/usecases/add_todo.dart';
import 'domain/usecases/delete_todo.dart';
import 'domain/usecases/get_todo_by_id.dart';
import 'domain/usecases/get_todos.dart';
import 'domain/usecases/toggle_todo.dart';
import 'domain/usecases/update_todo.dart';
import 'presentation/bloc/todo_detail_bloc.dart';
import 'presentation/bloc/todo_detail_event.dart';
import 'presentation/bloc/todo_list_bloc.dart';
import 'presentation/pages/todo_detail_page.dart';
import 'presentation/pages/todo_list_page.dart';

class TodoModule extends FeatureModule {
  @override
  void registerDependencies(GetIt sl) {
    // Database (feature-owned)
    sl.registerLazySingleton<TodoDatabase>(() => TodoDatabase());

    // Data sources
    sl.registerLazySingleton<TodoLocalDataSource>(
      () => TodoLocalDataSourceImpl(db: sl()),
    );

    // Repositories
    sl.registerLazySingleton<TodoRepository>(
      () => TodoRepositoryImpl(localDataSource: sl()),
    );

    // Register as TodoStatsProvider so profile feature can use it
    sl.registerLazySingleton<TodoStatsProvider>(
      () => sl<TodoRepository>() as TodoRepositoryImpl,
    );

    // Use cases
    sl.registerFactory(() => GetTodos(sl()));
    sl.registerFactory(() => GetTodoById(sl()));
    sl.registerFactory(() => AddTodo(sl()));
    sl.registerFactory(() => UpdateTodo(sl()));
    sl.registerFactory(() => DeleteTodo(sl()));
    sl.registerFactory(() => ToggleTodo(sl()));

    // BLoCs
    sl.registerFactory(
      () => TodoListBloc(
        getTodos: sl(),
        addTodo: sl(),
        toggleTodo: sl(),
        deleteTodo: sl(),
      ),
    );
    sl.registerFactory(
      () => TodoDetailBloc(
        getTodoById: sl(),
        updateTodo: sl(),
        toggleTodo: sl(),
        deleteTodo: sl(),
      ),
    );
  }

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/todos',
          builder: (context, state) => BlocProvider(
            create: (_) => sl<TodoListBloc>(),
            child: const TodoListPage(),
          ),
        ),
        GoRoute(
          path: '/todos/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return BlocProvider(
              create: (_) => sl<TodoDetailBloc>()..add(LoadTodoDetail(id)),
              child: const TodoDetailPage(),
            );
          },
        ),
      ];
}
