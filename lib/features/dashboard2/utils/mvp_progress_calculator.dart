import 'package:flutter/foundation.dart';

/// Utility class for calculating MVP (Motor Vehicle Pass) progress
class MvpProgressCalculator {
  /// Calculates the progress percentage of MVP validity
  ///
  /// [registeredDate] - The date when the MVP was registered
  /// [expiryDate] - The date when the MVP expires
  /// [currentDate] - Optional current date (defaults to DateTime.now())
  ///
  /// Returns a double between 0.0 and 1.0 representing the progress
  /// Returns 0.0 if dates are invalid or in the future
  /// Returns 1.0 if current date is on or after expiry date
  static double calculateProgress({
    required DateTime? registeredDate,
    required DateTime? expiryDate,
    DateTime? currentDate,
  }) {
    // Handle null dates
    if (registeredDate == null || expiryDate == null) {
      return 0.0;
    }

    // Ensure expiry date is after registered date
    if (expiryDate.isBefore(registeredDate)) {
      debugPrint('Warning: Expiry date is before registered date');
      return 0.0;
    }

    final now = currentDate ?? DateTime.now();

    // If current date is before registered date, no progress yet
    if (now.isBefore(registeredDate)) {
      return 0.0;
    }

    // If current date is on or after expiry date, progress is complete
    if (now.isAfter(expiryDate) || now.isAtSameMomentAs(expiryDate)) {
      return 1.0;
    }

    // Calculate progress
    final totalDuration = expiryDate.difference(registeredDate);
    final elapsedDuration = now.difference(registeredDate);

    final progress =
        elapsedDuration.inMilliseconds / totalDuration.inMilliseconds;

    // Clamp between 0.0 and 1.0 for safety
    return progress.clamp(0.0, 1.0);
  }

  /// Calculates the remaining days until MVP expiry
  ///
  /// Returns the number of days remaining, or 0 if expired or invalid
  static int calculateRemainingDays({
    required DateTime? expiryDate,
    DateTime? currentDate,
  }) {
    if (expiryDate == null) return 0;

    final now = currentDate ?? DateTime.now();
    final difference = expiryDate.difference(now);

    return difference.inDays.clamp(0, difference.inDays);
  }

  /// Determines the MVP status based on dates
  ///
  /// Returns 'Active', 'Expired', or 'Not Started'
  static String getMvpStatus({
    required DateTime? registeredDate,
    required DateTime? expiryDate,
    DateTime? currentDate,
  }) {
    if (registeredDate == null || expiryDate == null) {
      return 'Not Set';
    }

    final now = currentDate ?? DateTime.now();

    if (now.isBefore(registeredDate)) {
      return 'Not Started';
    } else if (now.isAfter(expiryDate) || now.isAtSameMomentAs(expiryDate)) {
      return 'Expired';
    } else {
      return 'Valid';
    }
  }

  /// Gets the appropriate color based on progress percentage and expiry status
  ///
  /// [progress] - Progress value between 0.0 and 1.0
  /// [registeredDate] - Registration date to check status
  /// [expiryDate] - Expiry date to check status
  /// [currentDate] - Optional current date (defaults to DateTime.now())
  /// Returns color name as string for mapping to actual colors
  static String getProgressColor({
    required double progress,
    DateTime? registeredDate,
    DateTime? expiryDate,
    DateTime? currentDate,
  }) {
    // Check if expired first
    if (registeredDate != null && expiryDate != null) {
      final now = currentDate ?? DateTime.now();
      if (now.isAfter(expiryDate) || now.isAtSameMomentAs(expiryDate)) {
        return 'red'; // Expired - always red
      }
    }

    // Normal progress-based coloring for active MVPs
    if (progress <= 0.3) return 'orange'; // Warning - orange
    if (progress <= 0.6) return 'blue'; // Good - blue
    return 'blue'; // Safe - blue
  }
}
