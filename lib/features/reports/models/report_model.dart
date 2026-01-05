class ReportModel {
  final String id;
  final String title;
  final Map<String, dynamic> payload;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.title,
    required this.payload,
    required this.createdAt,
  });
}
