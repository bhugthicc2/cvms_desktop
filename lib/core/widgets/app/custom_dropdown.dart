import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final double borderRadius;
  final double horizontalPadding;
  final Color? backgroundColor;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.initialValue,
    required this.onChanged,

    this.borderRadius = 5,
    this.horizontalPadding = 12,
    this.backgroundColor = AppColors.primary,
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

        final fontSize =
            isSmall
                ? 12.0
                : isMedium
                ? 14.0
                : 16.0;

        final iconSize =
            isSmall
                ? 16.0
                : isMedium
                ? 18.0
                : 20.0;

        final padding = isSmall ? 8.0 : widget.horizontalPadding;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: padding),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(5),
              value: selected,
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.white,
                size: iconSize,
              ),
              dropdownColor: widget.backgroundColor,
              style: TextStyle(
                color: AppColors.grey,
                fontFamily: 'Sora',
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
              ),
              items:
                  widget.items
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: fontSize,
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
        );
      },
    );
  }
}
