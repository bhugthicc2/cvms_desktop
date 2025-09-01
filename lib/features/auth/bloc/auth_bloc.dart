import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/logger.dart';
import '../services/firebase_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseService _firebaseService = FirebaseService();

  AuthBloc() : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _firebaseService.signIn(event.email, event.password);
        if (user != null) {
          emit(AuthSuccess(user.uid));
        } else {
          emit(AuthError('Login failed'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        Logger.log('Auth error: $e');
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _firebaseService.signUp(
          event.email,
          event.password,
          event.fullname,
        );
        if (user != null) {
          emit(AuthSuccess(user.uid));
        } else {
          Logger.log('Sign up failed');
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        Logger.log('Auth error: $e');
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _firebaseService.resetPassword(event.email);
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
  }
}
