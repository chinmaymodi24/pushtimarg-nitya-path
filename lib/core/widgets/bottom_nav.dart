import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/shell/shell_controller.dart';
import '../../routes/app_routes.dart';
import '../theme/palette.dart';

/// Rounded white tab bar shared by the shell and pushed list pages.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.current});
  final int current;

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'nav_home'),
    (Icons.menu_book_outlined, Icons.menu_book_rounded, 'nav_paths'),
    (Icons.settings_outlined, Icons.settings_rounded, 'nav_settings'),
    (Icons.menu_rounded, Icons.menu_rounded, 'nav_more'),
  ];

  static void open(int i) {
    if (Get.currentRoute != Routes.shell) {
      Get.until((r) => r.settings.name == Routes.shell);
    }
    Get.find<ShellController>().go(i);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Container(
      decoration: BoxDecoration(
        color: p.navBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(color: p.shadow, blurRadius: 18, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: InkResponse(
                    onTap: () => open(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(i == current ? _items[i].$2 : _items[i].$1,
                            size: 27,
                            color: i == current ? p.primary : p.subtext),
                        const SizedBox(height: 3),
                        Text(
                          _items[i].$3.tr,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: i == current
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: i == current ? p.primary : p.subtext,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
