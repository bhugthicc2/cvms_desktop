abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  SignInEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullname;
  SignUpEvent(this.email, this.password, this.fullname);
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  ResetPasswordEvent(this.email);
}

class SignOutEvent extends AuthEvent {}

class SilentSignOutEvent extends AuthEvent {}
