import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/palette.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/disclaimer_note.dart';
import '../../core/widgets/logo_header.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return PageScaffold(
      body: Column(
        children: [
          PageHeader(title: 'about'.tr, onBack: Get.back),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                const Center(child: AppLogo(width: 220)),
                const SizedBox(height: 16),
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Text('more_blurb'.tr,
                      style: TextStyle(fontSize: 15.5, height: 1.75, color: p.text)),
                ),
                const SizedBox(height: 14),
                const DisclaimerNote(),
                const SizedBox(height: 22),
                Center(
                  child: Text('${'made_with'.tr} 🙏',
                      style: TextStyle(fontSize: 14.5, color: p.heading)),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text('${'version'.tr} ${AppConfig.version}',
                      style: TextStyle(fontSize: 13.5, color: p.subtext)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
