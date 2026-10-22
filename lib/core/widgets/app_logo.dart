import 'package:flutter/material.dart';

/// Light and dark artwork; the dark one has gold lettering instead of brown.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      dark
          ? 'assets/images/logo_dark.png'
          : 'assets/images/logo_transparent.png',
      width: width,
    );
  }
}
