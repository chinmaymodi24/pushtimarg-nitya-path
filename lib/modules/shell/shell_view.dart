import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/page_scaffold.dart';
import '../home/home_view.dart';
import '../more/more_view.dart';
import '../paths/paths_view.dart';
import '../settings/settings_view.dart';
import 'shell_controller.dart';

class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PageScaffold(
          bottom: AppBottomNav(current: controller.index.value),
          body: IndexedStack(
            index: controller.index.value,
            children: [
              const HomeView(),
              PathsView(onBack: () => controller.go(0)),
              SettingsView(onBack: () => controller.go(0)),
              MoreView(onBack: () => controller.go(0)),
            ],
          ),
        ));
  }
}
