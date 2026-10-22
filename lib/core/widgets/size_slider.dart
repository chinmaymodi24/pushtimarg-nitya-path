import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/settings_service.dart';
import '../theme/palette.dart';

/// A-  ───●───  A+   (fixed height: an unbounded Slider fills its parent)
class SizeSlider extends StatelessWidget {
  const SizeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final s = Get.find<SettingsController>();
    final p = context.pal;
    final label = TextStyle(
      fontFamily: 'NotoSans',
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: p.text,
    );
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Text('A-', style: label),
          Expanded(
            child: Obx(
              () => Slider(
                value: s.textScale.value,
                min: SettingsController.minScale,
                max: SettingsController.maxScale,
                onChanged: s.setTextScale,
              ),
            ),
          ),
          Text('A+', style: label),
        ],
      ),
    );
  }
}
