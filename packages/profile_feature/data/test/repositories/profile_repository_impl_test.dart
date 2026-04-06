import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profile_feature/src/data/datasources/profile_local_data_source.dart';
import 'package:profile_feature/src/data/models/profile_model.dart';
import 'package:profile_feature/src/data/repositories/profile_repository_impl.dart';
import 'package:profile_feature/src/domain/entities/user_profile.dart';

class MockProfileLocalDataSource extends Mock
    implements ProfileLocalDataSource {}

void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileLocalDataSource mockLocalDataSource;
  const tAppDocumentsPath = '/app/documents';

  setUp(() {
    mockLocalDataSource = MockProfileLocalDataSource();
    repository = ProfileRepositoryImpl(
      localDataSource: mockLocalDataSource,
      appDocumentsPath: tAppDocumentsPath,
    );
  });

  setUpAll(() {
    registerFallbackValue(const ProfileModel(
      id: 1,
      firstName: '',
      lastName: '',
    ));
  });

  group('getProfile', () {
    const tProfileModel = ProfileModel(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      photoPath: '/path/to/photo.jpg',
    );

    test('should return UserProfile from local data source', () async {
      // arrange
      when(() => mockLocalDataSource.getProfile())
          .thenAnswer((_) async => tProfileModel);

      // act
      final result = await repository.getProfile();

      // assert
      expect(result, isA<UserProfile>());
      expect(result.id, tProfileModel.id);
      expect(result.firstName, tProfileModel.firstName);
      expect(result.lastName, tProfileModel.lastName);
      expect(result.photoPath, tProfileModel.photoPath);
      verify(() => mockLocalDataSource.getProfile()).called(1);
    });

    test('should propagate exception when data source throws', () async {
      // arrange
      when(() => mockLocalDataSource.getProfile())
          .thenThrow(Exception('Database error'));

      // act & assert
      expect(() => repository.getProfile(), throwsA(isA<Exception>()));
    });
  });

  group('updateProfile', () {
    const tUserProfile = UserProfile(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      photoPath: '/path/to/photo.jpg',
    );

    test('should convert UserProfile to ProfileModel and call data source', () async {
      // arrange
      when(() => mockLocalDataSource.updateProfile(any()))
          .thenAnswer((_) async {});

      // act
      await repository.updateProfile(tUserProfile);

      // assert
      final captured = verify(
        () => mockLocalDataSource.updateProfile(captureAny()),
      ).captured;
      final capturedModel = captured.first as ProfileModel;
      expect(capturedModel.id, tUserProfile.id);
      expect(capturedModel.firstName, tUserProfile.firstName);
      expect(capturedModel.lastName, tUserProfile.lastName);
      expect(capturedModel.photoPath, tUserProfile.photoPath);
    });

    test('should propagate exception when data source throws', () async {
      // arrange
      when(() => mockLocalDataSource.updateProfile(any()))
          .thenThrow(Exception('Update failed'));

      // act & assert
      expect(
        () => repository.updateProfile(tUserProfile),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle profile without optional fields', () async {
      // arrange
      const profileMinimal = UserProfile(
        firstName: 'Jane',
        lastName: 'Smith',
      );
      when(() => mockLocalDataSource.updateProfile(any()))
          .thenAnswer((_) async {});

      // act
      await repository.updateProfile(profileMinimal);

      // assert
      final captured = verify(
        () => mockLocalDataSource.updateProfile(captureAny()),
      ).captured;
      final capturedModel = captured.first as ProfileModel;
      expect(capturedModel.id, isNull);
      expect(capturedModel.firstName, 'Jane');
      expect(capturedModel.lastName, 'Smith');
      expect(capturedModel.photoPath, isNull);
    });
  });

  group('saveProfilePhoto', () {
    const tSourcePath = '/tmp/photo.jpg';
    const tSavedPath = '/app/documents/profile_123.jpg';

    test('should delegate to data source with source path and documents path', () async {
      // arrange
      when(() => mockLocalDataSource.savePhoto(any(), any()))
          .thenAnswer((_) async => tSavedPath);

      // act
      final result = await repository.saveProfilePhoto(tSourcePath);

      // assert
      expect(result, tSavedPath);
      verify(() => mockLocalDataSource.savePhoto(
            tSourcePath,
            tAppDocumentsPath,
          )).called(1);
    });

    test('should propagate exception when data source throws', () async {
      // arrange
      when(() => mockLocalDataSource.savePhoto(any(), any()))
          .thenThrow(Exception('File error'));

      // act & assert
      expect(
        () => repository.saveProfilePhoto(tSourcePath),
        throwsA(isA<Exception>()),
      );
    });
  });
}
