import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/palette.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, String>;
    final p = context.pal;
    return PageScaffold(
      body: Column(
        children: [
          PageHeader(title: args['title']!.tr, onBack: Get.back),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppCard(
              padding: const EdgeInsets.all(20),
              child: Text(args['body']!.tr,
                  style: TextStyle(fontSize: 16, height: 1.8, color: p.text)),
            ),
          ),
        ],
      ),
    );
  }
}
