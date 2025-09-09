part of 'user_management_bloc.dart';

abstract class UserManagementEvent {
  const UserManagementEvent();
}

class AddUserRequested extends UserManagementEvent {
  final String fullname;
  final String email;
  final String role;
  final String password;
  final String confirmPassword;

  const AddUserRequested({
    required this.fullname,
    required this.email,
    required this.role,
    required this.password,
    required this.confirmPassword,
  });
}

class EditUserRequested extends UserManagementEvent {
  final String uid;
  final String fullname;
  final String email;
  final String role;

  const EditUserRequested({
    required this.uid,
    required this.fullname,
    required this.email,
    required this.role,
  });
}

class DeleteUserRequested extends UserManagementEvent {
  final String uid;
  final String fullname;

  const DeleteUserRequested({required this.uid, required this.fullname});
}

class ResetUserPasswordRequested extends UserManagementEvent {
  final String email;

  const ResetUserPasswordRequested({required this.email});
}
