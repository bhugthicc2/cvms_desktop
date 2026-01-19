class DynamicTitleFormatter {
  String getDynamicTitle(String baseTitle, String? currentTimeRange) {
    if (currentTimeRange == null) return baseTitle;

    switch (currentTimeRange) {
      case '7 days':
        return '$baseTitle for the last';
      case '30 days':
        return '$baseTitle for the last';
      case 'Month':
        return '$baseTitle this';
      case 'Year':
        return '$baseTitle this ';
      case 'Custom':
        return baseTitle;
      default:
        return baseTitle;
    }
  }
}
