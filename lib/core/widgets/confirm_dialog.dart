import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/palette.dart';

/// Standard Material 3 confirmation: title, message, actions at the end.
Future<void> showConfirm({
  required String title,
  required String message,
  required String confirmLabel,
  required VoidCallback onConfirm,
  IconData? icon,
  bool destructive = true,
}) {
  return Get.dialog<void>(
    Builder(builder: (context) {
      final p = context.pal;
      final cs = Theme.of(context).colorScheme;
      return AlertDialog(
        icon: icon == null ? null : Icon(icon, color: p.heading),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('cancel'.tr),
          ),
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: destructive ? cs.error : p.primary),
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(confirmLabel),
          ),
        ],
      );
    }),
  );
}
