import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final double contentPaddingX;
  final double contentPaddingY;
  final double cursorHeight;
  final double hintFontSize;
  final double txtFontSize;
  final double searchFieldHeight;
  final double searchFieldWidth;
  final double hoverScale;

  const SearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = "Search name, plate number, etc...",
    TextEditingController? searchController,
    this.contentPaddingX = 10,
    this.contentPaddingY = 0,
    this.cursorHeight = 20,
    this.hintFontSize = AppFontSizes.medium,
    this.txtFontSize = AppFontSizes.medium,
    this.searchFieldHeight = 0,
    this.searchFieldWidth = 0,
    this.hoverScale = 1.02,
  });

  @override
  Widget build(BuildContext context) {
    return HoverGrow(
      hoverScale: hoverScale,
      child: Container(
        width: searchFieldWidth,
        height: searchFieldHeight,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          style: TextStyle(fontSize: txtFontSize),
          cursorHeight: cursorHeight,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: AppColors.primary,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            maintainHintHeight: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey, width: 1),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: hintFontSize, color: AppColors.grey),
            contentPadding: EdgeInsets.symmetric(
              horizontal: contentPaddingX,
              vertical: contentPaddingY,
            ),
            suffixIcon: Icon(
              PhosphorIconsRegular.magnifyingGlass,
              size: 20,
              color: AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
