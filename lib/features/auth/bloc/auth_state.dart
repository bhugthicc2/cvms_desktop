abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class SignOutSuccess extends AuthState {}

class SilentSignOutSuccess extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final String userId;
  AuthSuccess(this.userId, this.message);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
