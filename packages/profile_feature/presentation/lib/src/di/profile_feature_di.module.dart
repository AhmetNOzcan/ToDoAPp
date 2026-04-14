//@GeneratedMicroModule;ProfileFeaturePresentationPackageModule;package:profile_feature_presentation/src/di/profile_feature_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:core/core.dart' as _i494;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:profile_feature_domain/profile_feature_domain.dart' as _i536;
import 'package:profile_feature_presentation/src/bloc/profile_bloc.dart'
    as _i840;
import 'package:profile_feature_presentation/src/di/profile_third_party_module.dart'
    as _i994;
import 'package:profile_feature_presentation/src/profile_nav_graph.dart'
    as _i112;
import 'package:todo_feature_domain/todo_feature_domain.dart' as _i41;

class ProfileFeaturePresentationPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final profileThirdPartyModule = _$ProfileThirdPartyModule();
    gh.lazySingleton<_i183.ImagePicker>(
        () => profileThirdPartyModule.imagePicker);
    gh.lazySingleton<_i494.NavGraph>(
      () => _i112.ProfileNavGraph(),
      instanceName: 'Profile',
    );
    gh.factory<_i840.ProfileBloc>(() => _i840.ProfileBloc(
          getProfile: gh<_i536.GetProfile>(),
          updateProfile: gh<_i536.UpdateProfile>(),
          updateProfilePhoto: gh<_i536.UpdateProfilePhoto>(),
          todoStatsProvider: gh<_i41.TodoStatsProvider>(),
          imagePicker: gh<_i183.ImagePicker>(),
        ));
  }
}

class _$ProfileThirdPartyModule extends _i994.ProfileThirdPartyModule {}
