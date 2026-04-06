import 'package:core/core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:profile_feature_presentation/profile_feature_presentation.dart';
import 'package:todo_feature_presentation/todo_feature_presentation.dart';

final List<FeatureModule> featureModules = [
  TodoModule(),
  ProfileModule(),
];

Future<void> initDependencies() async {
  final appDir = await getApplicationDocumentsDirectory();
  sl.registerSingleton<String>(appDir.path, instanceName: 'appDocumentsPath');

  for (final module in featureModules) {
    module.registerDependencies(sl);
  }
}
