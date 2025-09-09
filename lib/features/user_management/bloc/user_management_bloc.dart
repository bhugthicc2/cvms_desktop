import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/user_repository.dart';

part 'user_management_event.dart';
part 'user_management_state.dart';

class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  UserManagementBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository,
       super(UserManagementInitial()) {
    on<AddUserRequested>(_onAddUserRequested);
    on<EditUserRequested>(_onEditUserRequested);
    on<DeleteUserRequested>(_onDeleteUserRequested);
    on<ResetUserPasswordRequested>(_onResetUserPasswordRequested);
  }

  Future<void> _onAddUserRequested(
    AddUserRequested event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(UserManagementLoading());

    try {
      if (event.password != event.confirmPassword) {
        emit(const UserManagementError('Passwords do not match'));
        return;
      }

      if (event.password.length < 6) {
        emit(
          const UserManagementError('Password must be at least 6 characters'),
        );
        return;
      }

      final user = await _authRepository.signUp(event.email, event.password);

      if (user == null) {
        emit(const UserManagementError('Failed to create user account'));
        return;
      }

      await _userRepository.createUserProfile(
        uid: user.uid,
        fullname: event.fullname,
        email: event.email,
        password: event.password,
        role: event.role,
        status: 'inactive',
      );

      emit(
        UserManagementSuccess(
          message: 'User "${event.fullname}" has been successfully created',
          operation: UserOperation.add,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email is already registered';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak';
          break;
        default:
          errorMessage = 'Authentication error: ${e.message}';
      }
      emit(UserManagementError(errorMessage));
    } catch (e) {
      emit(UserManagementError('Failed to create user: ${e.toString()}'));
    }
  }

  Future<void> _onEditUserRequested(
    EditUserRequested event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(UserManagementLoading());

    try {
      await _userRepository.updateUserProfile(event.uid, {
        'fullname': event.fullname,
        'email': event.email,
        'role': event.role,
      });

      emit(
        UserManagementSuccess(
          message: 'User "${event.fullname}" has been successfully updated',
          operation: UserOperation.edit,
        ),
      );
    } catch (e) {
      emit(UserManagementError('Failed to update user: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteUserRequested(
    DeleteUserRequested event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(UserManagementLoading());

    try {
      await _userRepository.deleteUserProfile(event.uid);

      emit(
        UserManagementSuccess(
          message: 'User has been successfully deleted',
          operation: UserOperation.delete,
        ),
      );
    } catch (e) {
      emit(UserManagementError('Failed to delete user: ${e.toString()}'));
    }
  }

  Future<void> _onResetUserPasswordRequested(
    ResetUserPasswordRequested event,
    Emitter<UserManagementState> emit,
  ) async {
    emit(UserManagementLoading());

    try {
      await _authRepository.resetPassword(event.email);

      emit(
        UserManagementSuccess(
          message: 'Password reset email sent to ${event.email}',
          operation: UserOperation.resetPassword,
        ),
      );
    } catch (e) {
      emit(
        UserManagementError(
          'Failed to send password reset email: ${e.toString()}',
        ),
      );
    }
  }
}
