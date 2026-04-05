import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

abstract class FeatureModule {
  List<RouteBase> get routes;
  void registerDependencies(GetIt sl);
}
