import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// Gold paisley curls for the reading page corners.
class CornerFlourishPainter extends CustomPainter {
  CornerFlourishPainter(this.color, {this.top = 0});
  final Color color;

  /// Starts below the page header so the curls never sit under its buttons.
  final double top;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    void corner() {
      canvas.drawPath(
        Path()
          ..moveTo(0, 96)
          ..cubicTo(4, 46, 30, 14, 92, 4),
        p,
      );
      canvas.drawPath(
        Path()
          ..moveTo(6, 70)
          ..cubicTo(14, 40, 34, 26, 56, 26)
          ..cubicTo(70, 26, 72, 44, 60, 46)
          ..cubicTo(52, 47, 50, 38, 56, 36),
        p,
      );
      canvas.drawPath(
        Path()
          ..moveTo(24, 10)
          ..cubicTo(30, 24, 24, 34, 16, 34)
          ..cubicTo(8, 34, 8, 24, 14, 24),
        p,
      );
      for (var i = 0; i < 4; i++) {
        canvas.drawCircle(
          Offset(100.0 + i * 9, 4 + i * 0.6),
          1.3,
          Paint()..color = color,
        );
      }
    }

    canvas.save();
    canvas.translate(0, top);
    corner();
    canvas.restore();
    canvas.save();
    canvas.translate(size.width, top);
    canvas.scale(-1, 1);
    corner();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CornerFlourishPainter old) =>
      old.color != color || old.top != top;
}

/// ─── ✣ ─── divider between verse and meaning.
class OrnamentDivider extends StatelessWidget {
  const OrnamentDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final gold = context.pal.gold;
    Widget line(bool left) => Expanded(
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gold.withValues(alpha: left ? 0 : 0.9),
              gold.withValues(alpha: left ? 0.9 : 0),
            ],
          ),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 48),
      child: Row(
        children: [
          line(true),
          CustomPaint(size: const Size(34, 14), painter: _MotifPainter(gold)),
          line(false),
        ],
      ),
    );
  }
}

class _MotifPainter extends CustomPainter {
  _MotifPainter(this.c);
  final Color c;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final f = Paint()..color = c;
    for (var i = 0; i < 4; i++) {
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(i * math.pi / 2);
      canvas.drawOval(Rect.fromLTWH(-1.8, -6.5, 3.6, 6), f);
      canvas.restore();
    }
    canvas.drawCircle(Offset(cx - 11, cy), 1.4, f);
    canvas.drawCircle(Offset(cx + 11, cy), 1.4, f);
    canvas.drawCircle(Offset(cx - 15.5, cy), 0.9, f);
    canvas.drawCircle(Offset(cx + 15.5, cy), 0.9, f);
  }

  @override
  bool shouldRepaint(_MotifPainter old) => old.c != c;
}
