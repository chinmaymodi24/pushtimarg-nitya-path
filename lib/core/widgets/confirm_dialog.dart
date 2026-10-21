import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/palette.dart';

/// Plain Material confirmation, like Android's own: a question as the
/// title, one line on what happens, and two text actions at the end.
Future<void> showConfirm({
  required String title,
  required String message,
  required String confirmLabel,
  required VoidCallback onConfirm,
  bool destructive = true,
}) {
  return Get.dialog<void>(
    Builder(builder: (context) {
      final p = context.pal;
      final cs = Theme.of(context).colorScheme;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: Get.back, child: Text('cancel'.tr)),
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
