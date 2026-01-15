import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class CustDropDown<T> extends StatefulWidget {
  final List<CustDropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final String hintText;
  final double borderRadius;
  final double maxListHeight;
  final double borderWidth;
  final int defaultSelectedIndex;
  final bool enabled;
  final bool isRequired; // New: For asterisk
  final double fontSize; // New: Match text field
  final IconData? prefixIcon; // New: Optional prefix like text field
  final Color borderColor; // New: Match text field

  const CustDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    this.hintText = "",
    this.borderRadius = 5.0, // Match text field default
    this.borderWidth = 1,
    this.maxListHeight = 200.0, // Slightly taller for desktop
    this.defaultSelectedIndex = -1,
    this.enabled = true,
    this.isRequired = true,
    this.fontSize = AppFontSizes.small, // Match text field
    this.prefixIcon,
    this.borderColor = AppColors.primary, // Match text field
  });

  @override
  CustDropDownState<T> createState() => CustDropDownState<T>();
}

class CustDropDownState<T> extends State<CustDropDown<T>>
    with WidgetsBindingObserver {
  bool _isOpen = false;
  bool _isAnyItemSelected = false;
  bool _isReverse = false;
  OverlayEntry? _overlayEntry;
  RenderBox? _renderBox;
  Widget? _itemSelected;
  T? _selectedValue; // Track selected value
  late Offset dropDownOffset;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          dropDownOffset = getOffset();
        });
        if (widget.defaultSelectedIndex > -1 &&
            widget.defaultSelectedIndex < widget.items.length) {
          if (mounted) {
            final defaultItem = widget.items[widget.defaultSelectedIndex];
            setState(() {
              _isAnyItemSelected = true;
              _itemSelected = defaultItem.child;
              _selectedValue = defaultItem.value;
            });
            widget.onChanged(defaultItem.value);
          }
        }
      }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void _addOverlay() {
    if (mounted) {
      setState(() {
        _isOpen = true;
      });
    }
    _overlayEntry = _createOverlayEntry();
    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    _renderBox = context.findRenderObject() as RenderBox?;
    var size = _renderBox!.size;
    dropDownOffset = getOffset();

    return OverlayEntry(
      maintainState: false,
      builder:
          (context) => GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _removeOverlay();
            },
            child: Material(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.topLeft,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: dropDownOffset,
                  child: SizedBox(
                    width: size.width,
                    // Remove fixed height; let content drive with max constraint
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Shrink to fit content
                      mainAxisAlignment:
                          _isReverse
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: <Widget>[
                        // Conditional padding: top for down, bottom for up
                        Padding(
                          padding: EdgeInsets.only(
                            top: _isReverse ? 0 : 4.0, // Reduced from 10
                            bottom: _isReverse ? 4.0 : 0,
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: widget.maxListHeight,
                              maxWidth: size.width,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(
                                widget.borderRadius,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(widget.borderRadius),
                              ),
                              clipBehavior: Clip.hardEdge, // Clip overflow
                              child: Material(
                                color: AppColors.white,
                                elevation: 0,
                                shadowColor: AppColors.primary,
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap:
                                      true, // Keep for min size, but parent clips
                                  physics:
                                      const ClampingScrollPhysics(), // Smooth scroll
                                  itemCount: widget.items.length,
                                  separatorBuilder:
                                      (context, index) => Divider(
                                        color: AppColors.greySurface,
                                        height: 1,
                                      ),
                                  itemBuilder: (context, index) {
                                    final item = widget.items[index];
                                    final isSelected =
                                        _selectedValue == item.value;
                                    return GestureDetector(
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            _isAnyItemSelected = true;
                                            _itemSelected = item.child;
                                            _selectedValue = item.value;
                                            _removeOverlay();
                                          });
                                          widget.onChanged(item.value);
                                        }
                                      },
                                      child: Container(
                                        color:
                                            isSelected
                                                ? widget.borderColor.withValues(
                                                  alpha: 0.1,
                                                )
                                                : Colors.transparent,
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            if (widget.prefixIcon != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: Icon(
                                                  widget.prefixIcon,
                                                  color: Colors.grey,
                                                  size: widget.fontSize + 4,
                                                ),
                                              ),
                                            // Wrap child in Flexible to prevent horizontal overflow
                                            Flexible(
                                              child: DefaultTextStyle(
                                                style: TextStyle(
                                                  fontSize: widget.fontSize,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.black
                                                      .withValues(alpha: 0.9),
                                                ),
                                                child: item.child,
                                              ),
                                            ),
                                            if (isSelected)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  color: widget.borderColor,
                                                  size: 20,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Offset getOffset() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    double y = renderBox!.localToGlobal(Offset.zero).dy;
    double spaceAvailable = _getAvailableSpace(y + renderBox.size.height);
    if (spaceAvailable > widget.maxListHeight) {
      _isReverse = false;
      return Offset(0, renderBox.size.height);
    } else {
      _isReverse = true;
      // Adjust offset to account for dynamic menu height approximation
      final approxMenuHeight = (widget.items.length * 48.0).clamp(
        0.0,
        widget.maxListHeight,
      );
      return Offset(0, -approxMenuHeight);
    }
  }

  double _getAvailableSpace(double offsetY) {
    final mediaQuery = MediaQuery.of(context);
    double safePaddingTop = mediaQuery.padding.top;
    double safePaddingBottom = mediaQuery.padding.bottom;
    double screenHeight =
        mediaQuery.size.height - safePaddingBottom - safePaddingTop;
    return screenHeight - offsetY;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with asterisk (match text field)
          Row(
            children: [
              Text(
                widget.hintText, // Reuse hintText as label for consistency
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black.withValues(alpha: 0.9),
                ),
              ),
              if (widget.isRequired)
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
          // Dropdown trigger (match text field UI)
          GestureDetector(
            onTap:
                widget.enabled
                    ? () {
                      _isOpen ? _removeOverlay() : _addOverlay();
                    }
                    : null,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 14.0, // Fixed to 14 for consistency
              ),
              decoration: BoxDecoration(
                color: AppColors.white, // Match fillColor
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border(
                  top:
                      _isOpen
                          ? BorderSide(color: widget.borderColor, width: 2.0)
                          : BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                  bottom:
                      _isOpen
                          ? BorderSide(color: widget.borderColor, width: 2.0)
                          : BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                  left:
                      _isOpen
                          ? BorderSide(color: widget.borderColor, width: 2.0)
                          : BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                  right:
                      _isOpen
                          ? BorderSide(color: widget.borderColor, width: 2.0)
                          : BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                ),
                boxShadow:
                    _isOpen
                        ? [
                          BoxShadow(
                            color: widget.borderColor.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Row(
                children: [
                  // Prefix icon (match text field)
                  if (widget.prefixIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        widget.prefixIcon,
                        color: Colors.grey,
                        size: widget.fontSize + 4,
                      ),
                    ),
                  // Selected or hint text (match text field style)
                  Expanded(
                    child:
                        _isAnyItemSelected
                            ? DefaultTextStyle(
                              style: TextStyle(
                                fontSize: widget.fontSize,
                                fontFamily: 'Poppins',
                                fontWeight:
                                    FontWeight
                                        .w500, // Slightly less bold like text field
                                color: AppColors.black.withValues(alpha: 0.9),
                              ),
                              child: _itemSelected!,
                            )
                            : Text(
                              widget.hintText,
                              style: TextStyle(
                                fontSize: widget.fontSize,
                                fontFamily: 'Poppins',
                                color: Colors.grey.withValues(
                                  alpha: 0.6,
                                ), // Match labelStyle
                              ),
                            ),
                  ),
                  // Dropdown arrow
                  Icon(
                    _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: widget.fontSize + 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustDropdownMenuItem<T> extends StatelessWidget {
  final T value;
  final Widget child;
  const CustDropdownMenuItem({
    super.key,
    required this.value,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: AppFontSizes.small,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          color: AppColors.black,
        ),
        child: child,
      ),
    ); // Apply consistent style and Flexible to prevent overflow
  }
}
