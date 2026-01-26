import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final double borderRadius;
  final double horizontalPadding;
  final Color? backgroundColor;
  final Color? color;
  final double verticalPadding;
  final double fontSize;
  final bool addPadding;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.initialValue,
    required this.onChanged,
    this.borderRadius = 5,
    this.horizontalPadding = 12,
    this.backgroundColor = AppColors.white,
    this.color = AppColors.black,
    this.verticalPadding = 12,
    this.fontSize = AppFontSizes.medium,
    this.addPadding = false,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive scale based on width
        final width = constraints.maxWidth;
        final isSmall = width < 300;
        final isMedium = width >= 300 && width < 600;

        final iconSize =
            isSmall
                ? 16.0
                : isMedium
                ? 18.0
                : 20.0;

        final padding = isSmall ? 8.0 : widget.horizontalPadding;

        return HoverSlide(
          dx: 0,
          dy: -0.1,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: padding - 2,
              vertical: widget.verticalPadding,
            ),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                padding: EdgeInsets.zero,
                isDense: true,
                borderRadius: BorderRadius.circular(5),
                value: selected,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: widget.color ?? AppColors.white,
                  size: iconSize,
                ),
                dropdownColor: widget.backgroundColor,
                style: TextStyle(
                  color: AppColors.grey,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize,
                ),
                items:
                    widget.items
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child:
                                widget.addPadding
                                    ? Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: widget.verticalPadding,
                                      ),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        e,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.color ?? AppColors.grey,
                                          fontSize: widget.fontSize,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    )
                                    : Text(
                                      overflow: TextOverflow.ellipsis,
                                      e,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: widget.color ?? AppColors.grey,
                                        fontSize: widget.fontSize,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selected = value);
                    widget.onChanged(value);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
