import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/motion.dart';
import '../../core/widgets/page_scaffold.dart';
import '../home/home_view.dart';
import '../japa/japa_view.dart';
import '../more/more_view.dart';
import '../paths/paths_view.dart';
import 'shell_controller.dart';

class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    // Back on another tab returns to Home; back on Home asks before exiting.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (controller.index.value != 0) {
          controller.go(0);
          return;
        }
        if (Get.isDialogOpen ?? false) return;
        showConfirm(
          title: 'exit_t'.tr,
          message: 'exit_m'.tr,
          confirmLabel: 'exit'.tr,
          onConfirm: SystemNavigator.pop,
        );
      },
      child: Obx(
        () => PageScaffold(
          bottom: AppBottomNav(current: controller.index.value),
          // Keyed by tab, so each switch fades the new tab in while the
          // stack keeps every tab's scroll position.
          body: TweenAnimationBuilder<double>(
            key: ValueKey(controller.index.value),
            tween: Tween(begin: 0, end: 1),
            duration: Motion.medium,
            curve: Motion.curve,
            builder: (_, t, child) => Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - t)),
                child: child,
              ),
            ),
            child: IndexedStack(
              index: controller.index.value,
              children: [
                const HomeView(),
                const PathsView(),
                JapaView(onBack: () => controller.go(0)),
                const MoreView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
