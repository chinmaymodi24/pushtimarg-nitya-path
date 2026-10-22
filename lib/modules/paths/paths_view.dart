import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/favorites_service.dart';
import '../../core/services/reading_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/palette.dart';
import '../../core/widgets/svg_icon.dart';
import '../../core/widgets/tab_header.dart';
import '../../data/models/path_model.dart';
import '../../data/models/seva.dart';
import '../../routes/app_routes.dart';
import 'paths_tab_controller.dart';

/// Tab: search, filter chips and every path grouped by seva.
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
        const SizedBox(height: 12),
        const _FilterChips(),
        Expanded(
          child: Obx(() {
            Get.find<FavoritesController>().ids.length;
            final groups = controller.groups;
            if (groups.isEmpty) return const _Empty();
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
              children: [
                for (final (seva, items) in groups) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 10, 2, 8),
                    child: Row(
                      children: [
                        SvgIcon(seva.icon, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${seva.nameKey.tr} ${'seva_suffix'.tr}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: p.heading,
                            ),
                          ),
                        ),
                        Text(
                          'n_paths'.trParams({'n': '${items.length}'}),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: p.subtext,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _GroupCard(items: items),
                ],
              ],
            );
          }),
        ),
      ],
    );
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

/// Horizontally scrolling chips with ‹ › arrows that appear only when
/// there is more to see on that side.
class _FilterChips extends GetView<PathsTabController> {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.updateArrows(),
    );
    final chips = <(String, String, Widget?)>[
      (PathsTabController.all, 'all_chip'.tr, null),
      (
        PathsTabController.fav,
        'wishlist'.tr,
        const Icon(Icons.favorite_rounded, size: 15),
      ),
      for (final s in sevaList) (s.id, s.nameKey.tr, SvgIcon(s.icon, size: 17)),
    ];
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          NotificationListener<ScrollMetricsNotification>(
            onNotification: (_) {
              controller.updateArrows();
              return false;
            },
            child: ListView.separated(
              controller: controller.chips,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: chips.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final (id, label, icon) = chips[i];
                return Obx(() {
                  final on = controller.filter.value == id;
                  return GestureDetector(
                    onTap: () => controller.select(id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: on ? p.primary : p.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: on ? p.primary : p.cardBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            IconTheme(
                              data: IconThemeData(color: p.primary),
                              // Selected chip is saffron, so its icon turns white.
                              child: on
                                  ? ColorFiltered(
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      child: icon,
                                    )
                                  : icon,
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: on ? Colors.white : p.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          Obx(
            () => controller.canLeft.value
                ? _Arrow(left: true, onTap: () => controller.scrollChips(false))
                : const SizedBox.shrink(),
          ),
          Obx(
            () => controller.canRight.value
                ? _Arrow(left: false, onTap: () => controller.scrollChips(true))
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// Round arrow over a fade so it reads as "more this way".
class _Arrow extends StatelessWidget {
  const _Arrow({required this.left, required this.onTap});
  final bool left;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final bg = Theme.of(context).brightness == Brightness.dark
        ? p.bgBottom
        : p.bgTop;
    return Positioned(
      left: left ? 0 : null,
      right: left ? null : 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 58,
        alignment: left ? Alignment.centerLeft : Alignment.centerRight,
        padding: EdgeInsets.only(left: left ? 8 : 0, right: left ? 0 : 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: left ? Alignment.centerLeft : Alignment.centerRight,
            end: left ? Alignment.centerRight : Alignment.centerLeft,
            colors: [bg, bg, bg.withValues(alpha: 0)],
            stops: const [0, 0.45, 1],
          ),
        ),
        child: Tooltip(
          message: (left ? 'scroll_left' : 'scroll_right').tr,
          child: Material(
            color: p.card,
            shape: CircleBorder(side: BorderSide(color: p.cardBorder)),
            elevation: 2,
            shadowColor: p.shadow,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox.square(
                dimension: 30,
                child: Icon(
                  left
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  size: 22,
                  color: p.heading,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.items});
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
            _PathRow(items[i]),
          ],
        ],
      ),
    );
  }
}

class _PathRow extends StatelessWidget {
  const _PathRow(this.path);
  final PathModel path;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = Get.find<SettingsController>();
    final fav = Get.find<FavoritesController>();
    final reading = Get.find<ReadingController>();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(Routes.reader, arguments: path.id),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 11, 6, 11),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.iconTile,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SvgIcon(path.icon, size: 28),
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
                          color: p.text,
                        ),
                      ),
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
                      if (pr > 0 && !done)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, right: 24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: pr,
                              minHeight: 4,
                              backgroundColor: p.chipBorder,
                              valueColor: AlwaysStoppedAnimation(p.primary),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
              Obx(() {
                final on = fav.isFav(path.id);
                return IconButton(
                  tooltip: 'wishlist'.tr,
                  onPressed: () => fav.toggle(path.id),
                  icon: Icon(
                    on ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: on ? p.primary : p.subtext.withValues(alpha: 0.7),
                    size: 21,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _Empty extends GetView<PathsTabController> {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final f = controller.filter.value;
    final text = controller.query.value.isNotEmpty
        ? 'no_results'.tr
        : f == PathsTabController.fav
        ? 'wishlist_empty'.tr
        : 'no_paths'.tr;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              f == PathsTabController.fav
                  ? Icons.favorite_border_rounded
                  : Icons.menu_book_outlined,
              size: 52,
              color: p.pillBorder,
            ),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.5, height: 1.6, color: p.subtext),
            ),
          ],
        ),
      ),
    );
  }
}
