import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';

class PdfSaveService {
  Future<String?> savePdf({
    required Uint8List pdfBytes,
    required String suggestedFileName,
  }) async {
    final path = await getSaveLocation(
      suggestedName: suggestedFileName,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'PDF', extensions: ['pdf']),
      ],
    );

    if (path == null) return null; // user cancelled

    final file = XFile.fromData(
      pdfBytes,
      name: suggestedFileName,
      mimeType: 'application/pdf',
    );

    await file.saveTo(path.path);
    return path.path;
  }
}
