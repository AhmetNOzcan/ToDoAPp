// Re-export the lower layers so apps that depend on this package transitively
// see the generated micro-package modules they need to compose into their own
// `@InjectableInit(externalPackageModulesBefore: [...])`.
export 'package:profile_feature_data/profile_feature_data.dart';
export 'package:profile_feature_domain/profile_feature_domain.dart';

export 'src/di/profile_feature_di.module.dart';
export 'src/profile_feature_routes.dart';
