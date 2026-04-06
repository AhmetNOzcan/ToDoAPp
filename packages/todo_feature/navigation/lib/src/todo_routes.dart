/// Single source of truth for the todo feature's navigation surface.
///
/// - `path...` constants are passed to `GoRoute.path` when the todo
///   presentation module registers its routes.
/// - `name...` constants are passed to `GoRoute.name` so callers can
///   navigate by name as a refactor-safe backup.
/// - `location...` builders produce concrete URLs from typed arguments
///   and are what `TodoNavigation` ultimately hands to `context.go/push`.
/// - `matches` lets the app shell decide whether a given location
///   belongs to this feature (used by the bottom-nav selected index).
class TodoRoutes {
  const TodoRoutes._();

  // Path patterns (passed to GoRoute.path).
  static const String pathList = '/todos';
  static const String pathDetail = '/todos/:id';

  // Route names (passed to GoRoute.name).
  static const String nameList = 'todo_list';
  static const String nameDetail = 'todo_detail';

  // Path parameter keys.
  static const String paramId = 'id';

  // Typed location builders (passed to context.go/push).
  static String locationList() => '/todos';
  static String locationDetail(int id) => '/todos/$id';

  /// Whether the given GoRouter location belongs to the todo feature.
  static bool matches(String location) => location.startsWith('/todos');
}
