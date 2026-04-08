import 'package:injectable/injectable.dart';

/// Micro-package init for the profile data layer.
///
/// Registers the database, data source, repository, and the
/// `ProfileEnvironmentModule` (which @preResolves the application documents
/// path). The host app references the generated `ProfileFeatureDataPackageModule`
/// in its `@InjectableInit(externalPackageModulesBefore: [...])` list.
@InjectableInit.microPackage()
void initProfileFeatureDataPackage() {}
