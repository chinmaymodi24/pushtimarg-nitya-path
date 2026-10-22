import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/favorites_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/palette.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/svg_icon.dart';
import '../../data/models/path_model.dart';
import '../../routes/app_routes.dart';

class PathTile extends StatelessWidget {
  const PathTile(this.path, {super.key});
  final PathModel path;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = Get.find<SettingsController>();
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
      onTap: () => Get.toNamed(Routes.reader, arguments: path.id),
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
            child: SvgIcon(path.icon, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(
              () => Text(
                path.title(s.uiLang.value),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: p.text,
                ),
              ),
            ),
          ),
          Obx(
            () => Get.find<FavoritesController>().isFav(path.id)
                ? Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 18,
                      color: p.primary,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Icon(Icons.chevron_right_rounded, color: p.subtext),
        ],
      ),
    );
  }
}
