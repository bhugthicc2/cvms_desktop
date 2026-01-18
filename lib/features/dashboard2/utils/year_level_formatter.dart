class YearLevelFormatter {
  String formatYearLevel(String raw) {
    switch (raw) {
      case '1st':
        return '1st Year';
      case '2nd':
        return '2nd Year';
      case '3rd':
        return '3rd Year';
      case '4th':
        return '4th Year';
      default:
        return raw;
    }
  }
}
