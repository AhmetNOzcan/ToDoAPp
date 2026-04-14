//@GeneratedMicroModule;TodoFeatureNavigationPackageModule;package:todo_feature_navigation/src/di/todo_feature_navigation_di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:injectable/injectable.dart' as _i526;
import 'package:todo_feature_navigation/src/todo_navigator.dart' as _i47;
import 'package:todo_feature_navigation/src/todo_navigator_impl.dart' as _i312;

class TodoFeatureNavigationPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i47.TodoNavigator>(() => _i312.TodoNavigatorImpl());
  }
}
