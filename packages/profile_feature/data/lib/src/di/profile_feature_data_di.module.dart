//@GeneratedMicroModule;ProfileFeatureDataPackageModule;package:profile_feature_data/src/di/profile_feature_data_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:core/core.dart' as _i494;
import 'package:injectable/injectable.dart' as _i526;
import 'package:profile_feature_data/src/database/profile_database.dart'
    as _i485;
import 'package:profile_feature_data/src/datasources/profile_local_data_source.dart'
    as _i1040;
import 'package:profile_feature_data/src/di/profile_environment_module.dart'
    as _i106;
import 'package:profile_feature_data/src/profile_logger.dart' as _i929;
import 'package:profile_feature_data/src/repositories/profile_repository_impl.dart'
    as _i421;
import 'package:profile_feature_domain/profile_feature_domain.dart' as _i536;

class ProfileFeatureDataPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final profileEnvironmentModule = _$ProfileEnvironmentModule();
    gh.lazySingleton<_i485.ProfileDatabase>(() => _i485.ProfileDatabase());
    await gh.factoryAsync<String>(
      () => profileEnvironmentModule.appDocumentsPath(),
      instanceName: 'appDocumentsPath',
      preResolve: true,
    );
    gh.lazySingleton<_i494.Logger>(
      () => _i929.ProfileLogger(),
      instanceName: 'ProfileLogger',
    );
    gh.lazySingleton<_i1040.ProfileLocalDataSource>(() =>
        _i1040.ProfileLocalDataSourceImpl(db: gh<_i485.ProfileDatabase>()));
    gh.lazySingleton<_i536.ProfileRepository>(() => _i421.ProfileRepositoryImpl(
          localDataSource: gh<_i1040.ProfileLocalDataSource>(),
          appDocumentsPath: gh<String>(instanceName: 'appDocumentsPath'),
        ));
  }
}

class _$ProfileEnvironmentModule extends _i106.ProfileEnvironmentModule {}
