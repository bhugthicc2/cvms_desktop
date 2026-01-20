import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfTable extends pw.StatelessWidget {
  PdfTable({
    required this.headers,
    required this.rows,
    this.columnWidths,
    this.borderColor = PdfColors.grey300,
    this.headerColor = PdfColors.grey100,
    this.headerFontSize = 11,
    this.headerFontWeight = pw.FontWeight.bold,
    this.rowFontSize = 11,
    this.cellPadding = 5,
  });

  final List<String> headers;
  final List<List<String>> rows;
  final Map<int, pw.TableColumnWidth>? columnWidths;
  final PdfColor borderColor;
  final PdfColor headerColor;
  final double headerFontSize;
  final pw.FontWeight headerFontWeight;
  final double rowFontSize;
  final double cellPadding;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Table(
      border: pw.TableBorder.all(color: borderColor),
      columnWidths: columnWidths ?? _getDefaultColumnWidths(),
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: headerColor),
          children:
              headers.map((header) {
                return pw.Padding(
                  padding: pw.EdgeInsets.all(cellPadding),
                  child: pw.Text(
                    header,
                    style: pw.TextStyle(
                      fontSize: headerFontSize,
                      fontWeight: headerFontWeight,
                    ),
                  ),
                );
              }).toList(),
        ),
        // Data rows
        ...rows.map((row) {
          return pw.TableRow(
            children:
                row.map((cell) {
                  return pw.Padding(
                    padding: pw.EdgeInsets.all(cellPadding),
                    child: pw.Text(
                      cell,
                      style: pw.TextStyle(fontSize: rowFontSize),
                    ),
                  );
                }).toList(),
          );
        }),
      ],
    );
  }

  Map<int, pw.TableColumnWidth> _getDefaultColumnWidths() {
    return {
      for (var index in List.generate(headers.length, (index) => index))
        index: pw.FlexColumnWidth(1),
    };
  }
}
