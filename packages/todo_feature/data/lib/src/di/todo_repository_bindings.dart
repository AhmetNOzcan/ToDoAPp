import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_feature_domain/todo_feature_domain.dart';

import '../repositories/todo_repository_impl.dart';

/// Exposes the singleton [TodoRepositoryImpl] under the two interfaces it
/// implements: [TodoRepository] (used by the todo feature itself) and
/// [TodoStatsProvider] (the narrower cross-feature contract consumed by the
/// profile feature).
///
/// [TodoRepositoryImpl] itself is registered as a `@lazySingleton` directly
/// on the class. Both methods below take it as a parameter, so injectable
/// resolves the existing registration and reuses the same instance for both
/// bindings. No runtime cast, no second instance — if the impl ever stops
/// implementing one of these contracts, this file fails to compile.
@module
abstract class TodoRepositoryBindings {
  @lazySingleton
  TodoRepository todoRepository(TodoRepositoryImpl impl) => impl;

  @lazySingleton
  TodoStatsProvider todoStatsProvider(TodoRepositoryImpl impl) => impl;
}
