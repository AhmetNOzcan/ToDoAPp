import 'package:equatable/equatable.dart';
import 'package:profile_feature_domain/profile_feature_domain.dart';

enum ProfileStatus { initial, loading, loaded, saved, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfile? profile;
  final int completedTodoCount;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.completedTodoCount = 0,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    int? completedTodoCount,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      completedTodoCount: completedTodoCount ?? this.completedTodoCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, completedTodoCount, errorMessage];
}
