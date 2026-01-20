import 'package:pdf/widgets.dart' as pw;

class PdfBrandingConfig {
  final String department;
  final String republicText;
  final String universityText;
  final String taglineText;
  final String campusText;
  final String registrationText;

  final pw.ImageProvider institutionLogo;
  final pw.ImageProvider isoLogo;
  final pw.ImageProvider isoCertifiedLogo;
  final pw.ImageProvider aacupLogo;

  final String homeText;
  final String email;
  final String phone;

  final pw.ImageProvider homeIcon;
  final pw.ImageProvider mailIcon;
  final pw.ImageProvider phoneIcon;

  const PdfBrandingConfig({
    required this.department,
    required this.republicText,
    required this.universityText,
    required this.taglineText,
    required this.campusText,
    required this.registrationText,
    required this.institutionLogo,
    required this.isoLogo,
    required this.isoCertifiedLogo,
    required this.aacupLogo,
    required this.homeText,
    required this.email,
    required this.phone,
    required this.homeIcon,
    required this.mailIcon,
    required this.phoneIcon,
  });
}
