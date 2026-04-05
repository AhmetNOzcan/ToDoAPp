import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profile_feature/src/domain/entities/user_profile.dart';
import 'package:profile_feature/src/domain/repositories/profile_repository.dart';
import 'package:profile_feature/src/domain/usecases/update_profile.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late UpdateProfile usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UpdateProfile(mockRepository);
  });

  const tProfile = UserProfile(
    id: 1,
    firstName: 'John',
    lastName: 'Doe',
    photoPath: '/path/to/photo.jpg',
  );

  setUpAll(() {
    registerFallbackValue(tProfile);
  });

  test('should call repository.updateProfile with the given profile', () async {
    // arrange
    when(() => mockRepository.updateProfile(any()))
        .thenAnswer((_) async {});

    // act
    await usecase(tProfile);

    // assert
    verify(() => mockRepository.updateProfile(tProfile)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should propagate exception when repository throws', () async {
    // arrange
    when(() => mockRepository.updateProfile(any()))
        .thenThrow(Exception('Update failed'));

    // act & assert
    expect(() => usecase(tProfile), throwsA(isA<Exception>()));
    verify(() => mockRepository.updateProfile(tProfile)).called(1);
  });

  test('should pass profile with updated fields correctly', () async {
    // arrange
    const updatedProfile = UserProfile(
      id: 1,
      firstName: 'Jane',
      lastName: 'Smith',
      photoPath: '/new/path.jpg',
    );
    when(() => mockRepository.updateProfile(any()))
        .thenAnswer((_) async {});

    // act
    await usecase(updatedProfile);

    // assert
    verify(() => mockRepository.updateProfile(updatedProfile)).called(1);
  });
}
