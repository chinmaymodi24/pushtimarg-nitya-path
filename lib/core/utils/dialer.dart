import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';

abstract class Dialer {
  /// Opens the phone app with the number ready; copies it when there is none.
  static Future<void> call() async {
    var ok = false;
    try {
      ok = await launchUrl(Uri(scheme: 'tel', path: AppConfig.contactPhone));
    } catch (_) {
      ok = false;
    }
    if (!ok) {
      await Clipboard.setData(
        const ClipboardData(text: AppConfig.contactPhoneDisplay),
      );
      Get.rawSnackbar(
        message: '${'no_dialer'.tr} ${AppConfig.contactPhoneDisplay}',
        duration: const Duration(seconds: 4),
      );
    }
  }
}
