import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// Thin double-line temple arch drawn behind page headers.
class ArchPainter extends CustomPainter {
  ArchPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    for (final inset in [10.0, 16.0]) {
      final top = inset + 2;
      final path = Path()
        ..moveTo(inset, h)
        ..lineTo(inset, h * 0.55)
        ..cubicTo(inset, h * 0.25, w * 0.22, top + 20, w * 0.40, top + 16)
        ..quadraticBezierTo(w * 0.47, top + 14, w * 0.5, top)
        ..quadraticBezierTo(w * 0.53, top + 14, w * 0.60, top + 16)
        ..cubicTo(w * 0.78, top + 20, w - inset, h * 0.25, w - inset, h * 0.55)
        ..lineTo(w - inset, h);
      canvas.drawPath(path, paint);
    }
    // small finial on the peak
    canvas.drawCircle(Offset(w / 2, 6), 2.2, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(ArchPainter old) => old.color != color;
}

/// A hanging brass lamp (latkan) on a thread.
class HangingLamp extends StatelessWidget {
  const HangingLamp({super.key, this.height = 110});
  final double height;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(28, height),
        painter: _LampPainter(context.pal.gold),
      );
}

class _LampPainter extends CustomPainter {
  _LampPainter(this.gold);
  final Color gold;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final h = size.height;
    final line = Paint()
      ..color = gold.withValues(alpha: 0.7)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(cx, 0), Offset(cx, h * 0.52), line);
    final fill = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFFF6D27A), gold, const Color(0xFF9C6A1C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, h * 0.5, size.width, h * 0.5));
    // bead
    final beadY = h * 0.56;
    canvas.drawPath(
        Path()
          ..moveTo(cx, beadY - 5)
          ..lineTo(cx + 4, beadY)
          ..lineTo(cx, beadY + 5)
          ..lineTo(cx - 4, beadY)
          ..close(),
        fill);
    // bell
    final top = h * 0.64, bottom = h * 0.86;
    canvas.drawPath(
        Path()
          ..moveTo(cx - 3, top)
          ..quadraticBezierTo(cx - 4, top + (bottom - top) * 0.5, cx - 11, bottom)
          ..lineTo(cx + 11, bottom)
          ..quadraticBezierTo(cx + 4, top + (bottom - top) * 0.5, cx + 3, top)
          ..close(),
        fill);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(cx, bottom + 1), width: 24, height: 3),
            const Radius.circular(2)),
        fill);
    canvas.drawCircle(Offset(cx, h * 0.95), 3.2, fill);
  }

  @override
  bool shouldRepaint(_LampPainter old) => old.gold != gold;
}

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
          p);
      canvas.drawPath(
          Path()
            ..moveTo(6, 70)
            ..cubicTo(14, 40, 34, 26, 56, 26)
            ..cubicTo(70, 26, 72, 44, 60, 46)
            ..cubicTo(52, 47, 50, 38, 56, 36),
          p);
      canvas.drawPath(
          Path()
            ..moveTo(24, 10)
            ..cubicTo(30, 24, 24, 34, 16, 34)
            ..cubicTo(8, 34, 8, 24, 14, 24),
          p);
      for (var i = 0; i < 4; i++) {
        canvas.drawCircle(Offset(100.0 + i * 9, 4 + i * 0.6), 1.3,
            Paint()..color = color);
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
              gradient: LinearGradient(colors: [
                gold.withValues(alpha: left ? 0 : 0.9),
                gold.withValues(alpha: left ? 0.9 : 0),
              ]),
            ),
          ),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 48),
      child: Row(children: [
        line(true),
        CustomPaint(size: const Size(34, 14), painter: _MotifPainter(gold)),
        line(false),
      ]),
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
