import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';

class OptionItem {
  final String label;
  final IconData icon;
  final String value;

  const OptionItem({
    required this.label,
    required this.icon,
    required this.value,
  });
}

enum SelectionMode { single, multiple }

class OptionSelectionWidget extends StatefulWidget {
  final String label;
  final List<OptionItem> options;
  final SelectionMode mode;
  final List<String>? initialValues;
  final int? maxSelections;
  final ValueChanged<List<String>>? onChanged;
  final double fontSize;
  final bool isRequired;

  const OptionSelectionWidget({
    super.key,
    required this.label,
    required this.options,
    this.mode = SelectionMode.single,
    this.initialValues,
    this.maxSelections,
    this.onChanged,
    this.fontSize = AppFontSizes.small,
    this.isRequired = false,
  });

  @override
  State<OptionSelectionWidget> createState() => _OptionSelectionWidgetState();
}

class _OptionSelectionWidgetState extends State<OptionSelectionWidget> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...?widget.initialValues};
  }

  void _toggle(String value) {
    setState(() {
      if (_selected.contains(value)) {
        _selected.remove(value);
      } else {
        if (widget.mode == SelectionMode.single) {
          _selected.clear();
        } else if (widget.maxSelections != null &&
            _selected.length >= widget.maxSelections!) {
          return;
        }
        _selected.add(value);
      }
    });

    widget.onChanged?.call(_selected.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            widget.isRequired
                ? Text(
                  " * ",
                  style: TextStyle(
                    fontSize: widget.fontSize + 2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                )
                : SizedBox.shrink(),
          ],
        ),
        Spacing.vertical(size: AppSpacing.small),
        Wrap(
          spacing: AppSpacing.medium,
          runSpacing: AppSpacing.medium,
          children:
              widget.options
                  .map(
                    (opt) => _OptionTile(
                      option: opt,
                      selected: _selected.contains(opt.value),
                      fontSize: widget.fontSize,
                      onTap: () => _toggle(opt.value),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final OptionItem option;
  final bool selected;
  final VoidCallback onTap;
  final double fontSize;

  const _OptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    return Semantics(
      button: true,
      selected: selected,
      label: option.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 120,
            height: 80,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? primary : primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? primary : primary.withValues(alpha: 0.3),
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Icon(
                    option.icon,
                    size: 24,
                    color: selected ? Colors.white : primary,
                  ),
                ),
                Spacing.vertical(size: AppSpacing.small),
                Flexible(
                  child: Text(
                    option.label.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSize * 0.9,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
