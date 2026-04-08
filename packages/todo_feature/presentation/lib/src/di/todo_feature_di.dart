import 'package:injectable/injectable.dart';

/// Micro-package init entry point for the todo feature.
///
/// `build_runner` generates a sibling `todo_feature_di.init.dart` exposing the
/// `TodoFeaturePresentationPackageModule` class that the host app references
/// from its top-level `@InjectableInit(externalPackageModulesBefore: ...)`.
@InjectableInit.microPackage()
void initTodoFeaturePackage() {}
