import '../datasources/profile_local_data_source.dart';
import '../models/profile_model.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final String appDocumentsPath;

  ProfileRepositoryImpl({
    required this.localDataSource,
    required this.appDocumentsPath,
  });

  @override
  Future<UserProfile> getProfile() => localDataSource.getProfile();

  @override
  Future<void> updateProfile(UserProfile profile) {
    final model = ProfileModel.fromEntity(profile);
    return localDataSource.updateProfile(model);
  }

  @override
  Future<String> saveProfilePhoto(String sourcePath) =>
      localDataSource.savePhoto(sourcePath, appDocumentsPath);
}
