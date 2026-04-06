import 'package:flutter_test/flutter_test.dart';
import 'package:profile_feature_navigation/profile_feature_navigation.dart';

void main() {
  group('ProfileRoutes', () {
    test('path patterns are stable', () {
      expect(ProfileRoutes.pathRoot, '/profile');
    });

    test('route names are stable', () {
      expect(ProfileRoutes.nameRoot, 'profile_root');
    });

    test('locationRoot builds the root URL', () {
      expect(ProfileRoutes.locationRoot(), '/profile');
    });

    test('matches recognises profile locations', () {
      expect(ProfileRoutes.matches('/profile'), isTrue);
      expect(ProfileRoutes.matches('/profile/edit'), isTrue);
    });

    test('matches rejects unrelated locations', () {
      expect(ProfileRoutes.matches('/todos'), isFalse);
      expect(ProfileRoutes.matches('/'), isFalse);
      expect(ProfileRoutes.matches(''), isFalse);
    });
  });
}
