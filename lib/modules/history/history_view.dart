import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/time_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';
import '../../core/widgets/motion.dart';
import '../../core/widgets/svg_icon.dart';
import '../../data/models/path_model.dart';
import '../../data/models/reading_record.dart';
import '../../routes/app_routes.dart';
import '../japa/japa_history_view.dart';
import 'history_controller.dart';

/// Every path the user has read, with search.
class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return PageScaffold(
      body: Column(
        children: [
          Obx(
            () => PageHeader(
              title: 'history'.tr,
              onBack: Get.back,
              actions: [
                if (controller.reading.records.isNotEmpty)
                  IconButton(
                    tooltip: 'clear_all'.tr,
                    icon: Icon(Icons.delete_sweep_outlined, color: p.heading),
                    onPressed: () =>
                        confirm('clear_history', controller.reading.clear),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: controller.search,
              style: TextStyle(fontSize: 16, color: p.text),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'history_search'.tr,
                hintStyle: TextStyle(color: p.subtext),
                prefixIcon: Icon(Icons.search_rounded, color: p.subtext),
                suffixIcon: Obx(
                  () => controller.query.value.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: Icon(Icons.close_rounded, color: p.subtext),
                          onPressed: controller.search.clear,
                        ),
                ),
                filled: true,
                fillColor: p.card,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide(color: p.chipBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide(color: p.primary, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final items = controller.items;
              if (controller.reading.records.isEmpty) {
                return _Empty(text: 'history_empty'.tr);
              }
              if (items.isEmpty) return _Empty(text: 'no_results'.tr);
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [for (final (r, path) in items) _Row(r, path)],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_stories_outlined, size: 56, color: p.pillBorder),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.6, color: p.subtext),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.r, this.path);
  final ReadRecord r;
  final PathModel path;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final ui = Get.find<SettingsController>().uiLang.value;
    final small = TextStyle(fontSize: 13, color: p.subtext);
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
      onTap: () => Get.toNamed(
        Routes.reader,
        arguments: {'id': path.id, 'resume': r.isComplete ? 0.0 : r.progress},
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: p.iconTile,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgIcon(path.icon, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  path.title(ui),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: p.text,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedBar(
                  value: r.progress,
                  height: 4,
                  color: p.primary,
                  background: p.chipBorder,
                ),
                const SizedBox(height: 6),
                Text(
                  [
                    TimeFormat.ago(r.lastReadAt),
                    r.isComplete
                        ? 'read_done'.tr
                        : '${(r.progress * 100).round()}%',
                    if (r.completedCount > 0)
                      'completed_times'.trParams({'n': '${r.completedCount}'}),
                  ].join('  ·  '),
                  style: small,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'delete'.tr,
            icon: Icon(Icons.delete_outline_rounded, color: p.subtext),
            onPressed: () => confirm(
              'delete_read',
              () => Get.find<HistoryController>().reading.remove(r.pathId),
            ),
          ),
        ],
      ),
    );
  }
}
