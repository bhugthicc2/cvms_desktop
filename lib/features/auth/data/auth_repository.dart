import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/error/firebase_error_handler.dart';

/// Repository for handling Firebase Authentication operations
/// Follows single responsibility principle - only auth operations
class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? get uid => _auth.currentUser?.uid;

  /// Sign in user with email and password
  /// Returns User object if successful, throws formatted error otherwise
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleAuthError(e));
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleAuthError(e));
    }
  }

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
