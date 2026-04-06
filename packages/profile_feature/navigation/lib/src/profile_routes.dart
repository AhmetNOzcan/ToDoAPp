/// Single source of truth for the profile feature's navigation surface.
///
/// - `path...` constants are passed to `GoRoute.path` when the profile
///   presentation module registers its routes.
/// - `name...` constants are passed to `GoRoute.name` so callers can
///   navigate by name as a refactor-safe backup.
/// - `location...` builders produce concrete URLs from typed arguments
///   and are what `ProfileNavigation` ultimately hands to `context.go/push`.
/// - `matches` lets the app shell decide whether a given location
///   belongs to this feature (used by the bottom-nav selected index).
class ProfileRoutes {
  const ProfileRoutes._();

  // Path patterns (passed to GoRoute.path).
  static const String pathRoot = '/profile';

  // Route names (passed to GoRoute.name).
  static const String nameRoot = 'profile_root';

  // Typed location builders (passed to context.go/push).
  static String locationRoot() => '/profile';

  /// Whether the given GoRouter location belongs to the profile feature.
  static bool matches(String location) => location.startsWith('/profile');
}
