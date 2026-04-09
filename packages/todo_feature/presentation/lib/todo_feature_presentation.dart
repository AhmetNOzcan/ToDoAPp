// Re-export the lower layers so apps that depend on this package transitively
// see the generated micro-package modules they need to compose into their own
// `@InjectableInit(externalPackageModulesBefore: [...])`.
export 'package:todo_feature_data/todo_feature_data.dart';
export 'package:todo_feature_domain/todo_feature_domain.dart';

export 'src/di/todo_feature_di.module.dart';
export 'src/todo_feature_routes.dart';
