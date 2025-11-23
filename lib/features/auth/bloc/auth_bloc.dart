import 'package:cvms_desktop/features/auth/services/auth_persistence.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/logger.dart';
import '../../../core/error/firebase_error_handler.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();

  AuthBloc() : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.signIn(event.email, event.password);
        if (user != null) {
          // Get user profile to check role
          final userProfile = await _userRepository.getUserProfile(user.uid);

          // Validate user role - only cdrrmsu admin can sign in
          if (userProfile == null || userProfile['role'] != 'cdrrmsu admin') {
            // Sign out the user immediately
            await _authRepository.signOut();
            emit(
              AuthError(
                'Access denied. Only CDRRMSU Admin accounts can sign in.',
              ),
            );
            return;
          }

          // Update user status in Firestore
          await _userRepository.updateLoginStatus(user.uid);

          final keepLoggedIn = await AuthPersistence.getKeepLoggedIn();
          if (keepLoggedIn) {
            await AuthPersistence.saveUserSession(user);
          }
          emit(AuthSuccess(user.uid, 'Login successful'));
        } else {
          emit(AuthError('Login failed'));
        }
      } catch (e) {
        final errorMessage =
            e.toString().contains('Exception: ')
                ? e.toString().replaceFirst('Exception: ', '')
                : FirebaseErrorHandler.handleAuthError(e);

        emit(AuthError(errorMessage));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authRepository.signUp(event.email, event.password);
        if (user != null) {
          // Create user profile in Firestore
          await _userRepository.createUserProfile(
            uid: user.uid,
            fullname: event.fullname,
            email: event.email,
            password: event.password,
          );
        }
        if (user != null) {
          emit(AuthSuccess(user.uid, 'Sign up successful'));
        } else {
          Logger.log('Sign up failed');
          emit(AuthError('Sign up failed'));
        }
      } catch (e) {
        final errorMessage =
            e.toString().contains('Exception: ')
                ? e.toString().replaceFirst('Exception: ', '')
                : FirebaseErrorHandler.handleAuthError(e);

        emit(AuthError(errorMessage));
        Logger.log('Auth error: $e');
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.resetPassword(event.email);
        emit(ResetPasswordSuccess());
      } catch (e) {
        final errorMessage =
            e.toString().contains('Exception: ')
                ? e.toString().replaceFirst('Exception: ', '')
                : FirebaseErrorHandler.handleAuthError(e);

        emit(AuthError(errorMessage));
        Logger.log('Password reset error: $e');
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      // Update user status to inactive before signing out
      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        await _userRepository.updateUserStatus(currentUser.uid, 'inactive');
      }

      await _authRepository.signOut();
      await AuthPersistence.clear();
      emit(SignOutSuccess());
      Logger.log('User signed out successfully - all data cleared');
    });

    on<SilentSignOutEvent>((event, emit) async {
      emit(AuthLoading());

      await _authRepository.signOut();
      await AuthPersistence.clear();
      emit(SilentSignOutSuccess());
      Logger.log('Silent signout completed');
    });
  }
}
