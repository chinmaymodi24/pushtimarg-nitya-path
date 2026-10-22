import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/favorites_service.dart';
import '../../core/services/reading_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/open_path.dart';
import '../../core/widgets/motion.dart';
import '../../core/widgets/svg_icon.dart';
import '../../data/models/path_model.dart';

/// Paths in one rounded card, separated by hairlines.
class PathGroupCard extends StatelessWidget {
  const PathGroupCard({super.key, required this.items});
  final List<PathModel> items;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Divider(height: 1, color: p.cardBorder),
            PathRow(items[i]),
          ],
        ],
      ),
    );
  }
}

/// One path: icon, title, verse count or "coming soon", progress, heart.
class PathRow extends StatelessWidget {
  const PathRow(this.path, {super.key});
  final PathModel path;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = Get.find<SettingsController>();
    final fav = Get.find<FavoritesController>();
    final reading = Get.find<ReadingController>();
    final ready = path.available;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => openPath(path),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14, 11, ready ? 6 : 14, 11),
          child: Row(
            children: [
              Opacity(
                opacity: ready ? 1 : 0.55,
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: p.iconTile,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: SvgIcon(path.icon, size: 28),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() {
                  final r = reading.records[path.id];
                  final pr = r?.progress ?? 0;
                  final done = r?.isComplete ?? false;
                  final n = 'n_verses'.trParams({'n': '${path.verses.length}'});
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        path.title(s.uiLang.value),
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: ready ? p.text : p.subtext,
                        ),
                      ),
                      if (ready)
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: n),
                              if (done || pr > 0)
                                TextSpan(
                                  text:
                                      ' · ${done ? 'read_done'.tr : 'read_pct'.trParams({'n': '${(pr * 100).round()}'})}',
                                  style: TextStyle(
                                    color: p.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                          style: TextStyle(fontSize: 12.5, color: p.subtext),
                        ),
                      if (ready && pr > 0 && !done)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, right: 24),
                          child: AnimatedBar(
                            value: pr,
                            height: 4,
                            color: p.primary,
                            background: p.chipBorder,
                          ),
                        ),
                    ],
                  );
                }),
              ),
              if (ready)
                Obx(() {
                  final on = fav.isFav(path.id);
                  return IconButton(
                    tooltip: 'wishlist'.tr,
                    onPressed: () => fav.toggle(path.id),
                    icon: Icon(
                      on
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: on ? p.primary : p.subtext.withValues(alpha: 0.7),
                      size: 21,
                    ),
                  );
                })
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: p.chip,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: p.chipBorder),
                  ),
                  child: Text(
                    'coming_soon'.tr,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: p.subtext,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
