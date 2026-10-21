import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/script_converter.dart';
import '../../data/models/enums.dart';

/// Gujarati, Devanagari and Roman at the smallest and largest user sizes.
class SpecimenView extends StatelessWidget {
  const SpecimenView({super.key});

  static const _sample = 'नमामि यमुनामहं सकलसिद्धिहेतुं मुदा';

  @override
  Widget build(BuildContext context) {
    final pc = context.pc;
    return Scaffold(
      appBar: AppBar(title: Text('type_specimen'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final script in ReaderScript.values)
            for (final (label, scale) in [
              ('smallest', SettingsController.minScale),
              ('largest', SettingsController.maxScale),
            ])
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: pc.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${script.nativeName} · ${label.tr} (${scale}x)',
                        style: TextStyle(color: pc.heading)),
                    Text(
                      ScriptConverter.convert(_sample, script),
                      style: AppTheme.verseStyle(script, 21 * scale, pc.verse),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
