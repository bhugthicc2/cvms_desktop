class DepartmentFormatter {
  String formatDepartment(String raw) {
    switch (raw) {
      case 'CCS':
        return 'College of Computing Studies';
      case 'CBA':
        return 'College of Business Administration';
      case 'CAF-SOE':
        return 'College of Agriculture, Forestry and School of Engineering';
      case 'LHS':
        return 'Laboratory High School';
      case 'CTED':
        return 'College of Teacher Education';
      case 'SCJE':
        return 'School of Criminal Justice Education';
      default:
        return raw;
    }
  }
}
