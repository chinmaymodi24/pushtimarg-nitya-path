import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/script_converter.dart';
import '../../core/widgets/choice_chips.dart';
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
    final p = context.pal;
    return PageScaffold(
      decoration: CornerFlourishPainter(p.gold.withValues(alpha: 0.5),
          top: MediaQuery.paddingOf(context).top + 58),
      bottom: const _ReaderBar(),
      body: Column(
        children: [
          Obx(() => PageHeader(
                title: controller.path.title(s.uiLang.value),
                onBack: Get.back,
                actions: [
                  IconButton(
                    tooltip: 'choose_script'.tr,
                    icon: Icon(Icons.menu_book_outlined, color: p.heading),
                    onPressed: _openScriptSheet,
                  ),
                  IconButton(
                    icon: Icon(Icons.settings_outlined, color: p.heading),
                    onPressed: () => Get.toNamed(Routes.settings),
                  ),
                ],
              )),
          Expanded(
            child: Obx(() {
              final script = s.script.value;
              final scale = s.textScale.value;
              final lang = s.showMeaning.value ? s.meaningLang.value : null;
              final verses = controller.path.verses;
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 32),
                itemCount: verses.length,
                itemBuilder: (_, i) => _VerseBlock(
                  verse: verses[i],
                  script: script,
                  scale: scale,
                  meaningLang: lang,
                  last: i == verses.length - 1,
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
