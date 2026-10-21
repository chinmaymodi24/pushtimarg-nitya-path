import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/reading_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/time_format.dart';
import '../../core/widgets/svg_icon.dart';
import '../../data/repository/path_repository.dart';
import '../../routes/app_routes.dart';

/// "You were reading ..." with a button that jumps back to the same place.
class ContinueCard extends StatelessWidget {
  const ContinueCard({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final reading = Get.find<ReadingController>();
    final repo = Get.find<PathRepository>();
    final s = Get.find<SettingsController>();
    return Obx(() {
      final r = reading.last;
      final path = r == null ? null : repo.byId(r.pathId);
      if (r == null || path == null) return const SizedBox.shrink();
      final n = path.verses.length;
      return Container(
        margin: const EdgeInsets.only(top: 14),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: p.pillBorder.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
                color: p.shadow, blurRadius: 14, offset: const Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.bookmark_rounded, size: 18, color: p.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text('continue_title'.tr,
                    style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: p.heading)),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.history),
                child: Text('history'.tr,
                    style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: p.primary)),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: p.iconTile, borderRadius: BorderRadius.circular(12)),
                child: SvgIcon(path.icon, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(path.title(s.uiLang.value),
                        style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w700,
                            color: p.text)),
                    Text(
                      '${'verse_of'.trParams({'a': '${r.verse}', 'b': '$n'})}  ·  ${TimeFormat.ago(r.lastReadAt)}',
                      style: TextStyle(fontSize: 13, color: p.subtext),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.reader, arguments: {
                  'id': path.id,
                  'resume': r.isComplete ? 0.0 : r.progress,
                }),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: p.chipSelected),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Text(
                    r.isComplete ? 'read_again'.tr : 'continue_btn'.tr,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: p.onChipSelected),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: r.progress,
                    minHeight: 5,
                    backgroundColor: p.chipBorder,
                    valueColor: AlwaysStoppedAnimation(p.primary),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(r.isComplete ? 'read_done'.tr : '${(r.progress * 100).round()}%',
                  style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: p.heading)),
            ]),
          ],
        ),
      );
    });
  }
}
