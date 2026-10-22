import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/confirm_dialog.dart';
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
          body: IndexedStack(
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
    );
  }
}
