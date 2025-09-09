part of 'user_management_bloc.dart';

abstract class UserManagementState {
  const UserManagementState();
}

class UserManagementInitial extends UserManagementState {}

class UserManagementLoading extends UserManagementState {}

class UserManagementSuccess extends UserManagementState {
  final String message;
  final UserOperation operation;

  const UserManagementSuccess({required this.message, required this.operation});
}

class UserManagementError extends UserManagementState {
  final String message;

  const UserManagementError(this.message);
}

enum UserOperation { add, edit, delete, resetPassword }
