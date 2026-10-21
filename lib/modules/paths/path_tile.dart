import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/script_converter.dart';
import '../../data/models/path_model.dart';
import '../../routes/app_routes.dart';

class PathTile extends StatelessWidget {
  const PathTile(this.path, {super.key});
  final PathModel path;

  @override
  Widget build(BuildContext context) {
    final pc = context.pc;
    final settings = Get.find<SettingsController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: pc.card,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Get.toNamed(Routes.reader, arguments: path.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final s = settings.script.value;
                    return Text(
                      ScriptConverter.convert(path.titleDev, s),
                      style: AppTheme.verseStyle(s, 19, pc.verse)
                          .copyWith(height: 1.4, fontWeight: FontWeight.w700),
                    );
                  }),
                ),
                Icon(Icons.chevron_right, color: pc.divider),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
