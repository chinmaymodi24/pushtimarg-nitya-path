import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';

abstract class Mailer {
  /// Opens the user's email app with the message filled in. When there is
  /// no email app, copies the address and tells the user.
  static Future<bool> compose({String subject = '', String body = ''}) async {
    final uri = Uri.parse('mailto:${AppConfig.contactEmail}'
        '?subject=${Uri.encodeComponent(subject)}'
        '&body=${Uri.encodeComponent(body)}');
    var ok = false;
    try {
      ok = await launchUrl(uri);
    } catch (_) {
      ok = false;
    }
    if (!ok) {
      await Clipboard.setData(const ClipboardData(text: AppConfig.contactEmail));
      Get.rawSnackbar(
        message: '${'no_email_app'.tr} ${AppConfig.contactEmail}',
        duration: const Duration(seconds: 4),
      );
    }
    return ok;
  }
}
