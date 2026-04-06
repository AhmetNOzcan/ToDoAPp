import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_feature_data/todo_feature_data.dart';
import 'package:todo_feature_domain/todo_feature_domain.dart';
import 'package:todo_feature_navigation/todo_feature_navigation.dart';

import 'bloc/todo_detail_bloc.dart';
import 'bloc/todo_detail_event.dart';
import 'bloc/todo_list_bloc.dart';
import 'pages/todo_detail_page.dart';
import 'pages/todo_list_page.dart';

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
          path: TodoRoutes.pathList,
          name: TodoRoutes.nameList,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<TodoListBloc>(),
            child: const TodoListPage(),
          ),
        ),
        GoRoute(
          path: TodoRoutes.pathDetail,
          name: TodoRoutes.nameDetail,
          builder: (context, state) {
            final id = int.parse(state.pathParameters[TodoRoutes.paramId]!);
            return BlocProvider(
              create: (_) => sl<TodoDetailBloc>()..add(LoadTodoDetail(id)),
              child: const TodoDetailPage(),
            );
          },
        ),
      ];
}
