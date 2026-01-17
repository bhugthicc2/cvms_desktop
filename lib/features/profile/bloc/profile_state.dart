part of 'profile_cubit.dart';

class ProfileState {
  final bool isLoading;
  final Map<String, dynamic>? userData;
  final String? errorMessage;

  const ProfileState({
    required this.isLoading,
    required this.userData,
    required this.errorMessage,
  });

  factory ProfileState.initial() =>
      const ProfileState(isLoading: false, userData: null, errorMessage: null);

  ProfileState copyWith({
    bool? isLoading,
    Map<String, dynamic>? userData,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      userData: userData ?? this.userData,
      errorMessage: errorMessage,
    );
  }
}
