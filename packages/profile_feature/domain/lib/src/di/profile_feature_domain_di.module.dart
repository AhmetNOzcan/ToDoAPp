//@GeneratedMicroModule;ProfileFeatureDomainPackageModule;package:profile_feature_domain/src/di/profile_feature_domain_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:profile_feature_domain/src/repositories/profile_repository.dart'
    as _i764;
import 'package:profile_feature_domain/src/usecases/get_profile.dart' as _i1016;
import 'package:profile_feature_domain/src/usecases/update_profile.dart'
    as _i509;
import 'package:profile_feature_domain/src/usecases/update_profile_photo.dart'
    as _i262;

class ProfileFeatureDomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i1016.GetProfile>(
        () => _i1016.GetProfile(gh<_i764.ProfileRepository>()));
    gh.factory<_i509.UpdateProfile>(
        () => _i509.UpdateProfile(gh<_i764.ProfileRepository>()));
    gh.factory<_i262.UpdateProfilePhoto>(
        () => _i262.UpdateProfilePhoto(gh<_i764.ProfileRepository>()));
  }
}
