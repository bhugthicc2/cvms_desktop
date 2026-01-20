enum ReportScope { global, individual }

class ReportContext {
  final ReportScope scope;
  final String? vehicleId; // required for individual
  final DateTime start;
  final DateTime end;

  const ReportContext.global({required this.start, required this.end})
    : scope = ReportScope.global,
      vehicleId = null;

  const ReportContext.individual({
    required this.vehicleId,
    required this.start,
    required this.end,
  }) : scope = ReportScope.individual;
}
