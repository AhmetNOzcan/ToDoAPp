import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final int? id;
  final String firstName;
  final String lastName;
  final String? photoPath;

  const UserProfile({
    this.id,
    required this.firstName,
    required this.lastName,
    this.photoPath,
  });

  UserProfile copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? photoPath,
    bool clearPhoto = false,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props => [id, firstName, lastName, photoPath];
}
