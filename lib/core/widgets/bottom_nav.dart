import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/shell/shell_controller.dart';
import '../../routes/app_routes.dart';
import '../theme/palette.dart';
import 'motion.dart';

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
    // The bar has a fixed height, so its labels stop growing at 1.3x.
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: scaler),
      child: SafeArea(
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
                  // No ink splash: the sliding pill is the tap feedback.
                  child: Semantics(
                    button: true,
                    selected: i == current,
                    label: _items[i].$3.tr,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => open(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: Motion.medium,
                            curve: Motion.curve,
                            padding: EdgeInsets.symmetric(
                              horizontal: i == current ? 18 : 12,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: i == current
                                  ? p.primary
                                  : p.primary.withValues(alpha: 0),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: AnimatedScale(
                              scale: i == current ? 1.08 : 1,
                              duration: Motion.medium,
                              curve: Curves.easeOutBack,
                              child: Icon(
                                i == current ? _items[i].$2 : _items[i].$1,
                                size: 23,
                                color: i == current ? Colors.white : p.subtext,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedDefaultTextStyle(
                            duration: Motion.fast,
                            style: TextStyle(
                              fontFamily: DefaultTextStyle.of(context)
                                  .style
                                  .fontFamily,
                              fontSize: 11.5,
                              fontWeight: i == current
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: i == current ? p.primary : p.subtext,
                            ),
                            child: ExcludeSemantics(
                              child: Text(_items[i].$3.tr),
                            ),
                          ),
                        ],
                      ),
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
