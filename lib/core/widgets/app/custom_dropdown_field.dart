import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomDropdownField<T> extends StatefulWidget {
  final T? value;
  final List<DropdownItem<T>> items;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final EdgeInsets? contentPadding;
  final bool isExpanded;

  const CustomDropdownField({
    super.key,
    this.value,
    required this.items,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.onChanged,
    this.enabled = true,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.textStyle,
    this.width,
    this.height = 55,
    this.contentPadding,
    this.isExpanded = true,
  });

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final borderColor =
        _focusNode.hasFocus
            ? (widget.focusedBorderColor ?? AppColors.primary)
            : (widget.borderColor ?? AppColors.grey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          padding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: borderColor, width: 1),
            color: widget.fillColor ?? AppColors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: widget.value,
              hint:
                  widget.hintText != null
                      ? Text(
                        widget.hintText!,
                        style: const TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey,
                          fontSize: AppFontSizes.medium,
                        ),
                      )
                      : null,
              isExpanded: widget.isExpanded,
              isDense: true,
              focusNode: _focusNode,
              icon: Icon(
                PhosphorIconsFill.caretDown,
                color: AppColors.grey,
                size: 20,
              ),
              style:
                  widget.textStyle ??
                  const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                    fontSize: AppFontSizes.medium,
                  ),
              dropdownColor: AppColors.white,
              items:
                  widget.items.map((item) {
                    return DropdownMenuItem<T>(
                      value: item.value,
                      child: Row(
                        children: [
                          if (item.icon != null) ...[
                            Icon(item.icon, color: AppColors.grey, size: 18),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              item.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                                fontSize: AppFontSizes.medium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged:
                  widget.enabled
                      ? (T? newValue) {
                        widget.onChanged?.call(newValue);
                      }
                      : null,
            ),
          ),
        ),
      ],
    );
  }
}

class DropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const DropdownItem({required this.value, required this.label, this.icon});
}
