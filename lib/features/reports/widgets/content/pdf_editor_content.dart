import 'package:flutter/material.dart';

class PdfEditorContent extends StatefulWidget {
  const PdfEditorContent({super.key});

  @override
  State<PdfEditorContent> createState() => _PdfEditorContentState();
}

class _PdfEditorContentState extends State<PdfEditorContent> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("PDF Editor Content"));
  }
}
