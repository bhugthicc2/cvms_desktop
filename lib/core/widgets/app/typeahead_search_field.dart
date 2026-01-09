import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TypeaheadSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSuggestionSelected;
  final Future<List<String>> Function(String) suggestionsCallback;
  final String hintText;
  final double contentPaddingX;
  final double contentPaddingY;
  final double cursorHeight;
  final double hintFontSize;
  final double txtFontSize;
  final double searchFieldHeight;
  final double searchFieldWidth;
  final double hoverScale;

  const TypeaheadSearchField({
    super.key,
    required this.controller,
    required this.suggestionsCallback,
    this.onChanged,
    this.onSuggestionSelected,
    this.hintText = "Search name, plate number, etc...",
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
          borderRadius: BorderRadius.circular(8),
        ),
        child: TypeAheadField<String>(
          controller: controller,
          suggestionsCallback: suggestionsCallback,
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              style: TextStyle(fontSize: txtFontSize),
              cursorHeight: cursorHeight,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: AppColors.primary,
              onChanged: onChanged,
              decoration: InputDecoration(
                maintainHintHeight: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.grey.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: hintFontSize,
                  color: AppColors.grey,
                ),
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
            );
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
              leading: Icon(
                PhosphorIconsRegular.magnifyingGlass,
                size: 16,
                color: AppColors.grey,
              ),
            );
          },
          onSelected: onSuggestionSelected,
          emptyBuilder: (context) {
            return ListTile(
              title: Text(
                'No results found',
                style: TextStyle(color: AppColors.grey),
              ),
              leading: Icon(
                PhosphorIconsRegular.magnifyingGlass,
                size: 16,
                color: AppColors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}
