import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/seva.dart';
import 'path_tile.dart';
import 'paths_controller.dart';

class SevaView extends GetView<SevaController> {
  const SevaView({super.key});

  @override
  Widget build(BuildContext context) {
    final seva = sevaList.firstWhere((s) => s.id == controller.sevaId);
    return Scaffold(
      appBar: AppBar(title: Text('${seva.nameKey.tr} ${'seva_suffix'.tr}')),
      body: controller.paths.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('no_paths'.tr, textAlign: TextAlign.center),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [for (final p in controller.paths) PathTile(p)],
            ),
    );
  }
}
