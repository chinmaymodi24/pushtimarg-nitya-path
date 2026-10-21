import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/palette.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/logo_header.dart';
import '../../core/widgets/page_header.dart';
import '../../routes/app_routes.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key, this.onBack});
  final VoidCallback? onBack;

  static const _items = [
    (Icons.account_circle_outlined, 'about', 'about_body'),
    (Icons.call_outlined, 'contact', 'contact_body'),
    (Icons.shield_outlined, 'privacy', 'privacy_body'),
    (Icons.description_outlined, 'terms', 'terms_body'),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Column(
      children: [
        PageHeader(title: 'more'.tr, onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              const LogoHeader(height: 190, logoWidth: 220),
              const SizedBox(height: 14),
              Text('more_blurb'.tr,
                  style: TextStyle(fontSize: 15, height: 1.7, color: p.text)),
              const SizedBox(height: 18),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(children: [
                  for (var i = 0; i < _items.length; i++) ...[
                    if (i > 0)
                      Divider(height: 1, indent: 16, endIndent: 16, color: p.cardBorder),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      leading: Icon(_items[i].$1, color: p.heading),
                      title: Text(_items[i].$2.tr,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: p.text)),
                      trailing:
                          Icon(Icons.chevron_right_rounded, color: p.subtext),
                      onTap: () => Get.toNamed(Routes.info, arguments: {
                        'title': _items[i].$2,
                        'body': _items[i].$3,
                      }),
                    ),
                  ],
                ]),
              ),
              const SizedBox(height: 22),
              Center(
                child: Text('${'version'.tr} 1.0.0',
                    style: TextStyle(fontSize: 14, color: p.subtext)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
