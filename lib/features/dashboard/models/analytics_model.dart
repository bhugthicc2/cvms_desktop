class AnalyticsModel {
  final String metric;
  final double value;
  final DateTime timestamp;

  AnalyticsModel({
    required this.metric,
    required this.value,
    required this.timestamp,
  });
}
