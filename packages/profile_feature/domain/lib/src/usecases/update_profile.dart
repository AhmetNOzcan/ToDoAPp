import 'package:injectable/injectable.dart';

import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<void> call(UserProfile profile) => repository.updateProfile(profile);
}
