import 'package:go_router/go_router.dart';

/// A feature contributes a set of routes to the host app's GoRouter.
///
/// Dependency registration is handled by `injectable` — each feature's
/// micro-package init is composed by the host app via
/// `@InjectableInit(externalPackageModulesBefore: [...])`. Features only need
/// to expose the routes they want the shell router to mount.
abstract class FeatureRoutes {
  List<RouteBase> get routes;
}
