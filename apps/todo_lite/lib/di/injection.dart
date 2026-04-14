import 'package:core/core.dart';
import 'package:todo_feature_navigation/todo_feature_navigation.dart';
import 'package:todo_feature_presentation/todo_feature_presentation.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
  externalPackageModulesBefore: [
    ExternalModule(TodoFeatureDomainPackageModule),
    ExternalModule(TodoFeatureDataPackageModule),
    ExternalModule(TodoFeatureNavigationPackageModule),
    ExternalModule(TodoFeaturePresentationPackageModule),
  ],
)
Future<void> initDependencies() async {
  await sl.init();
}
