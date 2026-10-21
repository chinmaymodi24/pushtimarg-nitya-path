import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/reading_record.dart';
import '../config/app_config.dart';

/// "Shri Krishnah Sharanam Mama" counter. Everything stays on the device.
class JapaController extends GetxController {
  final _box = GetStorage();

  /// Beads counted in the current mala (0..107).
  final count = 0.obs;

  /// Completed malas, newest first.
  final history = <MalaEntry>[].obs;

  DateTime? _startedAt;

  @override
  void onInit() {
    super.onInit();
    count.value = _box.read<int>('japa_count') ?? 0;
    final started = _box.read<int>('japa_started');
    _startedAt =
        started == null ? null : DateTime.fromMillisecondsSinceEpoch(started);
    history.assignAll((_box.read<List>('japa_history') ?? const [])
        .map((e) => MalaEntry.fromJson(e as Map)));
  }

  int get malasToday {
    final now = DateTime.now();
    return history
        .where((e) =>
            e.completedAt.year == now.year &&
            e.completedAt.month == now.month &&
            e.completedAt.day == now.day)
        .length;
  }

  int get total => history.length * AppConfig.malaBeads + count.value;

  void increment() {
    if (count.value == 0) _startedAt = DateTime.now();
    if (count.value + 1 >= AppConfig.malaBeads) {
      final now = DateTime.now();
      history.insert(
        0,
        MalaEntry(
          completedAt: now,
          seconds: _startedAt == null
              ? null
              : now.difference(_startedAt!).inSeconds,
        ),
      );
      count.value = 0;
      _startedAt = null;
      HapticFeedback.heavyImpact();
      Get.closeAllSnackbars();
      Get.rawSnackbar(
        message: 'japa_done'.tr,
        duration: const Duration(seconds: 2),
      );
    } else {
      count.value++;
      HapticFeedback.selectionClick();
    }
    _save();
  }

  void resetCurrent() {
    count.value = 0;
    _startedAt = null;
    _save();
  }

  void deleteEntry(MalaEntry e) {
    history.remove(e);
    _save();
  }

  void clearHistory() {
    history.clear();
    _save();
  }

  void _save() {
    _box.write('japa_count', count.value);
    _box.write('japa_started', _startedAt?.millisecondsSinceEpoch);
    _box.write('japa_history', history.map((e) => e.toJson()).toList());
  }
}
