import 'package:flutter/material.dart';

import 'settings_view.dart';

/// Settings opened from the reader's gear icon (the tab has its own shell).
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(), body: const SettingsView());
}
