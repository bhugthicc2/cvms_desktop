part of 'current_user_cubit.dart';

class CurrentUserState {
  final bool isLoading;
  final String? fullname;
  final String? errorMessage;

  const CurrentUserState({
    required this.isLoading,
    required this.fullname,
    required this.errorMessage,
  });

  factory CurrentUserState.initial() => const CurrentUserState(
        isLoading: false,
        fullname: null,
        errorMessage: null,
      );

  CurrentUserState copyWith({
    bool? isLoading,
    String? fullname,
    String? errorMessage,
  }) {
    return CurrentUserState(
      isLoading: isLoading ?? this.isLoading,
      fullname: fullname,
      errorMessage: errorMessage,
    );
  }
}
