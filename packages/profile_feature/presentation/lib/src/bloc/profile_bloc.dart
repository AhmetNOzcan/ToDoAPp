import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_feature/todo_feature.dart';

import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/update_profile_photo.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final UpdateProfilePhoto _updateProfilePhoto;
  final TodoStatsProvider _todoStatsProvider;
  final ImagePicker _imagePicker;

  ProfileBloc({
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
    required UpdateProfilePhoto updateProfilePhoto,
    required TodoStatsProvider todoStatsProvider,
    required ImagePicker imagePicker,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        _updateProfilePhoto = updateProfilePhoto,
        _todoStatsProvider = todoStatsProvider,
        _imagePicker = imagePicker,
        super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileRequested>(_onUpdateProfile);
    on<PickPhotoFromCamera>(_onPickPhotoFromCamera);
    on<PickPhotoFromGallery>(_onPickPhotoFromGallery);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profile = await _getProfile();
      final completedCount = await _todoStatsProvider.getCompletedTodoCount();
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
        completedTodoCount: completedCount,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final current = state.profile;
    if (current == null) return;

    try {
      final updated = current.copyWith(
        firstName: event.firstName,
        lastName: event.lastName,
      );
      await _updateProfile(updated);
      emit(state.copyWith(status: ProfileStatus.saved, profile: updated));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPickPhotoFromCamera(
    PickPhotoFromCamera event,
    Emitter<ProfileState> emit,
  ) async {
    await _pickPhoto(ImageSource.camera, emit);
  }

  Future<void> _onPickPhotoFromGallery(
    PickPhotoFromGallery event,
    Emitter<ProfileState> emit,
  ) async {
    await _pickPhoto(ImageSource.gallery, emit);
  }

  Future<void> _pickPhoto(
    ImageSource source,
    Emitter<ProfileState> emit,
  ) async {
    final current = state.profile;
    if (current == null) return;

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (pickedFile == null) return;

      final savedPath = await _updateProfilePhoto(pickedFile.path);
      final updated = current.copyWith(photoPath: savedPath);
      await _updateProfile(updated);
      emit(state.copyWith(status: ProfileStatus.saved, profile: updated));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
