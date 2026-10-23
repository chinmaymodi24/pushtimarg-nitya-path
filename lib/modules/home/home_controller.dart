import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/path_model.dart';
import '../../data/repository/path_repository.dart';

/// Keeps Home's greeting and "seva now" in step with the clock.
class HomeController extends GetxController {
  final now = DateTime.now().obs;
  Timer? _tick;

  /// Today's verse: walks through every verse that has text, one per day.
  (PathModel, Verse)? get verseOfDay {
    final all = [
      for (final p in Get.find<PathRepository>().all)
        for (final v in p.verses) (p, v),
    ];
    if (all.isEmpty) return null;
    final t = now.value;
    final day =
        DateTime.utc(t.year, t.month, t.day).millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;
    return all[day % all.length];
  }

  @override
  void onInit() {
    super.onInit();
    _tick = Timer.periodic(
      const Duration(seconds: 30),
      (_) => now.value = DateTime.now(),
    );
  }

  @override
  void onClose() {
    _tick?.cancel();
    super.onClose();
  }
}
