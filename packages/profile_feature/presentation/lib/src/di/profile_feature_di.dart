import 'package:injectable/injectable.dart';

/// Micro-package init entry point for the profile feature.
///
/// `build_runner` generates a sibling `profile_feature_di.init.dart` exposing
/// the `ProfileFeaturePresentationPackageModule` class that the host app
/// references from its top-level `@InjectableInit(externalPackageModulesBefore: ...)`.
@InjectableInit.microPackage()
void initProfileFeaturePackage() {}
