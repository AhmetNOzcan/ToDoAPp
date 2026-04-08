import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_feature_navigation/todo_feature_navigation.dart';

import 'bloc/todo_detail_bloc.dart';
import 'bloc/todo_detail_event.dart';
import 'bloc/todo_list_bloc.dart';
import 'pages/todo_detail_page.dart';
import 'pages/todo_list_page.dart';

class TodoFeatureRoutes implements FeatureRoutes {
  const TodoFeatureRoutes();

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
