import 'package:core/core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_feature/todo_feature.dart';
import 'package:profile_feature/profile_feature.dart';

final List<FeatureModule> featureModules = [
  TodoModule(),
  ProfileModule(),
];

Future<void> initDependencies() async {
  final dbHelper = DatabaseHelper();
  final database = await dbHelper.database;
  sl.registerSingleton<Database>(database);
  sl.registerSingleton<DatabaseHelper>(dbHelper);

  final appDir = await getApplicationDocumentsDirectory();
  sl.registerSingleton<String>(appDir.path, instanceName: 'appDocumentsPath');

  for (final module in featureModules) {
    module.registerDependencies(sl);
  }
}
