import 'package:flutter/material.dart';
import '../error/firebase_error_handler.dart';
import '../widgets/app/custom_snackbar.dart';

class UIErrorHandler {
  static void handleError(
    BuildContext context,
    String errorMessage, {
    VoidCallback? onRetry,
  }) {
    final isNetworkError = _isNetworkErrorMessage(errorMessage);

    if (isNetworkError) {
      CustomSnackBar.showNetworkError(context, onRetry: onRetry);
    } else {
      CustomSnackBar.showError(context, errorMessage);
    }
  }

  static void handleSuccess(BuildContext context, String message) {
    CustomSnackBar.showSuccess(context, message);
  }

  static void handleWarning(BuildContext context, String message) {
    CustomSnackBar.showWarning(context, message);
  }

  static void handleInfo(BuildContext context, String message) {
    CustomSnackBar.showInfo(context, message);
  }

  static bool _isNetworkErrorMessage(String errorMessage) {
    final message = errorMessage.toLowerCase();

    return message.contains('network connection failed') ||
        message.contains('check your internet connection') ||
        message.contains('service temporarily unavailable') ||
        message.contains('request timed out') ||
        message.contains('connection') ||
        message.contains('network') ||
        message.contains('timeout') ||
        message.contains('unavailable') ||
        message.contains('deadline-exceeded') ||
        message.contains('unreachable') ||
        message.contains('offline');
  }

  static void showLoadingWithNetworkAwareness(
    BuildContext context,
    String operation,
  ) {}

  static void handleFirebaseError(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
  }) {
    String errorMessage;

    if (error.toString().contains('Exception: ')) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
    } else {
      errorMessage = FirebaseErrorHandler.handleFirestoreError(error);
    }

    handleError(context, errorMessage, onRetry: onRetry);
  }

  static void handleAuthError(
    BuildContext context,
    dynamic error, {
    VoidCallback? onRetry,
  }) {
    String errorMessage;

    if (error.toString().contains('Exception: ')) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
    } else {
      errorMessage = FirebaseErrorHandler.handleAuthError(error);
    }

    handleError(context, errorMessage, onRetry: onRetry);
  }
}
