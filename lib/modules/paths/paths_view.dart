import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/seva.dart';
import 'path_tile.dart';
import 'paths_controller.dart';

/// Tab: every path, grouped by seva.
class PathsView extends GetView<PathsController> {
  const PathsView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('all_paths'.tr,
            style: t.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700, color: t.colorScheme.primary)),
        const SizedBox(height: 12),
        for (final s in sevaList)
          ...() {
            final items = controller.paths.where((p) => p.seva == s.id);
            if (items.isEmpty) return <Widget>[];
            return [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text('${s.nameKey.tr} ${'seva_suffix'.tr}',
                    style: t.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
              for (final p in items) PathTile(p),
            ];
          }(),
      ],
    );
  }
}
