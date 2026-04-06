import 'package:profile_feature_domain/profile_feature_domain.dart';

class ProfileModel extends UserProfile {
  const ProfileModel({
    super.id,
    required super.firstName,
    required super.lastName,
    super.photoPath,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as int?,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      photoPath: map['photo_path'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'photo_path': photoPath,
    };
  }

  factory ProfileModel.fromEntity(UserProfile profile) {
    return ProfileModel(
      id: profile.id,
      firstName: profile.firstName,
      lastName: profile.lastName,
      photoPath: profile.photoPath,
    );
  }
}
