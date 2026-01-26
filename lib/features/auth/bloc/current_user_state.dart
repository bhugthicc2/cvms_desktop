part of 'current_user_cubit.dart';

class CurrentUserState {
  final bool isLoading;
  final String? fullname;
  final String? errorMessage;
  final String? profileImage;
  final String? currentUserId;

  const CurrentUserState({
    required this.isLoading,
    required this.fullname,
    required this.errorMessage,
    required this.currentUserId,
    this.profileImage,
  });

  factory CurrentUserState.initial() => const CurrentUserState(
    isLoading: false,
    fullname: null,
    errorMessage: null,
    currentUserId: null,
    profileImage: null,
  );

  CurrentUserState copyWith({
    bool? isLoading,
    String? fullname,
    String? errorMessage,
    String? currentUserId,
    String? profileImage,
  }) {
    return CurrentUserState(
      isLoading: isLoading ?? this.isLoading,
      fullname: fullname,
      errorMessage: errorMessage,
      currentUserId: currentUserId,
      profileImage: profileImage,
    );
  }
}
