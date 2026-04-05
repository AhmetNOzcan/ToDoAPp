import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/update_profile_photo.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final UpdateProfilePhoto updateProfilePhoto;
  final TodoStatsProvider todoStatsProvider;
  final ImagePicker imagePicker;

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
    required this.updateProfilePhoto,
    required this.todoStatsProvider,
    required this.imagePicker,
  }) : super(const ProfileState()) {
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
      final profile = await getProfile();
      final completedCount = await todoStatsProvider.getCompletedTodoCount();
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
      await updateProfile(updated);
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
      final pickedFile = await imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (pickedFile == null) return;

      final savedPath = await updateProfilePhoto(pickedFile.path);
      final updated = current.copyWith(photoPath: savedPath);
      await updateProfile(updated);
      emit(state.copyWith(status: ProfileStatus.saved, profile: updated));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
