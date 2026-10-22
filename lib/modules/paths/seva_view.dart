import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/palette.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';
import '../../core/widgets/svg_icon.dart';
import '../../data/models/seva.dart';
import 'path_tile.dart';
import 'paths_controller.dart';

class SevaView extends GetView<SevaController> {
  const SevaView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final seva = sevaList.firstWhere((s) => s.id == controller.sevaId);
    return PageScaffold(
      bottom: const AppBottomNav(current: 0),
      body: Column(
        children: [
          PageHeader(
            title: '${seva.nameKey.tr} ${'seva_suffix'.tr}',
            onBack: Get.back,
          ),
          Expanded(
            child: controller.paths.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Opacity(
                            opacity: 0.6,
                            child: SvgIcon(seva.icon, size: 64),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'no_paths'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: p.subtext),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [for (final x in controller.paths) PathTile(x)],
                  ),
          ),
        ],
      ),
    );
  }
}
