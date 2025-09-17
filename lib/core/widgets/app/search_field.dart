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
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        cursorHeight: 20,
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
          hintText: "Search name, plate number, etc...",

          hintStyle: TextStyle(
            fontSize: AppFontSizes.medium,
            fontFamily: 'Sora',
            color: AppColors.grey,
          ),

          suffixIcon: Icon(
            PhosphorIconsRegular.magnifyingGlass,
            size: 20,
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }
}
