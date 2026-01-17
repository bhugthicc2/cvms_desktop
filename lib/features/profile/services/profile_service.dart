import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'dart:convert';

class ProfileService {
  static Future<void> pickAndUploadImage({
    required BuildContext context,
    required Function(String) onImageSelected,
  }) async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'Images',
        extensions: ['jpg', 'jpeg', 'png', 'webp'],
        mimeTypes: ['image/jpeg', 'image/png', 'image/webp'],
      );

      final XFile? file = await openFile(
        acceptedTypeGroups: [typeGroup],
        initialDirectory: null,
      );

      if (file != null) {
        final bytes = await file.readAsBytes();
        final base64String = base64Encode(bytes);

        // Update the profile image in Firestore
        onImageSelected(base64String);

        // Show success message
        if (context.mounted) {
          CustomSnackBar.show(
            context: context,
            message: 'Profile image updated successfully',
            type: SnackBarType.success,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(
          context: context,
          message: 'Failed to update profile image: $e',
          type: SnackBarType.error,
        );
      }
    }
  }
}

class TimestampFormatter {
  static String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';

    // Handle Firestore Timestamp object
    if (timestamp is Timestamp) {
      final dateTime = timestamp.toDate();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    }

    // Handle Map format (for backward compatibility)
    if (timestamp is Map<String, dynamic>) {
      final seconds = timestamp['_seconds'] as int?;
      final nanoseconds = timestamp['_nanoseconds'] as int?;

      if (seconds == null) return 'Unknown';

      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        seconds * 1000 + (nanoseconds ?? 0) ~/ 1000000,
      );

      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    }

    return 'Unknown';
  }
}
