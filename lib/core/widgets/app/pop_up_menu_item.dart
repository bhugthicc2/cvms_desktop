import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomPopupMenuItem extends PopupMenuEntry<String> {
  final IconData itemIcon;
  final String itemLabel;
  final String value;
  final Color? iconColor;
  final Color? textColor;

  const CustomPopupMenuItem({
    super.key,
    required this.itemIcon,
    required this.itemLabel,
    required this.value,
    this.iconColor,
    this.textColor,
  });

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(String? value) {
    return value == this.value;
  }

  @override
  State<StatefulWidget> createState() => _CustomPopupMenuItemState();

  Widget build(BuildContext context) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(itemIcon, size: 16, color: iconColor ?? AppColors.primary),
          const SizedBox(width: 8),
          Text(itemLabel, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}

class _CustomPopupMenuItemState extends State<CustomPopupMenuItem> {
  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }
}
