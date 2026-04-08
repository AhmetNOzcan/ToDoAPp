import 'package:injectable/injectable.dart';

import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@injectable
class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<UserProfile> call() => repository.getProfile();
}
