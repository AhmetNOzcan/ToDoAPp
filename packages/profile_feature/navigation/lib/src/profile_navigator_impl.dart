import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'profile_navigator.dart';
import 'profile_routes.dart';

@LazySingleton(as: ProfileNavigator)
class ProfileNavigatorImpl implements ProfileNavigator {
  @override
  void goToRoot(BuildContext context) => context.go(ProfileRoutes.pathRoot);

  @override
  void pushRoot(BuildContext context) => context.push(ProfileRoutes.pathRoot);

  @override
  bool matches(String location) => location.startsWith(ProfileRoutes.pathRoot);

  @override
  String get initialLocation => ProfileRoutes.pathRoot;
}
