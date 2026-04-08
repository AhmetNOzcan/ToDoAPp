import 'package:injectable/injectable.dart';
import 'package:profile_feature_domain/profile_feature_domain.dart';

import '../datasources/profile_local_data_source.dart';
import '../models/profile_model.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  final String appDocumentsPath;

  ProfileRepositoryImpl({
    required this.localDataSource,
    @Named('appDocumentsPath') required this.appDocumentsPath,
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
