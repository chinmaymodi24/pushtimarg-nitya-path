import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/app_config.dart';
import '../../core/services/japa_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/script_converter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';
import '../../core/widgets/tab_header.dart';
import '../../routes/app_routes.dart';
import 'japa_history_view.dart';

/// Tap-to-count mala of 108 beads for "Shri Krishnah Sharanam Mama".
class JapaView extends GetView<JapaController> {
  const JapaView({super.key, this.onBack});

  /// Set when shown as a tab: tab header, no scaffold of its own.
  final VoidCallback? onBack;

  static const _mantra = 'श्रीकृष्णः शरणं मम';

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = Get.find<SettingsController>();
    final size = math.min(MediaQuery.sizeOf(context).width - 48, 330.0);
    final historyButton = HeaderButton(
      icon: Icons.history_rounded,
      tooltip: 'mala_history'.tr,
      onTap: () => Get.toNamed(Routes.japaHistory),
    );
    final body = Column(
      children: [
        if (onBack != null)
          TabHeader(title: 'japa_title'.tr, action: historyButton)
        else
          PageHeader(
            title: 'japa_title'.tr,
            onBack: Get.back,
            actions: [historyButton],
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Obx(
                () => Text(
                  ScriptConverter.convert(_mantra, s.script.value),
                  textAlign: TextAlign.center,
                  style: AppTheme.verse(
                    s.script.value,
                    26,
                    p.heading,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: controller.increment,
                  child: SizedBox.square(
                    dimension: size,
                    child: Obx(
                      () => CustomPaint(
                        painter: _MalaPainter(
                          done: controller.count.value,
                          bead: p.gold,
                          doneBead: p.primary,
                        ),
                        child: Center(child: _Counter(size: size * 0.62)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => _Stat(
                        label: 'japa_today'.tr,
                        value: '${controller.malasToday}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => _Stat(
                        label: 'japa_total'.tr,
                        value: '${controller.total}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: _confirmReset,
                  icon: Icon(Icons.restart_alt_rounded, color: p.subtext),
                  label: Text(
                    'japa_reset'.tr,
                    style: TextStyle(color: p.subtext, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'recent_malas'.tr,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: p.text,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.japaHistory),
                    child: Text(
                      'see_all'.tr,
                      style: TextStyle(
                        color: p.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                final h = controller.history;
                if (h.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'mala_empty'.tr,
                      style: TextStyle(fontSize: 14.5, color: p.subtext),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (var i = 0; i < h.length && i < 3; i++)
                      MalaTile(entry: h[i], number: h.length - i),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
    return onBack != null ? body : PageScaffold(body: body);
  }

  void _confirmReset() => showConfirm(
    title: 'reset_t'.tr,
    message: 'reset_m'.tr,
    confirmLabel: 'restart'.tr,
    destructive: false,
    onConfirm: controller.resetCurrent,
  );
}

class _Counter extends StatelessWidget {
  const _Counter({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final c = Get.find<JapaController>();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [p.card, p.iconTile]),
        border: Border.all(color: p.pillBorder, width: 1.5),
        boxShadow: [BoxShadow(color: p.shadow, blurRadius: 18)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${c.count.value}',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: size * 0.32,
              fontWeight: FontWeight.w700,
              color: p.heading,
              height: 1.1,
            ),
          ),
          Text(
            '/ ${AppConfig.malaBeads}',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16,
              color: p.subtext,
            ),
          ),
          const SizedBox(height: 6),
          Text('japa_tap'.tr, style: TextStyle(fontSize: 13, color: p.subtext)),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: p.text,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 13.5, color: p.subtext)),
        ],
      ),
    );
  }
}

/// 108 beads on a ring with a larger meru bead at the top.
class _MalaPainter extends CustomPainter {
  _MalaPainter({
    required this.done,
    required this.bead,
    required this.doneBead,
  });
  final int done;
  final Color bead, doneBead;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 10;
    const n = AppConfig.malaBeads;
    final thread = Paint()
      ..color = bead.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(c, r, thread);
    final beadR = (2 * math.pi * r / n) * 0.36;
    for (var i = 0; i < n; i++) {
      final a = -math.pi / 2 + (i + 1) * 2 * math.pi / (n + 1);
      final o = c + Offset(math.cos(a) * r, math.sin(a) * r);
      final isDone = i < done;
      canvas.drawCircle(
        o,
        isDone ? beadR * 1.15 : beadR,
        Paint()..color = isDone ? doneBead : bead.withValues(alpha: 0.55),
      );
    }
    // meru
    final top = c + Offset(0, -r);
    canvas.drawCircle(top, beadR * 2.2, Paint()..color = doneBead);
    canvas.drawCircle(top, beadR * 1.0, Paint()..color = bead);
  }

  @override
  bool shouldRepaint(_MalaPainter old) =>
      old.done != done || old.bead != bead || old.doneBead != doneBead;
}
