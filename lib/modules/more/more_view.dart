import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/logo.dart';
import '../../routes/app_routes.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final pc = context.pc;
    final items = [
      (Icons.info_outline, 'about', 'about_body'),
      (Icons.phone_outlined, 'contact', 'contact_body'),
      (Icons.shield_outlined, 'privacy', 'privacy_body'),
      (Icons.description_outlined, 'terms', 'terms_body'),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(child: AppLogo()),
        const SizedBox(height: 8),
        Text('more_blurb'.tr),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: pc.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: [
            for (final it in items)
              ListTile(
                leading: Icon(it.$1, color: Theme.of(context).colorScheme.primary),
                title: Text(it.$2.tr),
                trailing: Icon(Icons.chevron_right, color: pc.divider),
                onTap: () => Get.toNamed(Routes.info,
                    arguments: {'title': it.$2, 'body': it.$3}),
              ),
          ]),
        ),
        const SizedBox(height: 20),
        Center(child: Text('${'version'.tr} 1.0.0')),
      ],
    );
  }
}
