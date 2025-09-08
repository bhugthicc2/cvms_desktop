import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIllustration extends StatelessWidget {
  final String path;
  const CustomIllustration({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(path, width: 240, height: 240);
  }
}
