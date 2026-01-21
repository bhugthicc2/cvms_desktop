part of 'current_user_cubit.dart';

class CurrentUserState {
  final bool isLoading;
  final String? fullname;
  final String? errorMessage;
  final String? profileImage;

  const CurrentUserState({
    required this.isLoading,
    required this.fullname,
    required this.errorMessage,
    this.profileImage,
  });

  factory CurrentUserState.initial() => const CurrentUserState(
    isLoading: false,
    fullname: null,
    errorMessage: null,
    profileImage: null,
  );

  CurrentUserState copyWith({
    bool? isLoading,
    String? fullname,
    String? errorMessage,
    String? profileImage,
  }) {
    return CurrentUserState(
      isLoading: isLoading ?? this.isLoading,
      fullname: fullname,
      errorMessage: errorMessage,
      profileImage: profileImage,
    );
  }
}
