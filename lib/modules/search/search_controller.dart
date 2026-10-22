import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/translations/app_translations.dart';
import '../../core/utils/search_fold.dart';
import '../../data/models/path_model.dart';
import '../../data/models/seva.dart';
import '../../data/repository/path_repository.dart';
import 'search_index.dart';

/// Searches paths, verse text and meanings, sevas and app features.
class AppSearchController extends GetxController {
  static const verseLimit = 30;

  final field = TextEditingController();
  final query = ''.obs;
  final _repo = Get.find<PathRepository>();

  late final Map<String, String> _sevaHay = {
    for (final s in sevaList)
      s.id: fold(
        [
          s.id,
          for (final l in AppTranslations().keys.values) l[s.nameKey] ?? '',
        ].join(' '),
      ),
  };

  @override
  void onInit() {
    super.onInit();
    field.addListener(() => query.value = field.text);
  }

  String get _q => fold(query.value.trim());

  List<PathModel> get paths {
    final q = _q;
    if (q.isEmpty) return const [];
    return _repo.all.where((p) => p.searchText.contains(q)).toList();
  }

  /// Every matching verse, as (path, verse); callers show the first few.
  List<(PathModel, Verse)> get verses {
    final q = _q;
    if (q.length < 2) return const [];
    return [
      for (final p in _repo.all)
        for (final v in p.verses)
          if (v.searchText.contains(q)) (p, v),
    ];
  }

  List<Seva> get sevas {
    final q = _q;
    if (q.isEmpty) return const [];
    return sevaList.where((s) => _sevaHay[s.id]!.contains(q)).toList();
  }

  List<Feature> get matchedFeatures {
    final q = _q;
    if (q.isEmpty) return const [];
    return features.where((f) => f.haystack.contains(q)).toList();
  }

  @override
  void onClose() {
    field.dispose();
    super.onClose();
  }
}
