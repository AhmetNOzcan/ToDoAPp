// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:profile_feature_navigation/profile_feature_navigation.dart'
    as _i315;
import 'package:profile_feature_presentation/profile_feature_presentation.dart'
    as _i746;
import 'package:todo_feature_navigation/todo_feature_navigation.dart' as _i452;
import 'package:todo_feature_presentation/todo_feature_presentation.dart'
    as _i25;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await _i25.TodoFeatureDomainPackageModule().init(gh);
    await _i25.TodoFeatureDataPackageModule().init(gh);
    await _i452.TodoFeatureNavigationPackageModule().init(gh);
    await _i25.TodoFeaturePresentationPackageModule().init(gh);
    await _i746.ProfileFeatureDomainPackageModule().init(gh);
    await _i746.ProfileFeatureDataPackageModule().init(gh);
    await _i315.ProfileFeatureNavigationPackageModule().init(gh);
    await _i746.ProfileFeaturePresentationPackageModule().init(gh);
    return this;
  }
}
