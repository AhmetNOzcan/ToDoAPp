import '../repositories/profile_repository.dart';

class UpdateProfilePhoto {
  final ProfileRepository repository;

  UpdateProfilePhoto(this.repository);

  Future<String> call(String sourcePath) =>
      repository.saveProfilePhoto(sourcePath);
}
