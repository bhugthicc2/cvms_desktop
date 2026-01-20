import 'dart:typed_data';

abstract class PdfExportUseCase {
  Future<Uint8List> export();
}
