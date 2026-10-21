import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/japa_service.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/time_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';
import '../../data/models/reading_record.dart';

/// Every completed mala, grouped by day, each deletable.
class JapaHistoryView extends GetView<JapaController> {
  const JapaHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return PageScaffold(
      body: Column(
        children: [
          Obx(() => PageHeader(
                title: 'mala_history'.tr,
                onBack: Get.back,
                actions: [
                  if (controller.history.isNotEmpty)
                    IconButton(
                      tooltip: 'clear_all'.tr,
                      icon: Icon(Icons.delete_sweep_outlined, color: p.heading),
                      onPressed: () => confirm('clear_mala_q'.tr,
                          controller.clearHistory),
                    ),
                ],
              )),
          Expanded(
            child: Obx(() {
              final h = controller.history;
              if (h.isEmpty) {
                return Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.blur_circular_rounded,
                        size: 56, color: p.pillBorder),
                    const SizedBox(height: 12),
                    Text('mala_empty'.tr,
                        style: TextStyle(fontSize: 16, color: p.subtext)),
                  ]),
                );
              }
              final children = <Widget>[];
              String? lastDay;
              for (var i = 0; i < h.length; i++) {
                final day = TimeFormat.day(h[i].completedAt);
                if (day != lastDay) {
                  final n = h
                      .where((e) => TimeFormat.day(e.completedAt) == day)
                      .length;
                  children.add(Padding(
                    padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
                    child: Row(children: [
                      Text(day,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: p.heading)),
                      const Spacer(),
                      Text('$n × 108',
                          style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 13.5,
                              color: p.subtext)),
                    ]),
                  ));
                  lastDay = day;
                }
                children.add(MalaTile(entry: h[i], number: h.length - i));
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: children,
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// One completed mala with time, duration and a delete button.
class MalaTile extends StatelessWidget {
  const MalaTile({super.key, required this.entry, required this.number});
  final MalaEntry entry;
  final int number;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final c = Get.find<JapaController>();
    final at = entry.completedAt;
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: p.iconTile, shape: BoxShape.circle),
          child: Icon(Icons.check_rounded, color: p.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('mala_n'.trParams({'n': '$number'}),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: p.text)),
              Text(
                [
                  '${TimeFormat.day(at)}, ${TimeFormat.clock(at)}',
                  if (entry.seconds != null) TimeFormat.duration(entry.seconds!),
                ].join('  ·  '),
                style: TextStyle(fontSize: 13.5, color: p.subtext),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'delete'.tr,
          icon: Icon(Icons.delete_outline_rounded, color: p.subtext),
          onPressed: () =>
              confirm('delete_mala_q'.tr, () => c.deleteEntry(entry)),
        ),
      ]),
    );
  }
}

/// Asks before deleting anything.
void confirm(String question, VoidCallback onYes) => showConfirm(
      title: 'delete'.tr,
      message: question,
      confirmLabel: 'delete'.tr,
      icon: Icons.delete_outline_rounded,
      onConfirm: onYes,
    );
