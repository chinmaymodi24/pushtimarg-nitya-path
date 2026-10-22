import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';
import '../../data/models/category.dart';
import '../../data/repository/path_repository.dart';
import 'path_row.dart';

/// Every path in one section. Argument: the section id.
class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = categoryById(Get.arguments as String);
    final items = Get.find<PathRepository>().forCategory(c.id);
    return PageScaffold(
      body: Column(
        children: [
          PageHeader(title: c.nameKey.tr, onBack: Get.back),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [PathGroupCard(items: items)],
            ),
          ),
        ],
      ),
    );
  }
}
