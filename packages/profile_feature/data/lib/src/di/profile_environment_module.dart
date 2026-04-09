import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

/// Resolves environment values that the profile feature needs at startup.
///
/// Marked with [preResolve] because [getApplicationDocumentsDirectory] is
/// async and must be awaited before [ProfileRepositoryImpl] is constructed.
/// Both apps already call `WidgetsFlutterBinding.ensureInitialized()` before
/// `await initDependencies()` in `main.dart`, which is the prerequisite for
/// `path_provider` to function.
///
/// Lives in `profile_feature_data` (not the app shell) so the dependency on
/// `path_provider` travels with the feature that consumes it. `todo_lite`,
/// which doesn't include the profile feature, never resolves this binding
/// and never pulls `path_provider` into its dependency graph.
@module
abstract class ProfileEnvironmentModule {
  @preResolve
  @Named('appDocumentsPath')
  Future<String> appDocumentsPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
}
