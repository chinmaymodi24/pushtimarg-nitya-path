import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/script_converter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';
import '../../data/models/enums.dart';

/// Gujarati, Devanagari and Roman at the smallest and largest user sizes.
class SpecimenView extends StatelessWidget {
  const SpecimenView({super.key});

  static const _sample = 'नमामि यमुनामहं सकलसिद्धिहेतुं मुदा';

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return PageScaffold(
      body: Column(
        children: [
          PageHeader(title: 'type_specimen'.tr, onBack: Get.back),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                for (final script in ReaderScript.values)
                  for (final (label, scale) in [
                    ('smallest', SettingsController.minScale),
                    ('largest', SettingsController.maxScale),
                  ])
                    AppCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${script.nativeName} · ${label.tr} · ${(21 * scale).round()}px',
                            style: TextStyle(
                              color: p.heading,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ScriptConverter.convert(_sample, script),
                            style: AppTheme.verse(script, 21 * scale, p.verse),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
