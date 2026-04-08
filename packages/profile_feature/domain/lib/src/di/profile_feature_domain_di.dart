import 'package:injectable/injectable.dart';

/// Micro-package init for the profile domain layer.
///
/// `injectable_generator` only sees classes annotated within the same pub
/// package. To register the use cases that live in this package, the host app
/// must include the generated `ProfileFeatureDomainPackageModule` in its
/// `@InjectableInit(externalPackageModulesBefore: [...])` list.
@InjectableInit.microPackage()
void initProfileFeatureDomainPackage() {}
