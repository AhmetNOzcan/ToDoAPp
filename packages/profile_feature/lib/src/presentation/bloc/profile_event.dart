import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfileRequested extends ProfileEvent {
  final String firstName;
  final String lastName;

  const UpdateProfileRequested({
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [firstName, lastName];
}

class PickPhotoFromCamera extends ProfileEvent {
  const PickPhotoFromCamera();
}

class PickPhotoFromGallery extends ProfileEvent {
  const PickPhotoFromGallery();
}
