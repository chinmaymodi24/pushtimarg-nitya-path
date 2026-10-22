import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/shell/shell_controller.dart';
import '../../routes/app_routes.dart';
import '../theme/palette.dart';

/// Floating white tab bar; the selected tab's icon sits in a saffron pill.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.current});
  final int current;

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'nav_home'),
    (Icons.menu_book_outlined, Icons.menu_book_rounded, 'nav_paths'),
    (
      Icons.radio_button_unchecked_rounded,
      Icons.blur_circular_rounded,
      'nav_mala',
    ),
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
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 12),
      child: Container(
        height: 66,
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 4),
        decoration: BoxDecoration(
          color: p.navBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: p.cardBorder),
          boxShadow: [
            BoxShadow(
              color: p.shadow,
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            for (var i = 0; i < _items.length; i++)
              Expanded(
                child: InkResponse(
                  onTap: () => open(i),
                  radius: 36,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: i == current ? p.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          i == current ? _items[i].$2 : _items[i].$1,
                          size: 23,
                          color: i == current ? Colors.white : p.subtext,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[i].$3.tr,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
