import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/dialer.dart';
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
                Text(
                  'contact_intro'.tr,
                  style: TextStyle(fontSize: 15.5, height: 1.6, color: p.text),
                ),
                const SizedBox(height: 16),
                _ContactCard(
                  icon: Icons.mail_outline_rounded,
                  label: 'contact_email'.tr,
                  value: AppConfig.contactEmail,
                  actionIcon: Icons.edit_outlined,
                  actionLabel: 'write_email'.tr,
                  onAction: () => Mailer.compose(subject: 'Nitya Path'),
                ),
                const SizedBox(height: 14),
                _ContactCard(
                  icon: Icons.call_outlined,
                  label: 'contact_phone'.tr,
                  value: AppConfig.contactPhoneDisplay,
                  actionIcon: Icons.call_rounded,
                  actionLabel: 'call'.tr,
                  onAction: Dialer.call,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => Get.toNamed(Routes.feedback),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: p.pill,
                      side: BorderSide(color: p.pillBorder),
                      shape: const StadiumBorder(),
                    ),
                    icon: Icon(Icons.rate_review_outlined, color: p.heading),
                    label: Text(
                      'feedback'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: p.heading,
                      ),
                    ),
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

/// One way to reach us: label, value, copy, and a primary action.
class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.actionIcon,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon, actionIcon;
  final String label, value, actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: p.iconTile,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: p.heading),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(fontSize: 13.5, color: p.subtext),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600,
                          color: p.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'copy'.tr,
                icon: Icon(Icons.copy_rounded, color: p.subtext),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  Get.rawSnackbar(message: 'copied'.tr);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 46,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: p.chipSelected),
                borderRadius: BorderRadius.circular(23),
              ),
              child: TextButton.icon(
                onPressed: onAction,
                icon: Icon(actionIcon, size: 19, color: p.onChipSelected),
                label: Text(
                  actionLabel,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: p.onChipSelected,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
