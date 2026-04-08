import 'package:core/core.dart';
import 'package:todo_feature_presentation/todo_feature_presentation.dart';

import 'injection.config.dart';

/// Routes contributed by the features mounted in this app shell.
///
/// `todo_lite` only ships the todo feature.
const List<FeatureRoutes> featureRoutes = [
  TodoFeatureRoutes(),
];

/// Composes the per-feature micro-package modules into a single GetIt
/// initialization. `injectable_generator` writes the body of `init()` into
/// the sibling `injection.config.dart` based on the annotation below.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
  externalPackageModulesBefore: [
    ExternalModule(TodoFeatureDomainPackageModule),
    ExternalModule(TodoFeatureDataPackageModule),
    ExternalModule(TodoFeaturePresentationPackageModule),
  ],
)
Future<void> initDependencies() async {
  await sl.init();
}
