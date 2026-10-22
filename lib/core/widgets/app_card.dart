import 'package:flutter/material.dart';

import '../theme/palette.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.radius = 14,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding, margin;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final r = BorderRadius.circular(radius);
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: r,
        border: Border.all(color: p.cardBorder),
        boxShadow: [
          BoxShadow(
            color: p.shadow,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: r,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
