import 'package:core/core.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_feature/todo_feature.dart';

final List<FeatureModule> featureModules = [
  TodoModule(),
];

Future<void> initDependencies() async {
  final dbHelper = DatabaseHelper();
  final database = await dbHelper.database;
  sl.registerSingleton<Database>(database);
  sl.registerSingleton<DatabaseHelper>(dbHelper);

  for (final module in featureModules) {
    module.registerDependencies(sl);
  }
}
