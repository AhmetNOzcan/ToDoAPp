import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'todo_routes.dart';

/// Typed navigation entry points for the todo feature.
///
/// Other features and app shells depend on `todo_feature_navigation`
/// and call these helpers — they never have to know the URL shape
/// or import `go_router` directly.
class TodoNavigation {
  const TodoNavigation._();

  static void goToList(BuildContext context) {
    context.go(TodoRoutes.locationList());
  }

  static void pushList(BuildContext context) {
    context.push(TodoRoutes.locationList());
  }

  static void goToDetail(BuildContext context, {required int id}) {
    context.go(TodoRoutes.locationDetail(id));
  }

  static void pushDetail(BuildContext context, {required int id}) {
    context.push(TodoRoutes.locationDetail(id));
  }
}
