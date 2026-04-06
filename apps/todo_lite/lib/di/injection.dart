import 'package:core/core.dart';
import 'package:todo_feature_presentation/todo_feature_presentation.dart';

final List<FeatureModule> featureModules = [
  TodoModule(),
];

Future<void> initDependencies() async {
  for (final module in featureModules) {
    module.registerDependencies(sl);
  }
}
