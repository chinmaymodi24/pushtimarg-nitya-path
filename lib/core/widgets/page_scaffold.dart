import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// Warm paper gradient behind every page.
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.body,
    this.bottom,
    this.decoration,
  });

  final Widget body;
  final Widget? bottom;

  /// Optional painter drawn behind the content (arch, corner flourishes).
  final CustomPainter? decoration;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [p.bgTop, p.bgBottom],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: bottom,
        body: CustomPaint(
          painter: decoration,
          child: SafeArea(bottom: false, child: body),
        ),
      ),
    );
  }
}
