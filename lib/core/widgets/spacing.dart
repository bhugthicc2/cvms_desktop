import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class Spacing extends StatelessWidget {
  final double? height;
  final double? width;
  final bool useMediumSpacing;

  const Spacing({
    super.key,
    this.height,
    this.width,
    this.useMediumSpacing = false,
  });

  const Spacing.vertical({super.key, double? size})
    : height = size ?? AppSpacing.medium,
      width = null,
      useMediumSpacing = size == null;

  const Spacing.horizontal({super.key, double? size})
    : height = null,
      width = size ?? AppSpacing.medium,
      useMediumSpacing = size == null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? (useMediumSpacing ? AppSpacing.medium : null),
      width: width,
    );
  }
}
