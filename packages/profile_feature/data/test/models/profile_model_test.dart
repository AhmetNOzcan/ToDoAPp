import 'package:flutter_test/flutter_test.dart';
import 'package:profile_feature_data/src/models/profile_model.dart';
import 'package:profile_feature_domain/src/entities/user_profile.dart';

void main() {
  group('ProfileModel', () {
    const tId = 1;
    const tFirstName = 'John';
    const tLastName = 'Doe';
    const tPhotoPath = '/path/to/photo.jpg';

    const tModel = ProfileModel(
      id: tId,
      firstName: tFirstName,
      lastName: tLastName,
      photoPath: tPhotoPath,
    );

    const tMap = {
      'id': tId,
      'first_name': tFirstName,
      'last_name': tLastName,
      'photo_path': tPhotoPath,
    };

    test('should be a subclass of UserProfile', () {
      expect(tModel, isA<UserProfile>());
    });

    group('fromMap', () {
      test('should return a valid model from a map with all fields', () {
        // act
        final result = ProfileModel.fromMap(tMap);

        // assert
        expect(result.id, tId);
        expect(result.firstName, tFirstName);
        expect(result.lastName, tLastName);
        expect(result.photoPath, tPhotoPath);
      });

      test('should return a valid model when id is null', () {
        // arrange
        final mapWithoutId = {
          'id': null,
          'first_name': tFirstName,
          'last_name': tLastName,
          'photo_path': tPhotoPath,
        };

        // act
        final result = ProfileModel.fromMap(mapWithoutId);

        // assert
        expect(result.id, isNull);
        expect(result.firstName, tFirstName);
        expect(result.lastName, tLastName);
        expect(result.photoPath, tPhotoPath);
      });

      test('should return a valid model when photoPath is null', () {
        // arrange
        final mapWithoutPhoto = {
          'id': tId,
          'first_name': tFirstName,
          'last_name': tLastName,
          'photo_path': null,
        };

        // act
        final result = ProfileModel.fromMap(mapWithoutPhoto);

        // assert
        expect(result.id, tId);
        expect(result.firstName, tFirstName);
        expect(result.lastName, tLastName);
        expect(result.photoPath, isNull);
      });

      test('should return a valid model when both id and photoPath are null', () {
        // arrange
        final mapMinimal = {
          'id': null,
          'first_name': 'Jane',
          'last_name': 'Smith',
          'photo_path': null,
        };

        // act
        final result = ProfileModel.fromMap(mapMinimal);

        // assert
        expect(result.id, isNull);
        expect(result.firstName, 'Jane');
        expect(result.lastName, 'Smith');
        expect(result.photoPath, isNull);
      });
    });

    group('toMap', () {
      test('should return a map containing all fields when id is present', () {
        // act
        final result = tModel.toMap();

        // assert
        expect(result, tMap);
      });

      test('should exclude id from map when id is null', () {
        // arrange
        const modelWithoutId = ProfileModel(
          firstName: tFirstName,
          lastName: tLastName,
          photoPath: tPhotoPath,
        );

        // act
        final result = modelWithoutId.toMap();

        // assert
        expect(result.containsKey('id'), isFalse);
        expect(result['first_name'], tFirstName);
        expect(result['last_name'], tLastName);
        expect(result['photo_path'], tPhotoPath);
      });

      test('should include null photo_path when photoPath is null', () {
        // arrange
        const modelWithoutPhoto = ProfileModel(
          id: tId,
          firstName: tFirstName,
          lastName: tLastName,
        );

        // act
        final result = modelWithoutPhoto.toMap();

        // assert
        expect(result['id'], tId);
        expect(result['first_name'], tFirstName);
        expect(result['last_name'], tLastName);
        expect(result['photo_path'], isNull);
      });
    });

    group('fromEntity', () {
      test('should return a ProfileModel from a UserProfile entity', () {
        // arrange
        const entity = UserProfile(
          id: tId,
          firstName: tFirstName,
          lastName: tLastName,
          photoPath: tPhotoPath,
        );

        // act
        final result = ProfileModel.fromEntity(entity);

        // assert
        expect(result, isA<ProfileModel>());
        expect(result.id, entity.id);
        expect(result.firstName, entity.firstName);
        expect(result.lastName, entity.lastName);
        expect(result.photoPath, entity.photoPath);
      });

      test('should handle entity with null optional fields', () {
        // arrange
        const entity = UserProfile(
          firstName: 'Jane',
          lastName: 'Smith',
        );

        // act
        final result = ProfileModel.fromEntity(entity);

        // assert
        expect(result.id, isNull);
        expect(result.firstName, 'Jane');
        expect(result.lastName, 'Smith');
        expect(result.photoPath, isNull);
      });

      test('should create model that is equal to manually constructed model', () {
        // arrange
        const entity = UserProfile(
          id: tId,
          firstName: tFirstName,
          lastName: tLastName,
          photoPath: tPhotoPath,
        );

        // act
        final fromEntityResult = ProfileModel.fromEntity(entity);

        // assert
        expect(fromEntityResult, equals(tModel));
      });
    });
  });
}
