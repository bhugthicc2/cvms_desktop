import 'package:firebase_auth/firebase_auth.dart';

/// Centralized Firebase error handling utility
/// Provides consistent error messages and network error detection
class FirebaseErrorHandler {
  /// Handle Firebase Auth exceptions with user-friendly messages
  static String handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'network-request-failed':
          return 'Network connection failed. Please check your internet connection and try again.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment before trying again.';
        case 'user-not-found':
          return 'No account found with this email address.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'email-already-in-use':
          return 'An account with this email already exists.';
        case 'weak-password':
          return 'Password is too weak. Please choose a stronger password.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'operation-not-allowed':
          return 'This operation is not allowed. Please contact support.';
        case 'invalid-credential':
          return 'Invalid credentials. Please check your email and password.';
        default:
          return 'Authentication failed: ${error.message ?? 'Unknown error occurred'}';
      }
    }

    return _handleGenericError(error);
  }

  /// Handle Firestore exceptions with user-friendly messages
  static String handleFirestoreError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'unavailable':
          return 'Service temporarily unavailable. Please check your internet connection and try again.';
        case 'deadline-exceeded':
          return 'Request timed out. Please check your internet connection and try again.';
        case 'permission-denied':
          return 'Access denied. You don\'t have permission to perform this action.';
        case 'not-found':
          return 'The requested data was not found.';
        case 'already-exists':
          return 'This data already exists.';
        case 'resource-exhausted':
          return 'Service quota exceeded. Please try again later.';
        case 'failed-precondition':
          return 'Operation failed due to current system state.';
        case 'aborted':
          return 'Operation was aborted due to a conflict. Please try again.';
        case 'out-of-range':
          return 'Invalid data range provided.';
        case 'unimplemented':
          return 'This feature is not yet implemented.';
        case 'internal':
          return 'Internal server error. Please try again later.';
        case 'data-loss':
          return 'Data corruption detected. Please contact support.';
        case 'unauthenticated':
          return 'Authentication required. Please sign in again.';
        default:
          return 'Database error: ${error.message ?? 'Unknown error occurred'}';
      }
    }

    return _handleGenericError(error);
  }

  /// Handle generic errors including network issues
  static String _handleGenericError(dynamic error) {
    final errorMessage = error.toString().toLowerCase();

    // Check for common network-related errors
    if (errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('unreachable') ||
        errorMessage.contains('no internet') ||
        errorMessage.contains('offline')) {
      return 'Network connection failed. Please check your internet connection and try again.';
    }

    if (errorMessage.contains('socket') || errorMessage.contains('host')) {
      return 'Unable to connect to server. Please check your internet connection.';
    }

    // Default error message
    return 'An unexpected error occurred. Please try again later.';
  }

  /// Check if error is network-related
  static bool isNetworkError(dynamic error) {
    if (error is FirebaseException) {
      return error.code == 'unavailable' ||
          error.code == 'deadline-exceeded' ||
          error.code == 'network-request-failed';
    }

    final errorMessage = error.toString().toLowerCase();
    return errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('unreachable') ||
        errorMessage.contains('offline');
  }

  /// Get appropriate retry message for network errors
  static String getRetryMessage() {
    return 'Please check your internet connection and try again.';
  }
}
