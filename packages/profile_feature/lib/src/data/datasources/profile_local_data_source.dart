import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
  Future<void> updateProfile(ProfileModel profile);
  Future<String> savePhoto(String sourcePath, String destinationDir);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final Database database;

  ProfileLocalDataSourceImpl({required this.database});

  @override
  Future<ProfileModel> getProfile() async {
    final maps = await database.query('user_profile', limit: 1);
    if (maps.isEmpty) {
      return const ProfileModel(
        id: 1,
        firstName: '',
        lastName: '',
      );
    }
    return ProfileModel.fromMap(maps.first);
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    await database.update(
      'user_profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  @override
  Future<String> savePhoto(String sourcePath, String destinationDir) async {
    final fileName =
        'profile_${DateTime.now().millisecondsSinceEpoch}${p.extension(sourcePath)}';
    final destinationPath = p.join(destinationDir, fileName);
    final sourceFile = File(sourcePath);
    await sourceFile.copy(destinationPath);
    return destinationPath;
  }
}
