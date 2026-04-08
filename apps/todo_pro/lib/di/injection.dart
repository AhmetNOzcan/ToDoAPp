import 'package:core/core.dart';
import 'package:profile_feature_presentation/profile_feature_presentation.dart';
import 'package:todo_feature_presentation/todo_feature_presentation.dart';

import 'injection.config.dart';

/// Routes contributed by the features mounted in this app shell.
///
/// `todo_pro` ships both the todo and profile features.
const List<FeatureRoutes> featureRoutes = [
  TodoFeatureRoutes(),
  ProfileFeatureRoutes(),
];

/// Composes the per-feature micro-package modules into a single GetIt
/// initialization. `injectable_generator` writes the body of `init()` into
/// the sibling `injection.config.dart` based on the annotation below.
///
/// The profile feature's [ProfileEnvironmentModule] uses `@preResolve` to
/// `await getApplicationDocumentsDirectory()`, so the generated `init()` is
/// async — `await sl.init()` blocks startup until that path is available.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
  externalPackageModulesBefore: [
    ExternalModule(TodoFeatureDomainPackageModule),
    ExternalModule(TodoFeatureDataPackageModule),
    ExternalModule(TodoFeaturePresentationPackageModule),
    ExternalModule(ProfileFeatureDomainPackageModule),
    ExternalModule(ProfileFeatureDataPackageModule),
    ExternalModule(ProfileFeaturePresentationPackageModule),
  ],
)
Future<void> initDependencies() async {
  await sl.init();
}
