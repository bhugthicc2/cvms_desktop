import 'package:flutter/material.dart';

class ViolationDebugHelper {
  static void logDialogLifecycle(String stage, {Map<String, dynamic>? data}) {
    debugPrint('=== VIOLATION DEBUG: $stage ===');
    if (data != null) {
      data.forEach((key, value) {
        debugPrint('  $key: $value');
      });
    }
  }

  static void logError(String stage, dynamic error, StackTrace? stackTrace) {
    debugPrint('=== VIOLATION ERROR: $stage ===');
    debugPrint('Error: $error');
    debugPrint('Type: ${error.runtimeType}');
    if (stackTrace != null) {
      debugPrint('Stack Trace: $stackTrace');
    }
  }

  static void showDebugDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('DEBUG: $title'),
            content: SingleChildScrollView(child: Text(content)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  static void checkContext(BuildContext context, String location) {
    debugPrint('=== CONTEXT CHECK: $location ===');
    debugPrint('Context mounted: ${context.mounted}');
    debugPrint('Widget mounted: ${context.owner?.debugBuilding ?? false}');
  }
}
