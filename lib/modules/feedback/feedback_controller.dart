import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/app_config.dart';
import '../../core/services/settings_service.dart';
import '../../core/utils/mailer.dart';
import '../../core/utils/whatsapp.dart';

class FeedbackController extends GetxController {
  static const types = ['suggestion', 'path_error', 'meaning_error', 'other'];

  final type = 'suggestion'.obs;
  final message = TextEditingController();
  final name = TextEditingController();
  String? pathTitle;

  @override
  void onInit() {
    super.onInit();
    final a = Get.arguments;
    if (a is Map) {
      if (types.contains(a['type'])) type.value = a['type'] as String;
      pathTitle = a['path'] as String?;
    }
  }

  /// Subject and body for the message, or null when nothing was typed.
  (String, String)? _compose() {
    if (message.text.trim().isEmpty) {
      Get.rawSnackbar(message: 'fb_empty'.tr);
      return null;
    }
    final s = Get.find<SettingsController>();
    final label = 'fb_${type.value}'.tr;
    final body = StringBuffer()
      ..writeln(message.text.trim())
      ..writeln()
      ..writeln('---');
    if (name.text.trim().isNotEmpty) body.writeln('Name: ${name.text.trim()}');
    if (pathTitle != null) body.writeln('Path: $pathTitle');
    body
      ..writeln('Type: $label')
      ..writeln(
        'Script: ${s.script.value.name}, '
        'Meaning: ${s.meaningLang.value.name}, UI: ${s.uiLang.value.name}',
      )
      ..writeln('App version: ${AppConfig.version}');
    final subject =
        'Nitya Path - $label'
        '${pathTitle == null ? '' : ' - $pathTitle'}';
    return (subject, body.toString());
  }

  Future<void> sendWhatsApp() async {
    final m = _compose();
    if (m != null) await WhatsApp.chat('${m.$1}\n\n${m.$2}');
  }

  Future<void> sendEmail() async {
    final m = _compose();
    if (m != null) await Mailer.compose(subject: m.$1, body: m.$2);
  }

  @override
  void onClose() {
    message.dispose();
    name.dispose();
    super.onClose();
  }
}
