import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocFooter extends pw.StatelessWidget {
  DocFooter({
    required this.isoCertifiedLogo,
    required this.aacupLogo,
    required this.homeText,
    required this.email,
    required this.phone,
    required this.homeIcon,
    required this.mailIcon,
    required this.phoneIcon,
  });

  final pw.ImageProvider isoCertifiedLogo;
  final pw.ImageProvider aacupLogo;
  final String homeText;
  final String email;
  final String phone;
  final pw.ImageProvider homeIcon;
  final pw.ImageProvider mailIcon;
  final pw.ImageProvider phoneIcon;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      children: [
        pw.Image(
          height: 5,
          pw.MemoryImage(
            File('assets/images/footer_line.png').readAsBytesSync(),
          ),
        ),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 53),
          decoration: pw.BoxDecoration(color: PdfColors.white),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Row(
                children: [
                  pw.Image(height: 50, isoCertifiedLogo),
                  pw.SizedBox(width: 10),
                  pw.Image(height: 50, aacupLogo),
                  pw.SizedBox(width: 10),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      //home row
                      pw.Row(
                        children: [
                          pw.Image(height: 12, homeIcon),
                          pw.SizedBox(width: 5),
                          pw.Text(homeText, style: pw.TextStyle(fontSize: 7)),
                        ],
                      ),
                      //mail row
                      pw.Row(
                        children: [
                          pw.Image(height: 12, mailIcon),
                          pw.SizedBox(width: 5),
                          pw.Text(email, style: pw.TextStyle(fontSize: 7)),
                        ],
                      ),
                      //call row
                      pw.Row(
                        children: [
                          pw.Image(height: 12, phoneIcon),
                          pw.SizedBox(width: 5),
                          pw.Text(phone, style: pw.TextStyle(fontSize: 7)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              pw.Image(
                height: 75,
                pw.MemoryImage(
                  File(
                    'assets/images/bagong_pilipinas_logo.png',
                  ).readAsBytesSync(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
