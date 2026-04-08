import 'package:injectable/injectable.dart';

import '../repositories/profile_repository.dart';

@injectable
class UpdateProfilePhoto {
  final ProfileRepository repository;

  UpdateProfilePhoto(this.repository);

  Future<String> call(String sourcePath) =>
      repository.saveProfilePhoto(sourcePath);
}
