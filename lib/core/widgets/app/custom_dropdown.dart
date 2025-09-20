import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final double borderRadius;
  final double horizontalPadding;
  final Color? backgroundColor;
  final Color? color;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.initialValue,
    required this.onChanged,

    this.borderRadius = 5,
    this.horizontalPadding = 12,
    this.backgroundColor = AppColors.white,
    this.color = AppColors.black,
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
          padding: EdgeInsets.symmetric(horizontal: padding - 2),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
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
                            overflow: TextOverflow.ellipsis,
                            e,
                            style: TextStyle(
                              color: widget.color ?? AppColors.white,
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
