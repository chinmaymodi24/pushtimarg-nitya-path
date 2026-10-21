import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../theme/palette.dart';

/// "There may be errors; we are improving" with a way to report one.
class DisclaimerNote extends StatelessWidget {
  const DisclaimerNote({super.key, this.pathTitle});

  /// When set, the report button pre-fills the feedback form for this path.
  final String? pathTitle;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: p.iconTile,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.pillBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.volunteer_activism_outlined, size: 20, color: p.heading),
            const SizedBox(width: 8),
            Text('disclaimer_title'.tr,
                style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: p.heading)),
          ]),
          const SizedBox(height: 6),
          Text('disclaimer_body'.tr,
              style: TextStyle(fontSize: 14.5, height: 1.6, color: p.text)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => Get.toNamed(Routes.feedback, arguments: {
                'type': pathTitle == null ? 'suggestion' : 'path_error',
                if (pathTitle != null) 'path': pathTitle,
              }),
              icon: Icon(Icons.flag_outlined, size: 18, color: p.primary),
              label: Text('report_error'.tr,
                  style: TextStyle(
                      color: p.primary, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
