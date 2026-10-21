import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/mailer.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';
import '../../routes/app_routes.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return PageScaffold(
      body: Column(
        children: [
          PageHeader(title: 'contact'.tr, onBack: Get.back),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                Text('contact_intro'.tr,
                    style: TextStyle(fontSize: 15.5, height: 1.6, color: p.text)),
                const SizedBox(height: 16),
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              color: p.iconTile,
                              borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.mail_outline_rounded,
                              color: p.heading),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('contact_email'.tr,
                                  style: TextStyle(
                                      fontSize: 13.5, color: p.subtext)),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(AppConfig.contactEmail,
                                    style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w600,
                                        color: p.text)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'copy'.tr,
                          icon: Icon(Icons.copy_rounded, color: p.subtext),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text: AppConfig.contactEmail));
                            Get.rawSnackbar(message: 'copied'.tr);
                          },
                        ),
                      ]),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(
                          child: _Action(
                            icon: Icons.edit_outlined,
                            label: 'write_email'.tr,
                            filled: true,
                            onTap: () =>
                                Mailer.compose(subject: 'Nitya Path'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _Action(
                            icon: Icons.rate_review_outlined,
                            label: 'feedback'.tr,
                            onTap: () => Get.toNamed(Routes.feedback),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Icon(Icons.schedule_rounded, size: 18, color: p.subtext),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('contact_reply'.tr,
                        style: TextStyle(fontSize: 14, color: p.subtext)),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.filled = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final fg = filled ? p.onChipSelected : p.heading;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          height: 46,
          decoration: BoxDecoration(
            gradient: filled ? LinearGradient(colors: p.chipSelected) : null,
            color: filled ? null : p.pill,
            border: filled ? null : Border.all(color: p.pillBorder),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: fg)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
