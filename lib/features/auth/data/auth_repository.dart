//ACTIVITY LOG 2

import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/error/firebase_error_handler.dart';
import '../../../core/services/activity_log_service.dart';

/// Repository for handling Firebase Authentication operations
/// Follows single responsibility principle - only auth operations
class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ActivityLogService _logger = ActivityLogService();
  String? get uid => _auth.currentUser?.uid;

  /// Sign in user with email and password
  /// Returns User object if successful, throws formatted error otherwise
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Log user login
      await _logger.logUserLogin(userCredential.user?.uid);

      return userCredential.user;
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleAuthError(e));
    }
  }

  /// Create new user account with email and password
  /// Returns User object if successful, throws formatted error otherwise
  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleAuthError(e));
    }
  }

  /// Send password reset email to user
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      // Log password reset
      await _logger.logPasswordReset('current', email);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleAuthError(e));
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      final userId = _auth.currentUser?.uid;
      await _auth.signOut();

      // Log user logout
      await _logger.logUserLogout(userId);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleAuthError(e));
    }
  }

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
