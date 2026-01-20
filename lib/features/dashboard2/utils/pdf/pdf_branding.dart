class PdfBranding {
  final String title;
  final String department;
  final String? logoAssetPath;

  const PdfBranding({
    required this.title,
    required this.department,
    this.logoAssetPath,
  });
}
