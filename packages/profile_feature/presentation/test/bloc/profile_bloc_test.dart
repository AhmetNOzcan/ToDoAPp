import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profile_feature/src/domain/entities/user_profile.dart';
import 'package:profile_feature/src/domain/usecases/get_profile.dart';
import 'package:profile_feature/src/domain/usecases/update_profile.dart';
import 'package:profile_feature/src/domain/usecases/update_profile_photo.dart';
import 'package:profile_feature/src/presentation/bloc/profile_bloc.dart';
import 'package:profile_feature/src/presentation/bloc/profile_event.dart';
import 'package:profile_feature/src/presentation/bloc/profile_state.dart';
import 'package:todo_feature/todo_feature.dart';

class MockGetProfile extends Mock implements GetProfile {}

class MockUpdateProfile extends Mock implements UpdateProfile {}

class MockUpdateProfilePhoto extends Mock implements UpdateProfilePhoto {}

class MockTodoStatsProvider extends Mock implements TodoStatsProvider {}

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  late ProfileBloc bloc;
  late MockGetProfile mockGetProfile;
  late MockUpdateProfile mockUpdateProfile;
  late MockUpdateProfilePhoto mockUpdateProfilePhoto;
  late MockTodoStatsProvider mockTodoStatsProvider;
  late MockImagePicker mockImagePicker;

  const tProfile = UserProfile(
    id: 1,
    firstName: 'John',
    lastName: 'Doe',
    photoPath: '/path/to/photo.jpg',
  );

  setUp(() {
    mockGetProfile = MockGetProfile();
    mockUpdateProfile = MockUpdateProfile();
    mockUpdateProfilePhoto = MockUpdateProfilePhoto();
    mockTodoStatsProvider = MockTodoStatsProvider();
    mockImagePicker = MockImagePicker();

    bloc = ProfileBloc(
      getProfile: mockGetProfile,
      updateProfile: mockUpdateProfile,
      updateProfilePhoto: mockUpdateProfilePhoto,
      todoStatsProvider: mockTodoStatsProvider,
      imagePicker: mockImagePicker,
    );
  });

  setUpAll(() {
    registerFallbackValue(tProfile);
    registerFallbackValue(ImageSource.gallery);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is ProfileState with initial status', () {
    expect(bloc.state, const ProfileState());
    expect(bloc.state.status, ProfileStatus.initial);
    expect(bloc.state.profile, isNull);
    expect(bloc.state.completedTodoCount, 0);
    expect(bloc.state.errorMessage, isNull);
  });

  group('LoadProfile', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, loaded] when LoadProfile succeeds',
      build: () {
        when(() => mockGetProfile()).thenAnswer((_) async => tProfile);
        when(() => mockTodoStatsProvider.getCompletedTodoCount())
            .thenAnswer((_) async => 5);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadProfile()),
      expect: () => [
        const ProfileState(status: ProfileStatus.loading),
        const ProfileState(
          status: ProfileStatus.loaded,
          profile: tProfile,
          completedTodoCount: 5,
        ),
      ],
      verify: (_) {
        verify(() => mockGetProfile()).called(1);
        verify(() => mockTodoStatsProvider.getCompletedTodoCount()).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, loaded] with zero completed count',
      build: () {
        when(() => mockGetProfile()).thenAnswer((_) async => tProfile);
        when(() => mockTodoStatsProvider.getCompletedTodoCount())
            .thenAnswer((_) async => 0);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadProfile()),
      expect: () => [
        const ProfileState(status: ProfileStatus.loading),
        const ProfileState(
          status: ProfileStatus.loaded,
          profile: tProfile,
          completedTodoCount: 0,
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, error] when getProfile throws',
      build: () {
        when(() => mockGetProfile())
            .thenThrow(Exception('Database error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadProfile()),
      expect: () => [
        const ProfileState(status: ProfileStatus.loading),
        ProfileState(
          status: ProfileStatus.error,
          errorMessage: Exception('Database error').toString(),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, error] when todoStatsProvider throws',
      build: () {
        when(() => mockGetProfile()).thenAnswer((_) async => tProfile);
        when(() => mockTodoStatsProvider.getCompletedTodoCount())
            .thenThrow(Exception('Stats error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadProfile()),
      expect: () => [
        const ProfileState(status: ProfileStatus.loading),
        ProfileState(
          status: ProfileStatus.error,
          errorMessage: Exception('Stats error').toString(),
        ),
      ],
    );
  });

  group('UpdateProfileRequested', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [saved] with updated profile when update succeeds',
      build: () {
        when(() => mockUpdateProfile(any())).thenAnswer((_) async {});
        return bloc;
      },
      seed: () => const ProfileState(
        status: ProfileStatus.loaded,
        profile: tProfile,
        completedTodoCount: 5,
      ),
      act: (bloc) => bloc.add(const UpdateProfileRequested(
        firstName: 'Jane',
        lastName: 'Smith',
      )),
      expect: () => [
        ProfileState(
          status: ProfileStatus.saved,
          profile: tProfile.copyWith(firstName: 'Jane', lastName: 'Smith'),
          completedTodoCount: 5,
        ),
      ],
      verify: (_) {
        verify(() => mockUpdateProfile(any())).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits nothing when profile is null (no current profile loaded)',
      build: () => bloc,
      seed: () => const ProfileState(status: ProfileStatus.initial),
      act: (bloc) => bloc.add(const UpdateProfileRequested(
        firstName: 'Jane',
        lastName: 'Smith',
      )),
      expect: () => [],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [error] when updateProfile throws',
      build: () {
        when(() => mockUpdateProfile(any()))
            .thenThrow(Exception('Update failed'));
        return bloc;
      },
      seed: () => const ProfileState(
        status: ProfileStatus.loaded,
        profile: tProfile,
        completedTodoCount: 5,
      ),
      act: (bloc) => bloc.add(const UpdateProfileRequested(
        firstName: 'Jane',
        lastName: 'Smith',
      )),
      expect: () => [
        ProfileState(
          status: ProfileStatus.error,
          profile: tProfile,
          completedTodoCount: 5,
          errorMessage: Exception('Update failed').toString(),
        ),
      ],
    );
  });

  group('PickPhotoFromCamera', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [saved] with updated photo when camera pick succeeds',
      build: () {
        when(() => mockImagePicker.pickImage(
              source: ImageSource.camera,
              maxWidth: 512,
              maxHeight: 512,
              imageQuality: 80,
            )).thenAnswer((_) async => XFile('/tmp/camera_photo.jpg'));
        when(() => mockUpdateProfilePhoto(any()))
            .thenAnswer((_) async => '/saved/photo.jpg');
        when(() => mockUpdateProfile(any())).thenAnswer((_) async {});
        return bloc;
      },
      seed: () => const ProfileState(
        status: ProfileStatus.loaded,
        profile: tProfile,
        completedTodoCount: 3,
      ),
      act: (bloc) => bloc.add(const PickPhotoFromCamera()),
      expect: () => [
        ProfileState(
          status: ProfileStatus.saved,
          profile: tProfile.copyWith(photoPath: '/saved/photo.jpg'),
          completedTodoCount: 3,
        ),
      ],
      verify: (_) {
        verify(() => mockImagePicker.pickImage(
              source: ImageSource.camera,
              maxWidth: 512,
              maxHeight: 512,
              imageQuality: 80,
            )).called(1);
        verify(() => mockUpdateProfilePhoto('/tmp/camera_photo.jpg')).called(1);
        verify(() => mockUpdateProfile(any())).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits nothing when user cancels camera picker (returns null)',
      build: () {
        when(() => mockImagePicker.pickImage(
              source: ImageSource.camera,
              maxWidth: 512,
              maxHeight: 512,
              imageQuality: 80,
            )).thenAnswer((_) async => null);
        return bloc;
      },
      seed: () => const ProfileState(
        status: ProfileStatus.loaded,
        profile: tProfile,
      ),
      act: (bloc) => bloc.add(const PickPhotoFromCamera()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockUpdateProfilePhoto(any()));
        verifyNever(() => mockUpdateProfile(any()));
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits nothing when profile is null',
      build: () => bloc,
      seed: () => const ProfileState(status: ProfileStatus.initial),
      act: (bloc) => bloc.add(const PickPhotoFromCamera()),
      expect: () => [],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [error] when image picker throws',
      build: () {
        when(() => mockImagePicker.pickImage(
              source: ImageSource.camera,
              maxWidth: 512,
              maxHeight: 512,
              imageQuality: 80,
            )).thenThrow(Exception('Camera error'));
        return bloc;
      },
      seed: () => const ProfileState(
        status: ProfileStatus.loaded,
        profile: tProfile,
        completedTodoCount: 3,
      ),
      act: (bloc) => bloc.add(const PickPhotoFromCamera()),
      expect: () => [
        ProfileState(
          status: ProfileStatus.error,
          profile: tProfile,
          completedTodoCount: 3,
          errorMessage: Exception('Camera error').toString(),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [error] when updateProfilePhoto throws',
      build: () {
        when(() => mockImagePicker.pickImage(
              source: ImageSource.camera,
              maxWidth: 512,
              maxHeight: 512,
              imageQuality: 80,
            )).thenAnswer((_) async => XFile('/tmp/photo.jpg'));
        when(() => mockUpdateProfilePhoto(any()))
            .thenThrow(Exception('Save failed'));
        return bloc;
      },
      seed: () => const ProfileState(
        status: ProfileStatus.loaded,
        profile: tProfile,
        completedTodoCount: 3,
      ),
      act: (bloc) => bloc.add(const PickPhotoFromCamera()),
      expect: () => [
        ProfileState(
          status: ProfileStatus.error,
          profile: tProfile,
          completedTodoCount: 3,
          errorMessage: Exception('Save failed').toString(),
        ),
      ],
    );
  });

  group('PickPhotoFromGallery', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [saved] with updated photo when gallery pick succeeds',
      build: () {
        when(() => mockImagePicker.pickImage(
              source: ImageSource.gallery,
              maxWidth: 512,
              maxHeight: 512,
              imageQuality: 80,
            )).thenAnswer((_) async => XFile('/tmp/gallery_photo.png'));
        when(() => mockUpdateProfilePhoto(any()))
            .thenAnswer((_) async => '/saved/gallery_photo.png');
        when(() => mockUpdateProfile(any())).thenAnswer((_) async {});
        return bloc;
      },
      seed: () => const ProfileState(
        status: ProfileStatus.loaded,
        profile: tProfile,
        completedTodoCount: 7,
      ),
      act: (bloc) => bloc.add(const PickPhotoFromGallery()),
      expect: () => [
        ProfileState(
          status: ProfileStatus.saved,
          profile: tProfile.copyWith(photoPath: '/saved/gallery_photo.png'),
          completedTodoCount: 7,
        ),
      ],
      verify: (_) {
        verify(() => mockImagePicker.pickImage(
              source: ImageSource.gallery,
              maxWidth: 512,
              maxHeight: 512,
              imageQuality: 80,
            )).called(1);
        verify(() => mockUpdateProfilePhoto('/tmp/gallery_photo.png'))
            .called(1);
        verify(() => mockUpdateProfile(any())).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits nothing when user cancels gallery picker (returns null)',
      build: () {
        when(() => mockImagePicker.pickImage(
              source: ImageSource.gallery,
              maxWidth: 512,
              maxHeight: 512,
              imageQuality: 80,
            )).thenAnswer((_) async => null);
        return bloc;
      },
      seed: () => const ProfileState(
        status: ProfileStatus.loaded,
        profile: tProfile,
      ),
      act: (bloc) => bloc.add(const PickPhotoFromGallery()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockUpdateProfilePhoto(any()));
        verifyNever(() => mockUpdateProfile(any()));
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits nothing when profile is null',
      build: () => bloc,
      seed: () => const ProfileState(status: ProfileStatus.initial),
      act: (bloc) => bloc.add(const PickPhotoFromGallery()),
      expect: () => [],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [error] when gallery picker throws',
      build: () {
        when(() => mockImagePicker.pickImage(
              source: ImageSource.gallery,
              maxWidth: 512,
              maxHeight: 512,
              imageQuality: 80,
            )).thenThrow(Exception('Gallery error'));
        return bloc;
      },
      seed: () => const ProfileState(
        status: ProfileStatus.loaded,
        profile: tProfile,
        completedTodoCount: 2,
      ),
      act: (bloc) => bloc.add(const PickPhotoFromGallery()),
      expect: () => [
        ProfileState(
          status: ProfileStatus.error,
          profile: tProfile,
          completedTodoCount: 2,
          errorMessage: Exception('Gallery error').toString(),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [error] when updateProfile throws after photo save',
      build: () {
        when(() => mockImagePicker.pickImage(
              source: ImageSource.gallery,
              maxWidth: 512,
              maxHeight: 512,
              imageQuality: 80,
            )).thenAnswer((_) async => XFile('/tmp/photo.jpg'));
        when(() => mockUpdateProfilePhoto(any()))
            .thenAnswer((_) async => '/saved/photo.jpg');
        when(() => mockUpdateProfile(any()))
            .thenThrow(Exception('Profile update failed'));
        return bloc;
      },
      seed: () => const ProfileState(
        status: ProfileStatus.loaded,
        profile: tProfile,
        completedTodoCount: 2,
      ),
      act: (bloc) => bloc.add(const PickPhotoFromGallery()),
      expect: () => [
        ProfileState(
          status: ProfileStatus.error,
          profile: tProfile,
          completedTodoCount: 2,
          errorMessage: Exception('Profile update failed').toString(),
        ),
      ],
    );
  });
}
