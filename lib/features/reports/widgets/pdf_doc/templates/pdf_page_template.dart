import 'package:cvms_desktop/features/reports/widgets/pdf_doc/letter_head/doc_footer.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/letter_head/doc_header.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Reusable PDF Page Template with consistent header and footer
/// This follows SRP by separating page layout from content
class PdfPageTemplate {
  const PdfPageTemplate({
    this.pageFormat = PdfPageFormat.legal,
    this.margin = pw.EdgeInsets.zero,
    this.department = 'CDRRMS Unit',
    this.republicText = 'REPUBLIC OF THE PHILIPPINES',
    this.universityText = 'JOSE RIZAL MEMORIAL STATE UNIVERSITY',
    this.taglineText = 'The Premier University in Zamboanga del Norte',
    this.campusText = 'Katipunan Campus, Katipunan, Zamboanga del Norte',
    this.registrationText = 'Registration No. 621082',
    this.institutionLog = 'jrmsu-logo',
    this.isoLogo = 'iso',
    this.isoCertifiedLogo = 'iso_certified_logo',
    this.aacupLogo = 'aaccup_logo',
    this.homeText = 'Barangay Dos, Katipunan, Zamboanga del Norte Philippines',
    this.email = 'cdrrsmukatipunan@jrmsu.edu.ph',
    this.phone = '(062) 333-2222',
    this.homeIcon = 'home_icon',
    this.mailIcon = 'mail_icon',
    this.phoneIcon = 'call_icon',
  });

  final PdfPageFormat pageFormat;
  final pw.EdgeInsets margin;
  final String department;
  final String republicText;
  final String universityText;
  final String taglineText;
  final String campusText;
  final String registrationText;
  final String institutionLog;
  final String isoLogo;
  final String isoCertifiedLogo;
  final String aacupLogo;
  final String homeText;
  final String email;
  final String phone;
  final String homeIcon;
  final String mailIcon;
  final String phoneIcon;

  pw.Page build({required pw.Widget child}) {
    return pw.Page(
      pageTheme: pw.PageTheme(pageFormat: pageFormat, margin: margin),
      build:
          (context) => pw.Column(
            children: [
              // Consistent Header
              DocHeader(
                department: department,
                republicText: republicText,
                universityText: universityText,
                taglineText: taglineText,
                campusText: campusText,
                registrationText: registrationText,
                institutionLog: institutionLog,
                isoLogo: isoLogo,
              ),

              // Content Area
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 53,
                    vertical: 10,
                  ),
                  child: child,
                ),
              ),

              // Consistent Footer
              DocFooter(
                isoCertifiedLogo: isoCertifiedLogo,
                aacupLogo: aacupLogo,
                homeText: homeText,
                email: email,
                phone: phone,
                homeIcon: homeIcon,
                mailIcon: mailIcon,
                phoneIcon: phoneIcon,
              ),
            ],
          ),
    );
  }
}
