import 'package:flutter_test/flutter_test.dart';
import 'package:profile_feature_navigation/src/profile_navigator_impl.dart';
import 'package:profile_feature_navigation/profile_feature_navigation.dart';

void main() {
  group('ProfileRoutes', () {
    test('path patterns are stable', () {
      expect(ProfileRoutes.pathRoot, '/profile');
    });

    test('route names are stable', () {
      expect(ProfileRoutes.nameRoot, 'profile_root');
    });
  });

  group('ProfileNavigatorImpl', () {
    final navigator = ProfileNavigatorImpl();

    test('initialLocation points at the profile root', () {
      expect(navigator.initialLocation, '/profile');
    });

    test('matches recognises profile locations', () {
      expect(navigator.matches('/profile'), isTrue);
      expect(navigator.matches('/profile/edit'), isTrue);
    });

    test('matches rejects unrelated locations', () {
      expect(navigator.matches('/todos'), isFalse);
      expect(navigator.matches('/'), isFalse);
      expect(navigator.matches(''), isFalse);
    });
  });
}
