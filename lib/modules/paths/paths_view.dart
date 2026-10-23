import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/favorites_service.dart';
import '../../core/theme/palette.dart';
import '../../core/widgets/motion.dart';
import '../../core/widgets/svg_icon.dart';
import '../../core/widgets/tab_header.dart';
import '../../core/services/settings_service.dart';
import '../../data/models/category.dart';
import '../../data/models/path_model.dart';
import '../../routes/app_routes.dart';
import 'path_row.dart';
import 'paths_tab_controller.dart';

/// Tab: search, the wishlist and every section of paths.
class PathsView extends GetView<PathsTabController> {
  const PathsView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Column(
      children: [
        TabHeader(
          title: 'nav_paths'.tr,
          action: HeaderButton(
            icon: Icons.history_rounded,
            tooltip: 'history'.tr,
            onTap: () => Get.toNamed(Routes.history),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: _SearchField(controller: controller),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Obx(() {
            if (controller.query.value.trim().isNotEmpty) {
              final results = controller.results;
              if (results.isEmpty) {
                return Center(
                  child: Text(
                    'no_results'.tr,
                    style: TextStyle(fontSize: 15.5, color: p.subtext),
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                children: [
                  for (final (c, items) in results) ...[
                    _SectionTitle(c, items.length),
                    PathGroupCard(items: items),
                  ],
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 24),
              children: [
                const _WishlistCard(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 6, 2, 10),
                  child: Text(
                    'all_categories'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: p.heading,
                    ),
                  ),
                ),
                for (final (i, c) in categoryList.indexed)
                  FadeSlideIn(
                    index: i,
                    child: _CategoryCard(c, controller.pathsIn(c)),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.c, this.count);
  final PathCategory c;
  final int count;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 10, 2, 8),
      child: Row(
        children: [
          SvgIcon(c.icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              c.nameKey.tr,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: p.heading,
              ),
            ),
          ),
          Text(
            'n_paths'.trParams({'n': '$count'}),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: p.subtext,
            ),
          ),
        ],
      ),
    );
  }
}

/// One section: icon, name, a few example titles and how many paths.
class _CategoryCard extends StatelessWidget {
  const _CategoryCard(this.c, this.paths);
  final PathCategory c;
  final List<PathModel> paths;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final ui = Get.find<SettingsController>().uiLang.value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: p.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: p.cardBorder),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Get.toNamed(Routes.category, arguments: c.id),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: p.iconTile,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SvgIcon(c.icon, size: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.nameKey.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: p.text,
                        ),
                      ),
                      Text(
                        paths.map((x) => x.title(ui)).join(', '),
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: p.subtext,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'n_paths'.trParams({'n': '${paths.length}'}),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: p.subtext,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: p.subtext),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shortcut to saved paths; hidden until something is saved.
class _WishlistCard extends StatelessWidget {
  const _WishlistCard();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final fav = Get.find<FavoritesController>();
    return Obx(() {
      final n = fav.ids.length;
      if (n == 0) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Material(
          color: p.iconTile,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: p.pillBorder.withValues(alpha: 0.6)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Get.toNamed(Routes.wishlist),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Row(
                children: [
                  Icon(Icons.favorite_rounded, color: p.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'wishlist'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: p.text,
                      ),
                    ),
                  ),
                  Text(
                    'n_paths'.trParams({'n': '$n'}),
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: p.heading,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: p.subtext),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});
  final PathsTabController controller;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(23),
      borderSide: BorderSide(color: p.cardBorder),
    );
    return TextField(
      controller: controller.search,
      style: TextStyle(fontSize: 15.5, color: p.text),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'history_search'.tr,
        hintStyle: TextStyle(color: p.subtext, fontSize: 15),
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
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: p.primary, width: 1.5),
        ),
      ),
    );
  }
}
