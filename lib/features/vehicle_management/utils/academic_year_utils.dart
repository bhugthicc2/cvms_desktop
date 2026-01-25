class AcademicYearUtils {
  static const int academicYearStartMonth = 6; // June

  static int currentStartYear({DateTime? now}) {
    final date = now ?? DateTime.now();
    return date.month < academicYearStartMonth ? date.year - 1 : date.year;
  }

  static String format(int startYear) {
    return '$startYear-${startYear + 1}';
  }

  static List<String> generate({
    int pastYears = 2,
    int futureYears = 3,
    DateTime? now,
  }) {
    final baseYear = currentStartYear(now: now);

    return List.generate(pastYears + futureYears + 1, (index) {
      final year = baseYear - pastYears + index;
      return format(year);
    });
  }

  static bool isValid(String value) {
    final match = RegExp(r'^(\d{4})-(\d{4})$').firstMatch(value);
    if (match == null) return false;

    final start = int.parse(match.group(1)!);
    final end = int.parse(match.group(2)!);

    return end == start + 1;
  }
}
