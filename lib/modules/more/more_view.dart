import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/palette.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/disclaimer_note.dart';
import '../../core/widgets/tab_header.dart';
import '../../routes/app_routes.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  static const _groups = [
    [
      (Icons.settings_outlined, 'settings', Routes.settings, null),
      (Icons.favorite_border_rounded, 'wishlist', Routes.wishlist, null),
      (Icons.history_rounded, 'history', Routes.history, null),
    ],
    [
      (Icons.rate_review_outlined, 'feedback', Routes.feedback, null),
      (Icons.call_outlined, 'contact', Routes.contact, null),
      (Icons.account_circle_outlined, 'about', Routes.about, null),
    ],
    [
      (Icons.shield_outlined, 'privacy', Routes.legal, 'privacy'),
      (Icons.description_outlined, 'terms', Routes.legal, 'terms'),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return ListView(
      // Header sits edge to edge like every other page; content is inset.
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        TabHeader(title: 'more'.tr),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 4),
              for (final g in _groups) ...[
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (var i = 0; i < g.length; i++) ...[
                        if (i > 0)
                          Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: p.cardBorder,
                          ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          leading: Icon(g[i].$1, color: p.heading),
                          title: Text(
                            g[i].$2.tr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: p.text,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: p.subtext,
                          ),
                          onTap: () => Get.toNamed(g[i].$3, arguments: g[i].$4),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],
              const DisclaimerNote(),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  '${'version'.tr} ${AppConfig.version}',
                  style: TextStyle(fontSize: 14, color: p.subtext),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
