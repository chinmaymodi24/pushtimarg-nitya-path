import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/script_converter.dart';
import '../../data/models/enums.dart';
import '../../data/models/path_model.dart';
import '../../routes/app_routes.dart';
import 'reader_controller.dart';

class ReaderView extends GetView<ReaderController> {
  const ReaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Get.find<SettingsController>();
    final pc = context.pc;
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              ScriptConverter.convert(
                  controller.path.titleDev, s.script.value),
              style: AppTheme.verseStyle(s.script.value, 20, pc.heading)
                  .copyWith(height: 1.3, fontWeight: FontWeight.w700),
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Get.toNamed(Routes.settings),
          ),
        ],
      ),
      body: Obx(() {
        final script = s.script.value;
        final scale = s.textScale.value;
        final showMeaning = s.showMeaning.value;
        final lang = s.meaningLang.value;
        final verses = controller.path.verses;
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: verses.length,
          itemBuilder: (_, i) => _VerseBlock(
            verse: verses[i],
            script: script,
            scale: scale,
            meaningLang: showMeaning ? lang : null,
          ),
        );
      }),
      bottomNavigationBar: const _ReaderBar(),
    );
  }
}

class _VerseBlock extends StatelessWidget {
  const _VerseBlock({
    required this.verse,
    required this.script,
    required this.scale,
    required this.meaningLang,
  });

  final Verse verse;
  final ReaderScript script;
  final double scale;
  final Lang? meaningLang;

  @override
  Widget build(BuildContext context) {
    final pc = context.pc;
    final meaning = meaningLang == null ? null : verse.meaning(meaningLang!);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ScriptConverter.verseMark(verse.number, script),
            textAlign: TextAlign.center,
            style: AppTheme.verseStyle(script, 15 * scale, pc.heading),
          ),
          Text(
            ScriptConverter.convert(verse.dev, script),
            textAlign: TextAlign.center,
            style: AppTheme.verseStyle(script, 21 * scale, pc.verse),
          ),
          if (meaning != null) ...[
            const SizedBox(height: 14),
            Text(
              'meaning_title'.tr,
              style: AppTheme.meaningStyle(
                      meaningLang!, 16 * scale, pc.heading)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            Text(meaning,
                style: AppTheme.meaningStyle(
                    meaningLang!, 15 * scale, pc.meaning)),
          ],
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: Divider(color: pc.divider)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.local_florist_outlined,
                  size: 16, color: pc.divider),
            ),
            Expanded(child: Divider(color: pc.divider)),
          ]),
        ],
      ),
    );
  }
}

/// A- slider A+ , meaning toggle, theme toggle. No audio-style controls.
class _ReaderBar extends StatelessWidget {
  const _ReaderBar();

  @override
  Widget build(BuildContext context) {
    final s = Get.find<SettingsController>();
    final pc = context.pc;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: pc.card,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              const Text('A-', style: TextStyle(fontWeight: FontWeight.w700)),
              Expanded(
                child: Obx(() => Slider(
                      value: s.textScale.value,
                      min: SettingsController.minScale,
                      max: SettingsController.maxScale,
                      onChanged: s.setTextScale,
                    )),
              ),
              const Text('A+', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Obx(() => OutlinedButton(
                    onPressed: () => s.setShowMeaning(!s.showMeaning.value),
                    child: Text(s.showMeaning.value
                        ? 'hide_meaning'.tr
                        : 'show_meaning_btn'.tr),
                  )),
              IconButton(
                icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                onPressed: () => s.toggleDark(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
