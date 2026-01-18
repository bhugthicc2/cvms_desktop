import 'package:flutter/material.dart';

class PdfEditorWidget extends StatefulWidget {
  const PdfEditorWidget({super.key});

  @override
  State<PdfEditorWidget> createState() => _PdfEditorWidgetState();
}

class _PdfEditorWidgetState extends State<PdfEditorWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("PDF Editor Content"));
  }
}
