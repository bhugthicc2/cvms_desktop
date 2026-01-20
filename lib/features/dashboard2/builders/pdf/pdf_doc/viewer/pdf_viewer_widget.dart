import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';

class PdfViewerWidget extends StatefulWidget {
  final Uint8List pdfBytes;

  const PdfViewerWidget({super.key, required this.pdfBytes});

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  final PdfViewerController _controller = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return PdfViewer.data(
      widget.pdfBytes,
      sourceName: 'pdf_viewer',
      controller: _controller,
      params: PdfViewerParams(
        backgroundColor: AppColors.greySurface,
        pageDropShadow: BoxShadow(
          color: AppColors.grey,
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 2),
        ),
        viewerOverlayBuilder:
            (context, size, handleLinkTap) => [
              // Add vertical scroll thumb on viewer's right side
              PdfViewerScrollThumb(
                controller: _controller,
                orientation: ScrollbarOrientation.right,
                thumbSize: const Size(40, 25),
                thumbBuilder:
                    (context, thumbSize, pageNumber, controller) => Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // Show page number on the thumb
                      child: Center(
                        child: Text(
                          pageNumber.toString(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              ),
            ],
      ),
    );
  }
}
