import 'package:flutter/material.dart';

import '../theme/palette.dart';
import 'ornaments.dart';

/// Arch, two hanging lamps and the logo, as on the home and "more" pages.
class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key, this.height = 200, this.logoWidth = 230});
  final double height, logoWidth;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
                painter: ArchPainter(p.gold.withValues(alpha: 0.45))),
          ),
          Positioned(
              left: 30, top: 8, child: HangingLamp(height: height * 0.62)),
          Positioned(
              right: 30, top: 8, child: HangingLamp(height: height * 0.62)),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: AppLogo(width: logoWidth),
          ),
        ],
      ),
    );
  }
}

/// Light and dark artwork; the dark one has gold lettering instead of brown.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      dark ? 'assets/images/logo_dark.png' : 'assets/images/logo_transparent.png',
      width: width,
    );
  }
}
