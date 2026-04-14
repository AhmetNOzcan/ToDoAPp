import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'todo_navigator.dart';
import 'todo_routes.dart';

@LazySingleton(as: TodoNavigator)
class TodoNavigatorImpl implements TodoNavigator {
  @override
  void goToList(BuildContext context) => context.go(TodoRoutes.pathList);

  @override
  void pushList(BuildContext context) => context.push(TodoRoutes.pathList);

  @override
  void goToDetail(BuildContext context, {required int id}) =>
      context.go('${TodoRoutes.pathList}/$id');

  @override
  void pushDetail(BuildContext context, {required int id}) =>
      context.push('${TodoRoutes.pathList}/$id');

  @override
  bool matches(String location) => location.startsWith(TodoRoutes.pathList);

  @override
  String get initialLocation => TodoRoutes.pathList;
}
