/// Cross-feature contract exposed by `todo_feature` so other features can
/// query todo statistics without depending on the todo domain layer.
abstract class TodoStatsProvider {
  Future<int> getCompletedTodoCount();
}
