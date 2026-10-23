import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/app_config.dart';
import '../../core/services/japa_service.dart';
import '../../core/services/reading_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/day_info.dart';
import '../../core/utils/script_converter.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/motion.dart';
import '../../core/widgets/svg_icon.dart';
import '../../data/models/category.dart';
import '../../data/repository/path_repository.dart';
import '../../routes/app_routes.dart';
import '../paths/path_row.dart';
import '../shell/shell_controller.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
      children: [
        const FadeSlideIn(index: 0, child: _Header()),
        const SizedBox(height: 12),
        const FadeSlideIn(index: 1, child: _SearchBar()),
        const SizedBox(height: 16),
        const FadeSlideIn(index: 2, child: _MiniCards()),
        const FadeSlideIn(index: 3, child: _VerseOfDay()),
        FadeSlideIn(
          index: 4,
          child: _SectionTitle(
            'home_sections',
            onSeeAll: () => Get.find<ShellController>().go(1),
          ),
        ),
        const FadeSlideIn(index: 5, child: _SectionGrid()),
        const SizedBox(height: 8),
        FadeSlideIn(
          index: 6,
          child: _SectionTitle(
            'ready_paths',
            onSeeAll: () => Get.find<ShellController>().go(1),
          ),
        ),
        const FadeSlideIn(index: 7, child: _ReadyPaths()),
        const FadeSlideIn(index: 8, child: _Closing()),
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
  const _SectionTitle(this.titleKey, {required this.onSeeAll});
  final String titleKey;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 10, 0, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titleKey.tr,
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: p.text,
              ),
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
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

/// The first eight sections of the Paths tab, four to a row.
class _SectionGrid extends StatelessWidget {
  const _SectionGrid();

  static const _shown = 8;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
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
        for (final c in categoryList.take(_shown))
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Get.toNamed(Routes.category, arguments: c.id),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: p.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: p.cardBorder),
                  ),
                  child: SvgIcon(c.icon, size: 31),
                ),
                const SizedBox(height: 5),
                Text(
                  c.shortKey.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: p.text,
                  ),
                ),
              ],
            ),
          ),
      ],
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

/// One verse a day from the paths that have text, in the reader's script
/// and meaning language. Opens the reader at that verse.
class _VerseOfDay extends GetView<HomeController> {
  const _VerseOfDay();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = Get.find<SettingsController>();
    return Obx(() {
      final pick = controller.verseOfDay;
      if (pick == null) return const SizedBox.shrink();
      final (path, verse) = pick;
      final meaning = s.showMeaning.value
          ? verse.meaning(s.meaningLang.value)
          : null;
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Get.toNamed(
              Routes.reader,
              arguments: {'id': path.id, 'verse': verse.number},
            ),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: p.cardBorder),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [p.iconTile, p.card],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 16,
                          color: p.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'verse_of_day'.tr,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: p.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ScriptConverter.convert(verse.dev, s.script.value),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.verse(s.script.value, 16.5, p.verse),
                    ),
                    if (meaning != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          '❀',
                          style: TextStyle(fontSize: 12, color: p.gold),
                        ),
                      ),
                      Text(
                        meaning,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.meaning(
                          s.meaningLang.value,
                          13,
                          p.meaning,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Divider(height: 1, color: p.cardBorder),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${path.title(s.uiLang.value)} · '
                            '${'verse_n'.trParams({'n': '${verse.number}'})}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: p.subtext,
                            ),
                          ),
                        ),
                        Text(
                          'read_path'.tr,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: p.primary,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: p.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

/// Paths that already have their text, so Home always has something to read.
class _ReadyPaths extends StatelessWidget {
  const _ReadyPaths();

  @override
  Widget build(BuildContext context) {
    final ready = Get.find<PathRepository>().all
        .where((x) => x.available)
        .take(5)
        .toList();
    if (ready.isEmpty) return const SizedBox.shrink();
    return PathGroupCard(items: ready);
  }
}

class _Closing extends StatelessWidget {
  const _Closing();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 8),
      child: Text(
        '॥ ${'japa_sub'.tr} ॥',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: p.gold,
        ),
      ),
    );
  }
}
