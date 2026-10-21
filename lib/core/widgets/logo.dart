import 'package:flutter/material.dart';

/// The supplied logo has a lot of empty margin; crop to the artwork.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.width = 230});
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ClipRect(
        child: Align(
          alignment: const Alignment(0, 0.35),
          heightFactor: 0.55,
          widthFactor: 0.9,
          child: Image.asset('assets/images/logo.png', width: width / 0.9),
        ),
      ),
    );
  }
}
