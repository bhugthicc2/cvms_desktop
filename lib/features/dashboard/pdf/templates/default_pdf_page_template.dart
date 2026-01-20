import 'package:cvms_desktop/features/dashboard/pdf/components/letter_head/doc_footer.dart';
import 'package:cvms_desktop/features/dashboard/pdf/components/letter_head/doc_header.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/pdf_branding_config.dart';
import 'pdf_page_template.dart';

class DefaultPdfPageTemplate implements PdfPageTemplate {
  final PdfBrandingConfig branding;
  final PdfPageFormat pageFormat;
  final pw.EdgeInsets wholePagemargin;

  const DefaultPdfPageTemplate({
    required this.branding,
    this.pageFormat = PdfPageFormat.legal,
    this.wholePagemargin = pw.EdgeInsets.zero,
  });

  @override
  pw.PageTheme get theme {
    return pw.PageTheme(pageFormat: pageFormat, margin: wholePagemargin);
  }

  @override
  pw.Widget header(pw.Context context) {
    return DocHeader(
      department: branding.department,
      republicText: branding.republicText,
      universityText: branding.universityText,
      taglineText: branding.taglineText,
      campusText: branding.campusText,
      registrationText: branding.registrationText,
      institutionLogo: branding.institutionLogo,
      isoLogo: branding.isoLogo,
    );
  }

  @override
  pw.Widget footer(pw.Context context) {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        DocFooter(
          isoCertifiedLogo: branding.isoCertifiedLogo,
          aacupLogo: branding.aacupLogo,
          homeText: branding.homeText,
          email: branding.email,
          phone: branding.phone,
          homeIcon: branding.homeIcon,
          mailIcon: branding.mailIcon,
          phoneIcon: branding.phoneIcon,
        ),
      ],
    );
  }
}
