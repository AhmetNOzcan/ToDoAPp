import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'profile_routes.dart';

/// Typed navigation entry points for the profile feature.
///
/// Other features and app shells depend on `profile_feature_navigation`
/// and call these helpers — they never have to know the URL shape
/// or import `go_router` directly.
class ProfileNavigation {
  const ProfileNavigation._();

  static void goToRoot(BuildContext context) {
    context.go(ProfileRoutes.locationRoot());
  }

  static void pushRoot(BuildContext context) {
    context.push(ProfileRoutes.locationRoot());
  }
}
