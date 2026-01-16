import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class CustomTextField2 extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool obscureText;
  final IconData? prefixIcon;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsets padding;
  final double fontSize;
  final String hintTxt;

  const CustomTextField2({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.errorText,
    this.obscureText = false,
    this.prefixIcon,
    this.borderColor = Colors.blue,
    this.borderRadius = 5.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.fontSize = AppFontSizes.small,
    this.hintTxt = '',
  });

  @override
  State<CustomTextField2> createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  String? _currentErrorText;
  bool _hasUserInteracted = false;

  @override
  void initState() {
    super.initState();
    _currentErrorText = widget.errorText;

    // Add listener to clear errors when user types
    widget.controller?.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_currentErrorText != null &&
        widget.controller?.text.isNotEmpty == true) {
      setState(() {
        _currentErrorText = null;
      });
    }
  }

  @override
  void didUpdateWidget(CustomTextField2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update error text only if it's different and user hasn't interacted
    if (widget.errorText != oldWidget.errorText && !_hasUserInteracted) {
      setState(() {
        _currentErrorText = widget.errorText;
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.black.withValues(alpha: 0.9),
              ),
            ),
            Text(
              " * ",
              style: TextStyle(
                fontSize: widget.fontSize + 2,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        Spacing.vertical(size: AppSpacing.small),
        TextFormField(
          cursorRadius: Radius.circular(5),
          cursorColor: AppColors.primary,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
          ),
          controller: widget.controller,
          onChanged: (value) {
            if (!_hasUserInteracted) {
              setState(() {
                _hasUserInteracted = true;
              });
            }
            widget.onChanged?.call(value);
          },
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            hintText: widget.hintTxt,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: widget.hintTxt,
            hintStyle: TextStyle(color: Colors.grey, fontSize: widget.fontSize),
            labelStyle: TextStyle(
              color: Colors.grey,
              fontSize: widget.fontSize,
            ),
            prefixIcon:
                widget.prefixIcon != null
                    ? Icon(widget.prefixIcon, color: Colors.grey)
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: 2.0),
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
          ),
        ),
        if (_currentErrorText != null) ...[
          Spacing.vertical(size: AppSpacing.xSmall),
          Text(
            _currentErrorText!,
            style: TextStyle(
              fontSize: widget.fontSize - 2,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }
}
