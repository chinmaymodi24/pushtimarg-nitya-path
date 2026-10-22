import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import '../../core/theme/palette.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';
import '../../data/legal/legal_content.dart';

/// Privacy policy or terms, in the app language. Argument: 'privacy'|'terms'.
class LegalView extends StatelessWidget {
  const LegalView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final kind = Get.arguments as String;
    final s = Get.find<SettingsController>();
    return PageScaffold(
      body: Column(
        children: [
          PageHeader(title: kind.tr, onBack: Get.back),
          Expanded(
            child: Obx(() {
              final doc = kind == 'privacy'
                  ? LegalContent.privacy(s.uiLang.value)
                  : LegalContent.terms(s.uiLang.value);
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                children: [
                  Text(
                    '${'last_updated'.tr}: ${doc.updated}',
                    style: TextStyle(fontSize: 13.5, color: p.subtext),
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (i, (h, b)) in doc.sections.indexed) ...[
                          Text(
                            '${i + 1}. $h',
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: p.heading,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            b,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.7,
                              color: p.text,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
