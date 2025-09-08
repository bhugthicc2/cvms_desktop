import 'package:cvms_desktop/features/auth/services/auth_persistence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/logger.dart';
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
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No account found with this email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'Authentication failed. Please try again.';
        }
        emit(AuthError(errorMessage));
      } catch (e) {
        emit(AuthError('Unexpected error: ${e.toString()}'));
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
        emit(AuthError(e.toString()));
        Logger.log('Auth error: $e');
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.resetPassword(event.email);
        emit(ResetPasswordSuccess());
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No account found with this email.';
            break;
          case 'invalid-email':
            errorMessage = 'Please enter a valid email address.';
            break;
          default:
            errorMessage = 'An error occurred. Please try again.';
        }
        emit(AuthError(errorMessage));
        Logger.log('Password reset error: $e');
      } catch (e) {
        emit(AuthError('An unexpected error occurred.'));
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
  }
}
