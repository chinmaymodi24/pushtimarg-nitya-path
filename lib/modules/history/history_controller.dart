import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/reading_service.dart';
import '../../data/models/path_model.dart';
import '../../data/models/reading_record.dart';
import '../../data/repository/path_repository.dart';

class HistoryController extends GetxController {
  final search = TextEditingController();
  final query = ''.obs;

  final _repo = Get.find<PathRepository>();
  final reading = Get.find<ReadingController>();

  @override
  void onInit() {
    super.onInit();
    search.addListener(() => query.value = search.text);
  }

  /// Read paths, newest first, filtered by the search text in any script.
  List<(ReadRecord, PathModel)> get items {
    final q = query.value.trim().toLowerCase();
    final out = <(ReadRecord, PathModel)>[];
    for (final r in reading.sorted) {
      final path = _repo.byId(r.pathId);
      if (path == null) continue;
      if (q.isEmpty || path.searchText.contains(q)) out.add((r, path));
    }
    return out;
  }

  @override
  void onClose() {
    search.dispose();
    super.onClose();
  }
}
