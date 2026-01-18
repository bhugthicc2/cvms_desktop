import 'package:cvms_desktop/features/dashboard/widgets/buttons/custom_view_button.dart';
import 'package:flutter/material.dart';

class ReportTableHeader extends StatelessWidget {
  final String tableTitle;
  final VoidCallback onTap;
  const ReportTableHeader({
    super.key,
    required this.tableTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          tableTitle,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        CustomViewButton(onTap: onTap),
      ],
    );
  }
}
