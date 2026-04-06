import 'package:core/core.dart';
import 'package:todo_feature/todo_feature.dart';

final List<FeatureModule> featureModules = [
  TodoModule(),
];

Future<void> initDependencies() async {
  for (final module in featureModules) {
    module.registerDependencies(sl);
  }
}
