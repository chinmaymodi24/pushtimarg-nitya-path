import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/page_scaffold.dart';
import 'settings_view.dart';

/// Settings opened from the reader's gear icon.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      PageScaffold(body: SettingsView(onBack: Get.back));
}
