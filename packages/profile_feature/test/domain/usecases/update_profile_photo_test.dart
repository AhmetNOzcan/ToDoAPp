import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profile_feature/src/domain/repositories/profile_repository.dart';
import 'package:profile_feature/src/domain/usecases/update_profile_photo.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late UpdateProfilePhoto usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UpdateProfilePhoto(mockRepository);
  });

  const tSourcePath = '/tmp/photo.jpg';
  const tSavedPath = '/documents/profile_123.jpg';

  test('should call repository.saveProfilePhoto with the source path', () async {
    // arrange
    when(() => mockRepository.saveProfilePhoto(any()))
        .thenAnswer((_) async => tSavedPath);

    // act
    final result = await usecase(tSourcePath);

    // assert
    expect(result, tSavedPath);
    verify(() => mockRepository.saveProfilePhoto(tSourcePath)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return the saved path from repository', () async {
    // arrange
    const expectedPath = '/app/documents/profile_photo.png';
    when(() => mockRepository.saveProfilePhoto(any()))
        .thenAnswer((_) async => expectedPath);

    // act
    final result = await usecase('/some/source.png');

    // assert
    expect(result, expectedPath);
  });

  test('should propagate exception when repository throws', () async {
    // arrange
    when(() => mockRepository.saveProfilePhoto(any()))
        .thenThrow(Exception('File not found'));

    // act & assert
    expect(() => usecase(tSourcePath), throwsA(isA<Exception>()));
    verify(() => mockRepository.saveProfilePhoto(tSourcePath)).called(1);
  });
}
