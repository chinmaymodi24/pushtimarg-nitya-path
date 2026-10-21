import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../config/app_config.dart';

/// "Shri Krishnah Sharanam Mama" counter. Everything stays on the device.
class JapaController extends GetxController {
  final _box = GetStorage();

  /// Beads counted in the current mala (0..107).
  final count = 0.obs;
  final malasToday = 0.obs;
  final total = 0.obs;

  /// Fires once each time a mala is completed, for the page to react to.
  final malaCompleted = 0.obs;

  @override
  void onInit() {
    super.onInit();
    count.value = _box.read<int>('japa_count') ?? 0;
    total.value = _box.read<int>('japa_total') ?? 0;
    malasToday.value =
        _box.read<String>('japa_date') == _today ? _box.read<int>('japa_malas') ?? 0 : 0;
  }

  String get _today {
    final d = DateTime.now();
    return '${d.year}-${d.month}-${d.day}';
  }

  void increment() {
    if (_box.read<String>('japa_date') != _today) malasToday.value = 0;
    total.value++;
    if (count.value + 1 >= AppConfig.malaBeads) {
      count.value = 0;
      malasToday.value++;
      malaCompleted.value++;
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
    _save();
  }

  void _save() {
    _box.write('japa_count', count.value);
    _box.write('japa_total', total.value);
    _box.write('japa_malas', malasToday.value);
    _box.write('japa_date', _today);
  }
}
