import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';

abstract class WhatsApp {
  /// Opens a WhatsApp chat with us, the message typed in. When WhatsApp
  /// cannot be opened, copies the number and says so.
  static Future<void> chat([String text = '']) async {
    final uri = Uri.https('wa.me', '/${AppConfig.whatsappNumber}', {
      if (text.isNotEmpty) 'text': text,
    });
    var ok = false;
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok) {
      await Clipboard.setData(
        const ClipboardData(text: AppConfig.contactPhoneDisplay),
      );
      Get.rawSnackbar(
        message: '${'no_whatsapp'.tr} ${AppConfig.contactPhoneDisplay}',
        duration: const Duration(seconds: 4),
      );
    }
  }
}
