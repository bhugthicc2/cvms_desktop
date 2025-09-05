import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    required this.controller,
    this.onChanged,
    TextEditingController? searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        cursorColor: AppColors.primary,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          hintText: "Search...",
          hintStyle: TextStyle(fontSize: AppFontSizes.medium),
          suffixIcon: Icon(
            PhosphorIconsRegular.magnifyingGlass,
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }
}
