import '../constants/registration_policy.dart';

class RegistrationExpiryUtils {
  /// Computes expiry date from registration date
  static DateTime computeExpiryDate(DateTime createdAt) {
    return createdAt.add(const Duration(days: kTempRegistrationValidityDays));
  }

  /// Computes remaining days (never negative)
  static int computeDaysUntilExpiry(DateTime createdAt) {
    final expiryDate = computeExpiryDate(createdAt);
    final remaining = expiryDate.difference(DateTime.now()).inDays;
    return remaining < 0 ? 0 : remaining;
  }
}
