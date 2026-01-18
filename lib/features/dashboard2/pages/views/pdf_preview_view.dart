import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class PdfPreviewView extends StatelessWidget {
  const PdfPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PDF Report Preview',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.large),
          // Placeholder for PDF preview content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('PDF Preview Content')),
            ),
          ),
        ],
      ),
    );
  }
}
