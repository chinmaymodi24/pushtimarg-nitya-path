import 'package:flutter/material.dart';

/// Shared timings so every screen moves the same way.
abstract class Motion {
  static const fast = Duration(milliseconds: 180);
  static const medium = Duration(milliseconds: 320);
  static const curve = Curves.easeOutCubic;
}

/// Fades a child in while it rises a few pixels. [index] staggers items
/// in a list; it plays once, when the widget first appears.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({super.key, required this.child, this.index = 0});
  final Widget child;
  final int index;

  static const _step = 45; // ms between items
  static const _maxDelayItems = 8;

  @override
  Widget build(BuildContext context) {
    final delay = _step * index.clamp(0, _maxDelayItems);
    final total = Motion.medium.inMilliseconds + delay;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Interval(delay / total, 1, curve: Motion.curve),
      builder: (_, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - t)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

/// A rounded progress bar that glides to each new value.
class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.value,
    required this.color,
    required this.background,
    this.height = 5,
  });

  final double value;
  final Color color, background;
  final double height;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 450),
      curve: Motion.curve,
      builder: (_, v, _) => ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: LinearProgressIndicator(
          value: v,
          minHeight: height,
          backgroundColor: background,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    );
  }
}
