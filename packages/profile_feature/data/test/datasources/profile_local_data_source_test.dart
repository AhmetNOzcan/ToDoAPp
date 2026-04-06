import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profile_feature_data/src/database/profile_database.dart';
import 'package:profile_feature_data/src/datasources/profile_local_data_source.dart';
import 'package:profile_feature_data/src/models/profile_model.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements Database {}

class MockProfileDatabase extends Mock implements ProfileDatabase {}

void main() {
  late ProfileLocalDataSourceImpl dataSource;
  late MockDatabase mockDatabase;
  late MockProfileDatabase mockProfileDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    mockProfileDatabase = MockProfileDatabase();
    when(() => mockProfileDatabase.database)
        .thenAnswer((_) async => mockDatabase);
    dataSource = ProfileLocalDataSourceImpl(db: mockProfileDatabase);
  });

  group('getProfile', () {
    test('should return ProfileModel from database when data exists', () async {
      // arrange
      final tMap = {
        'id': 1,
        'first_name': 'John',
        'last_name': 'Doe',
        'photo_path': '/path/to/photo.jpg',
      };
      when(() => mockDatabase.query('user_profile', limit: 1))
          .thenAnswer((_) async => [tMap]);

      // act
      final result = await dataSource.getProfile();

      // assert
      expect(result, isA<ProfileModel>());
      expect(result.id, 1);
      expect(result.firstName, 'John');
      expect(result.lastName, 'Doe');
      expect(result.photoPath, '/path/to/photo.jpg');
      verify(() => mockDatabase.query('user_profile', limit: 1)).called(1);
    });

    test('should return default empty ProfileModel when database is empty', () async {
      // arrange
      when(() => mockDatabase.query('user_profile', limit: 1))
          .thenAnswer((_) async => []);

      // act
      final result = await dataSource.getProfile();

      // assert
      expect(result, isA<ProfileModel>());
      expect(result.id, 1);
      expect(result.firstName, '');
      expect(result.lastName, '');
      expect(result.photoPath, isNull);
      verify(() => mockDatabase.query('user_profile', limit: 1)).called(1);
    });

    test('should return profile with null photo when photo_path is null', () async {
      // arrange
      final tMap = {
        'id': 1,
        'first_name': 'Jane',
        'last_name': 'Smith',
        'photo_path': null,
      };
      when(() => mockDatabase.query('user_profile', limit: 1))
          .thenAnswer((_) async => [tMap]);

      // act
      final result = await dataSource.getProfile();

      // assert
      expect(result.firstName, 'Jane');
      expect(result.lastName, 'Smith');
      expect(result.photoPath, isNull);
    });
  });

  group('updateProfile', () {
    const tProfile = ProfileModel(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      photoPath: '/path/to/photo.jpg',
    );

    test('should call database.update with correct arguments', () async {
      // arrange
      when(() => mockDatabase.update(
            any(),
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          )).thenAnswer((_) async => 1);

      // act
      await dataSource.updateProfile(tProfile);

      // assert
      verify(() => mockDatabase.update(
            'user_profile',
            tProfile.toMap(),
            where: 'id = ?',
            whereArgs: [tProfile.id],
          )).called(1);
    });

    test('should call database.update with profile without photo', () async {
      // arrange
      const profileWithoutPhoto = ProfileModel(
        id: 1,
        firstName: 'Jane',
        lastName: 'Smith',
      );
      when(() => mockDatabase.update(
            any(),
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          )).thenAnswer((_) async => 1);

      // act
      await dataSource.updateProfile(profileWithoutPhoto);

      // assert
      verify(() => mockDatabase.update(
            'user_profile',
            profileWithoutPhoto.toMap(),
            where: 'id = ?',
            whereArgs: [profileWithoutPhoto.id],
          )).called(1);
    });
  });

  // Note: savePhoto is not tested here because it relies on dart:io File
  // operations which cannot be easily mocked in unit tests without
  // additional infrastructure (e.g., IOOverrides).
}
