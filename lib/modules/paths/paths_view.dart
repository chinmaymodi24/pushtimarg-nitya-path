import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/palette.dart';
import '../../core/widgets/page_header.dart';
import '../../data/models/seva.dart';
import 'path_tile.dart';
import 'paths_controller.dart';

/// Tab: every path, grouped by seva.
class PathsView extends GetView<PathsController> {
  const PathsView({super.key, this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Column(
      children: [
        PageHeader(title: 'all_paths'.tr, onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              for (final s in sevaList)
                ...() {
                  final items =
                      controller.paths.where((x) => x.seva == s.id).toList();
                  if (items.isEmpty) return <Widget>[];
                  return [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 6, 4, 10),
                      child: Text('${s.nameKey.tr} ${'seva_suffix'.tr}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: p.heading)),
                    ),
                    for (final x in items) PathTile(x),
                  ];
                }(),
            ],
          ),
        ),
      ],
    );
  }
}
