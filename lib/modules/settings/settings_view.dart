import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/choice_chips.dart';
import '../../data/models/enums.dart';
import '../../routes/app_routes.dart';

/// Three language axes, each its own card. Nothing here links one to another.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Get.find<SettingsController>();
    final t = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Text('settings'.tr,
              style: t.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700, color: context.pc.heading)),
        ),
        const SizedBox(height: 16),
        _Card(
          title: 'script'.tr,
          child: Obx(() => ChoiceChips<ReaderScript>(
                values: ReaderScript.values,
                selected: s.script.value,
                label: (v) => v.nativeName,
                onSelected: s.setScript,
              )),
        ),
        _Card(
          title: 'meaning'.tr,
          trailing: Obx(() => Switch(
                value: s.showMeaning.value,
                onChanged: s.setShowMeaning,
              )),
          child: Obx(() => Opacity(
                opacity: s.showMeaning.value ? 1 : 0.4,
                child: IgnorePointer(
                  ignoring: !s.showMeaning.value,
                  child: ChoiceChips<Lang>(
                    values: Lang.values,
                    selected: s.meaningLang.value,
                    label: (v) => v.nativeName,
                    onSelected: s.setMeaningLang,
                  ),
                ),
              )),
        ),
        _Card(
          title: 'app_language'.tr,
          child: Obx(() => ChoiceChips<Lang>(
                values: Lang.values,
                selected: s.uiLang.value,
                label: (v) => v.nativeName,
                onSelected: s.setUiLang,
              )),
        ),
        _Card(
          title: 'text_size'.tr,
          child: Row(children: [
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
          ]),
        ),
        _Card(
          title: 'theme'.tr,
          child: Obx(() => ChoiceChips<ThemeMode>(
                values: const [
                  ThemeMode.light,
                  ThemeMode.dark,
                  ThemeMode.system
                ],
                selected: s.themeMode.value,
                label: (v) => switch (v) {
                  ThemeMode.light => 'light'.tr,
                  ThemeMode.dark => 'dark'.tr,
                  ThemeMode.system => 'system'.tr,
                },
                onSelected: s.setThemeMode,
              )),
        ),
        ListTile(
          title: Text('type_specimen'.tr),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Get.toNamed(Routes.specimen),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child, this.trailing});
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.pc.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ),
            ?trailing,
          ]),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
