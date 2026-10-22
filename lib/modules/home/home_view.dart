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
import '../../data/models/seva.dart';
import '../../data/repository/path_repository.dart';
import '../../routes/app_routes.dart';
import '../shell/shell_controller.dart';
import 'home_controller.dart';

const _nowGradient = [Color(0xFFF0A04B), Color(0xFFD9661A), Color(0xFFB5500F)];

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
        SizedBox(height: 14),
        FadeSlideIn(index: 2, child: _NowSevaCard()),
        FadeSlideIn(index: 3, child: _SectionTitle()),
        FadeSlideIn(index: 4, child: _SevaGrid()),
        SizedBox(height: 16),
        FadeSlideIn(index: 5, child: _MiniCards()),
      ],
    );
  }
}

/// Arch, centred logo, greeting for the time of day and today's date.
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

class _NowSevaCard extends GetView<HomeController> {
  const _NowSevaCard();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final repo = Get.find<PathRepository>();
    return Obx(() {
      final id = DayInfo.currentSeva(controller.now.value);
      final seva = sevaList.firstWhere((x) => x.id == id);
      final n = repo.forSeva(id).length;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => Get.toNamed(Routes.seva, arguments: id),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _nowGradient,
                stops: [0, 0.6, 1],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  Positioned(
                    right: -40,
                    top: -50,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x1CFFFFFF),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 15, 14, 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'now_seva'.tr,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xE6FFFFFF),
                                ),
                              ),
                              Text(
                                seva.nameKey.tr,
                                style: const TextStyle(
                                  fontSize: 22,
                                  height: 1.3,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                n == 0
                                    ? 'soon'.tr
                                    : 'n_paths'.trParams({'n': '$n'}),
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xF2FFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                size: 16,
                                color: p.heading,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'read_path'.tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: p.heading,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(2, 16, 2, 12),
    child: Text(
      'daily_seva'.tr,
      style: TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.w700,
        color: context.pal.text,
      ),
    ),
  );
}

/// All eight sevas, four to a row, with the current one marked.
class _SevaGrid extends GetView<HomeController> {
  const _SevaGrid();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Obx(() {
      final now = DayInfo.currentSeva(controller.now.value);
      return GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 6,
          // Tile, gap and a label that grows with the phone's font size.
          mainAxisExtent: 61 + MediaQuery.textScalerOf(context).scale(13) * 1.9,
        ),
        children: [
          for (final s in sevaList)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.toNamed(Routes.seva, arguments: s.id),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: s.id == now ? p.iconTile : p.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: s.id == now
                                ? p.primary.withValues(alpha: 0.75)
                                : p.cardBorder,
                            width: s.id == now ? 1.5 : 1,
                          ),
                        ),
                        child: SvgIcon(s.icon, size: 31),
                      ),
                      if (s.id == now)
                        Positioned(
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: p.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'now_badge'.tr,
                              style: const TextStyle(
                                fontSize: 9.5,
                                height: 1.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    s.nameKey.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: s.id == now ? p.heading : p.text,
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}

/// "Continue reading" and today's japa, side by side.
class _MiniCards extends StatelessWidget {
  const _MiniCards();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final reading = Get.find<ReadingController>();
    final japa = Get.find<JapaController>();
    final repo = Get.find<PathRepository>();
    final s = Get.find<SettingsController>();
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Obx(() {
              final r = reading.last;
              final path = r == null ? null : repo.byId(r.pathId);
              return _Mini(
                onTap: path == null
                    ? () => Get.find<ShellController>().go(1)
                    : () => Get.toNamed(
                        Routes.reader,
                        arguments: {
                          'id': path.id,
                          'resume': r!.isComplete ? 0.0 : r.progress,
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
                  child: SvgIcon(path?.icon ?? 'lotus', size: 22),
                ),
                label: 'continue_btn'.tr,
                title: path?.title(s.uiLang.value) ?? 'not_started'.tr,
                titleColor: p.text,
                subtitle: path == null
                    ? 'start_reading'.tr
                    : 'verse_of'.trParams({
                        'a': '${r!.verse}',
                        'b': '${path.verses.length}',
                      }),
                progress: r?.progress ?? 0,
              );
            }),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(() {
              final c = japa.count.value;
              japa.history.length; // rebuild when a mala completes
              return _Mini(
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
                subtitle: 'japa_today_n'.trParams({'n': '${japa.malasToday}'}),
                progress: c / AppConfig.malaBeads,
              );
            }),
          ),
        ],
      ),
    );
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
