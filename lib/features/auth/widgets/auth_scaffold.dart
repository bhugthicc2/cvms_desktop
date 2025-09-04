import 'package:cvms_desktop/features/auth/widgets/auth_window_titlebar.dart';
import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  const AuthScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/bg.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar,
          body: Center(child: child),
        ),
        AuthWindowTitlebar(),
      ],
    );
  }
}
