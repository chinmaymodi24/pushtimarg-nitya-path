import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/search_fold.dart';
import '../../data/models/category.dart';
import '../../data/models/path_model.dart';
import '../../data/repository/path_repository.dart';

/// The "Paths" tab: sections, and a search across every path.
class PathsTabController extends GetxController {
  final _repo = Get.find<PathRepository>();

  final search = TextEditingController();
  final query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    search.addListener(() => query.value = search.text);
  }

  List<PathModel> pathsIn(PathCategory c) => _repo.forCategory(c.id);

  /// Matching paths grouped by section, in section order.
  List<(PathCategory, List<PathModel>)> get results {
    final q = fold(query.value.trim());
    return [
      for (final c in categoryList)
        if (pathsIn(c).where((p) => p.searchText.contains(q)).toList()
            case final items when items.isNotEmpty)
          (c, items),
    ];
  }

  @override
  void onClose() {
    search.dispose();
    super.onClose();
  }
}
