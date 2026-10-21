import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import '../../core/theme/palette.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/choice_chips.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/size_slider.dart';
import '../../data/models/enums.dart';
import '../../routes/app_routes.dart';

/// Three language axes, each in its own card. None changes another.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final s = Get.find<SettingsController>();
    final p = context.pal;
    return Column(
      children: [
        PageHeader(title: 'settings'.tr, onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              _Section(
                title: 'script'.tr,
                child: Obx(() => ChoiceChips<ReaderScript>(
                      values: ReaderScript.values,
                      selected: s.script.value,
                      label: (v) => v.nativeName,
                      onSelected: s.setScript,
                    )),
              ),
              _Section(
                title: 'meaning'.tr,
                trailing: Obx(() => Switch(
                      value: s.showMeaning.value,
                      onChanged: s.setShowMeaning,
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.translate_rounded, size: 18, color: p.heading),
                      const SizedBox(width: 8),
                      Text('show_meaning'.tr,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: p.text)),
                    ]),
                    const SizedBox(height: 12),
                    Obx(() => ChoiceChips<Lang>(
                          values: Lang.values,
                          selected: s.meaningLang.value,
                          enabled: s.showMeaning.value,
                          label: (v) => v.nativeName,
                          onSelected: s.setMeaningLang,
                        )),
                  ],
                ),
              ),
              _Section(
                title: 'app_language'.tr,
                child: Obx(() => ChoiceChips<Lang>(
                      values: Lang.values,
                      selected: s.uiLang.value,
                      label: (v) => v.nativeName,
                      onSelected: s.setUiLang,
                    )),
              ),
              _Section(title: 'text_size'.tr, child: const SizeSlider()),
              _Section(
                title: 'theme'.tr,
                child: Obx(() => ChoiceChips<ThemeMode>(
                      values: const [
                        ThemeMode.light,
                        ThemeMode.dark,
                        ThemeMode.system,
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
              AppCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                onTap: () => Get.toNamed(Routes.specimen),
                child: Row(children: [
                  Icon(Icons.text_fields_rounded, color: p.heading),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('type_specimen'.tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: p.text)),
                  ),
                  Icon(Icons.chevron_right_rounded, color: p.subtext),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return AppCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            child: Row(children: [
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: p.text)),
              ),
              trailing ??
                  Icon(Icons.chevron_right_rounded, color: p.subtext),
            ]),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
