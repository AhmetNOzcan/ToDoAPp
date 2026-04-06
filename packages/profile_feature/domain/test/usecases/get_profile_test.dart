import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profile_feature_domain/src/entities/user_profile.dart';
import 'package:profile_feature_domain/src/repositories/profile_repository.dart';
import 'package:profile_feature_domain/src/usecases/get_profile.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late GetProfile usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = GetProfile(mockRepository);
  });

  const tProfile = UserProfile(
    id: 1,
    firstName: 'John',
    lastName: 'Doe',
    photoPath: '/path/to/photo.jpg',
  );

  test('should get profile from the repository', () async {
    // arrange
    when(() => mockRepository.getProfile())
        .thenAnswer((_) async => tProfile);

    // act
    final result = await usecase();

    // assert
    expect(result, tProfile);
    verify(() => mockRepository.getProfile()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return profile without photo when photoPath is null', () async {
    // arrange
    const profileWithoutPhoto = UserProfile(
      id: 1,
      firstName: 'Jane',
      lastName: 'Smith',
    );
    when(() => mockRepository.getProfile())
        .thenAnswer((_) async => profileWithoutPhoto);

    // act
    final result = await usecase();

    // assert
    expect(result, profileWithoutPhoto);
    expect(result.photoPath, isNull);
    verify(() => mockRepository.getProfile()).called(1);
  });

  test('should propagate exception when repository throws', () async {
    // arrange
    when(() => mockRepository.getProfile())
        .thenThrow(Exception('Database error'));

    // act & assert
    expect(() => usecase(), throwsA(isA<Exception>()));
    verify(() => mockRepository.getProfile()).called(1);
  });
}
