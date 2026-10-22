import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/palette.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';
import 'feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    InputDecoration deco(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: p.subtext, fontSize: 14.5),
      filled: true,
      fillColor: p.chip,
      contentPadding: const EdgeInsets.all(14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: p.chipBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: p.primary, width: 1.5),
      ),
    );
    final label = TextStyle(
      fontSize: 15.5,
      fontWeight: FontWeight.w700,
      color: p.text,
    );
    return PageScaffold(
      body: Column(
        children: [
          PageHeader(title: 'feedback'.tr, onBack: Get.back),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                Text(
                  'fb_intro'.tr,
                  style: TextStyle(fontSize: 15, height: 1.6, color: p.text),
                ),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('fb_type'.tr, style: label),
                      const SizedBox(height: 10),
                      Obx(
                        () => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final t in FeedbackController.types)
                              ChoiceChip(
                                label: Text('fb_$t'.tr),
                                selected: controller.type.value == t,
                                onSelected: (_) => controller.type.value = t,
                                showCheckmark: false,
                                selectedColor: p.primary,
                                backgroundColor: p.chip,
                                side: BorderSide(
                                  color: controller.type.value == t
                                      ? p.primary
                                      : p.chipBorder,
                                ),
                                shape: const StadiumBorder(),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: controller.type.value == t
                                      ? p.onChipSelected
                                      : p.text,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (controller.pathTitle != null) ...[
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book_outlined,
                              size: 18,
                              color: p.heading,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${'fb_path'.tr}: ${controller.pathTitle}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: p.heading,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text('fb_message'.tr, style: label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.message,
                        minLines: 5,
                        maxLines: 10,
                        style: TextStyle(fontSize: 16, color: p.text),
                        decoration: deco('fb_hint'.tr),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: controller.name,
                        style: TextStyle(fontSize: 16, color: p.text),
                        decoration: deco('fb_name'.tr),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: p.chipSelected),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: TextButton.icon(
                      onPressed: controller.send,
                      icon: Icon(Icons.send_rounded, color: p.onChipSelected),
                      label: Text(
                        'fb_send'.tr,
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: p.onChipSelected,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'fb_note'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, height: 1.5, color: p.subtext),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
