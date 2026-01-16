import 'dart:async';
import 'package:flutter/widgets.dart';

class NavigationGuard {
  static final NavigationGuard _instance = NavigationGuard._internal();
  factory NavigationGuard() => _instance;
  NavigationGuard._internal();

  bool _hasUnsavedChanges = false;
  Completer<bool>? _navigationCompleter;
  VoidCallback? _showDialogCallback;

  /// Register that there are unsaved changes
  void registerUnsavedChanges({VoidCallback? showDialogCallback}) {
    _hasUnsavedChanges = true;
    _showDialogCallback = showDialogCallback;
  }

  /// Unregister unsaved changes (when saved or discarded)
  void unregisterUnsavedChanges() {
    _hasUnsavedChanges = false;
    _showDialogCallback = null;
    // Complete any pending navigation with true
    if (_navigationCompleter != null && !_navigationCompleter!.isCompleted) {
      _navigationCompleter!.complete(true);
      _navigationCompleter = null;
    }
  }

  /// Check if there are unsaved changes and show dialog if needed
  /// Returns true if navigation should proceed, false if cancelled
  Future<bool> checkUnsavedChanges() async {
    if (_hasUnsavedChanges) {
      _navigationCompleter = Completer<bool>();

      // Show dialog if callback is available
      if (_showDialogCallback != null) {
        _showDialogCallback!();
      }

      return _navigationCompleter!.future;
    }
    return true;
  }

  /// Call this when user confirms they want to leave despite unsaved changes
  void confirmNavigation() {
    if (_navigationCompleter != null && !_navigationCompleter!.isCompleted) {
      _navigationCompleter!.complete(true);
      _navigationCompleter = null;
    }
  }

  /// Call this when user cancels navigation
  void cancelNavigation() {
    if (_navigationCompleter != null && !_navigationCompleter!.isCompleted) {
      _navigationCompleter!.complete(false);
      _navigationCompleter = null;
    }
  }

  /// Get current state
  bool get hasUnsavedChanges => _hasUnsavedChanges;
}
