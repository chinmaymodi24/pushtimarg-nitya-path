import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/favorites_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/script_converter.dart';
import '../../core/widgets/choice_chips.dart';
import '../../core/widgets/disclaimer_note.dart';
import '../../core/widgets/ornaments.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';
import '../../core/widgets/size_slider.dart';
import '../../data/models/enums.dart';
import '../../data/models/path_model.dart';
import '../../routes/app_routes.dart';
import 'reader_controller.dart';

class ReaderView extends GetView<ReaderController> {
  const ReaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Get.find<SettingsController>();
    final fav = Get.find<FavoritesController>();
    final p = context.pal;
    return PageScaffold(
      bottom: const _ReaderBar(),
      body: Column(
        children: [
          Obx(() => PageHeader(
                title: controller.path.title(s.uiLang.value),
                onBack: Get.back,
                actions: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'wishlist'.tr,
                    icon: Icon(
                      fav.isFav(controller.path.id)
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: fav.isFav(controller.path.id)
                          ? p.primary
                          : p.heading,
                    ),
                    onPressed: () {
                      final added = fav.toggle(controller.path.id);
                      Get.rawSnackbar(
                        message: (added ? 'wish_added' : 'wish_removed').tr,
                        duration: const Duration(milliseconds: 1400),
                      );
                    },
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'choose_script'.tr,
                    icon: Icon(Icons.menu_book_outlined, color: p.heading),
                    onPressed: _openScriptSheet,
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.settings_outlined, color: p.heading),
                    onPressed: () => Get.toNamed(Routes.settings),
                  ),
                ],
              )),
          const _ProgressStrip(),
          Expanded(
            child: Obx(() {
              final script = s.script.value;
              final scale = s.textScale.value;
              final lang = s.showMeaning.value ? s.meaningLang.value : null;
              final verses = controller.path.verses;
              // A plain column (not a lazy list) so every verse has a real
              // position for the progress and "continue reading".
              return SingleChildScrollView(
                controller: controller.scroll,
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
                // Corner flourishes belong to the page, so they scroll away.
                child: CustomPaint(
                  painter: CornerFlourishPainter(p.gold.withValues(alpha: 0.5)),
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < verses.length; i++)
                      KeyedSubtree(
                        key: controller.verseKeys[i],
                        child: _VerseBlock(
                          verse: verses[i],
                          script: script,
                          scale: scale,
                          meaningLang: lang,
                          last: i == verses.length - 1,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: DisclaimerNote(
                          pathTitle: controller.path.title(s.uiLang.value)),
                    ),
                  ],
                ),
                ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _openScriptSheet() {
    final s = Get.find<SettingsController>();
    Get.bottomSheet(
      Builder(builder: (context) {
        final p = context.pal;
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          decoration: BoxDecoration(
            color: p.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('choose_script'.tr,
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700, color: p.text)),
              const SizedBox(height: 14),
              Obx(() => ChoiceChips<ReaderScript>(
                    values: ReaderScript.values,
                    selected: s.script.value,
                    label: (v) => v.nativeName,
                    onSelected: s.setScript,
                  )),
            ],
          ),
        );
      }),
    );
  }
}

class _VerseBlock extends StatelessWidget {
  const _VerseBlock({
    required this.verse,
    required this.script,
    required this.scale,
    required this.meaningLang,
    required this.last,
  });

  final Verse verse;
  final ReaderScript script;
  final double scale;
  final Lang? meaningLang;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final meaning = meaningLang == null ? null : verse.meaning(meaningLang!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          ScriptConverter.verseMark(verse.number, script),
          textAlign: TextAlign.center,
          style: AppTheme.verse(script, 16 * scale, p.subtext),
        ),
        const SizedBox(height: 4),
        Text(
          ScriptConverter.convert(verse.dev, script),
          textAlign: TextAlign.center,
          style: AppTheme.verse(script, 21 * scale, p.verse),
        ),
        if (meaning != null) ...[
          const OrnamentDivider(),
          Text(
            '${meaningLang!.meaningWord} (${meaningLang!.nativeName})',
            style: AppTheme.meaning(meaningLang!, 17 * scale, p.heading)
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(meaning,
              style: AppTheme.meaning(meaningLang!, 15.5 * scale, p.meaning)),
        ],
        if (!last) const OrnamentDivider() else const SizedBox(height: 16),
      ],
    );
  }
}

/// A- slider A+, meaning pill and theme toggle. Nothing audio-like.
class _ReaderBar extends StatelessWidget {
  const _ReaderBar();

  @override
  Widget build(BuildContext context) {
    final s = Get.find<SettingsController>();
    final p = context.pal;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: p.navBg.withValues(alpha: dark ? 1 : 0.92),
        border: Border(top: BorderSide(color: p.cardBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
          child: Row(
            children: [
              const Expanded(child: SizeSlider()),
              const SizedBox(width: 8),
              Obx(() => GestureDetector(
                    onTap: () => s.setShowMeaning(!s.showMeaning.value),
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: p.pill,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: p.pillBorder),
                      ),
                      child: Text(
                        s.showMeaning.value
                            ? 'hide_meaning'.tr
                            : 'show_meaning_btn'.tr,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: p.text),
                      ),
                    ),
                  )),
              IconButton(
                onPressed: () => s.toggleDark(context),
                icon: Icon(
                  dark ? Icons.wb_sunny_rounded : Icons.dark_mode_outlined,
                  color: dark ? p.primary : p.heading,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thin bar under the header: how much is read and how many verses remain.
class _ProgressStrip extends GetView<ReaderController> {
  const _ProgressStrip();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final n = controller.path.verses.length;
    final small = TextStyle(fontSize: 12.5, color: p.subtext);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 4),
      child: Obx(() {
        final pr = controller.progress.value;
        final done = pr >= 0.98;
        return Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pr,
              minHeight: 5,
              backgroundColor: p.chipBorder,
              valueColor: AlwaysStoppedAnimation(p.primary),
            ),
          ),
          const SizedBox(height: 4),
          Row(children: [
            Text(
                'verse_of'.trParams(
                    {'a': '${controller.verse.value}', 'b': '$n'}),
                style: small),
            const Spacer(),
            Text(
              done
                  ? 'read_done'.tr
                  : '${'left_verses'.trParams({'n': '${controller.versesLeft}'})}  ·  ${(pr * 100).round()}%',
              style: small.copyWith(
                  color: done ? p.primary : p.subtext,
                  fontWeight: done ? FontWeight.w700 : FontWeight.w400),
            ),
          ]),
        ]);
      }),
    );
  }
}
