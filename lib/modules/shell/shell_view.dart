import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../home/home_view.dart';
import '../more/more_view.dart';
import '../paths/paths_view.dart';
import '../settings/settings_view.dart';
import 'shell_controller.dart';

class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'nav_home'),
    (Icons.menu_book_outlined, Icons.menu_book_rounded, 'nav_paths'),
    (Icons.settings_outlined, Icons.settings_rounded, 'nav_settings'),
    (Icons.menu_rounded, Icons.menu_rounded, 'nav_more'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(() => Scaffold(
          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: controller.index.value,
              children: const [
                HomeView(),
                PathsView(),
                SettingsView(),
                MoreView(),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.index.value,
            onDestinationSelected: controller.go,
            destinations: [
              for (final it in _items)
                NavigationDestination(
                  icon: Icon(it.$1, color: context.pc.meaning),
                  selectedIcon: Icon(it.$2, color: cs.primary),
                  label: it.$3.tr,
                ),
            ],
          ),
        ));
  }
}
