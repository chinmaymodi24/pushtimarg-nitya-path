import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/app_config.dart';
import '../../core/services/japa_service.dart';
import '../../core/services/reading_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/day_info.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/motion.dart';
import '../../core/widgets/svg_icon.dart';
import '../../data/models/category.dart';
import '../../data/repository/path_repository.dart';
import '../../routes/app_routes.dart';
import '../shell/shell_controller.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
      children: const [
        FadeSlideIn(index: 0, child: _Header()),
        SizedBox(height: 12),
        FadeSlideIn(index: 1, child: _SearchBar()),
        SizedBox(height: 16),
        FadeSlideIn(index: 2, child: _MiniCards()),
        FadeSlideIn(index: 3, child: _SectionTitle()),
        FadeSlideIn(index: 4, child: _SectionGrid()),
      ],
    );
  }
}

/// Centred logo, greeting for the time of day and today's date.
class _Header extends GetView<HomeController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = Get.find<SettingsController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        children: [
          const AppLogo(width: 200),
          const SizedBox(height: 2),
          Obx(
            () => Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${DayInfo.greeting(controller.now.value)} · ',
                  ),
                  TextSpan(
                    text: 'jsk'.tr,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(text: ' 🙏'),
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: p.heading,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: p.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: p.cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_rounded, size: 13, color: p.subtext),
                const SizedBox(width: 6),
                Obx(
                  () => Text(
                    DayInfo.date(controller.now.value, s.uiLang.value),
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: p.subtext,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 10, 0, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'home_sections'.tr,
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: p.text,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.find<ShellController>().go(1),
            style: TextButton.styleFrom(
              foregroundColor: p.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              visualDensity: VisualDensity.compact,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'see_all'.tr,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The first ten sections of the Paths tab, two to a row.
class _SectionGrid extends StatelessWidget {
  const _SectionGrid();

  static const _shown = 10;

  @override
  Widget build(BuildContext context) {
    final items = categoryList.take(_shown).toList();
    return Column(
      children: [
        for (var i = 0; i < items.length; i += 2)
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 10),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _SectionTile(items[i])),
                  const SizedBox(width: 10),
                  Expanded(
                    child: i + 1 < items.length
                        ? _SectionTile(items[i + 1])
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile(this.c);
  final PathCategory c;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final paths = Get.find<PathRepository>().forCategory(c.id);
    final ready = paths.where((x) => x.available).length;
    return Material(
      color: p.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: p.cardBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Get.toNamed(Routes.category, arguments: c.id),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.iconTile,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgIcon(c.icon, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                c.nameKey.tr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  color: p.text,
                ),
              ),
              const Spacer(),
              const SizedBox(height: 2),
              Text(
                ready > 0
                    ? 'n_ready'.trParams({'n': '$ready'})
                    : 'n_paths'.trParams({'n': '${paths.length}'}),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ready > 0 ? p.primary : p.subtext,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Continue reading" and today's japa. Each shows only once there is
/// something to continue; with only one, it takes the full width.
class _MiniCards extends StatelessWidget {
  const _MiniCards();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final reading = Get.find<ReadingController>();
    final japa = Get.find<JapaController>();
    final repo = Get.find<PathRepository>();
    final s = Get.find<SettingsController>();
    return Obx(() {
      final r = reading.last;
      final path = r == null ? null : repo.byId(r.pathId);
      final c = japa.count.value;
      japa.history.length; // rebuild when a mala completes
      final today = japa.malasToday;
      final cards = <Widget>[
        if (r != null && path != null)
          _Mini(
            onTap: () => Get.toNamed(
              Routes.reader,
              arguments: {
                'id': path.id,
                'resume': r.isComplete ? 0.0 : r.progress,
              },
            ),
            lead: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: p.iconTile,
                borderRadius: BorderRadius.circular(11),
              ),
              child: SvgIcon(path.icon, size: 22),
            ),
            label: 'continue_btn'.tr,
            title: path.title(s.uiLang.value),
            titleColor: p.text,
            subtitle: 'verse_of'.trParams({
              'a': '${r.verse}',
              'b': '${path.verses.length}',
            }),
            progress: r.progress,
          ),
        if (c > 0 || today > 0)
          _Mini(
            onTap: () => Get.find<ShellController>().go(2),
            lead: SizedBox.square(
              dimension: 36,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: c / AppConfig.malaBeads,
                    strokeWidth: 4,
                    backgroundColor: p.chipBorder,
                    valueColor: AlwaysStoppedAnimation(p.primary),
                  ),
                  Text(
                    '$c',
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: p.heading,
                    ),
                  ),
                ],
              ),
            ),
            label: 'japa_title'.tr,
            title: 'japa_sub'.tr,
            titleColor: p.heading,
            subtitle: 'japa_today_n'.trParams({'n': '$today'}),
            progress: c / AppConfig.malaBeads,
          ),
      ];
      if (cards.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: cards.first),
              if (cards.length > 1) ...[
                const SizedBox(width: 10),
                Expanded(child: cards.last),
              ],
            ],
          ),
        ),
      );
    });
  }
}

class _Mini extends StatelessWidget {
  const _Mini({
    required this.onTap,
    required this.lead,
    required this.label,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    required this.progress,
  });

  final VoidCallback onTap;
  final Widget lead;
  final String label, title, subtitle;
  final Color titleColor;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Material(
      color: p.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: p.cardBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  lead,
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: p.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.5, color: p.subtext),
              ),
              const Spacer(),
              const SizedBox(height: 7),
              AnimatedBar(
                value: progress,
                color: p.primary,
                background: p.chipBorder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Looks like a field; opens the full search screen.
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Hero(
      tag: 'app-search',
      child: Material(
        color: p.card,
        shape: StadiumBorder(side: BorderSide(color: p.cardBorder)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => Get.toNamed(Routes.search),
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(Icons.search_rounded, color: p.subtext),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'search_hint'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.5, color: p.subtext),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
