import 'package:injectable/injectable.dart';

/// Micro-package init for the todo data layer.
///
/// Registers the database, data sources, repository implementations, and the
/// `TodoStatsProviderModule` cross-feature binding. The host app references
/// the generated `TodoFeatureDataPackageModule` in its
/// `@InjectableInit(externalPackageModulesBefore: [...])` list.
@InjectableInit.microPackage()
void initTodoFeatureDataPackage() {}
