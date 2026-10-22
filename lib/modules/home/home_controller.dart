import 'dart:async';

import 'package:get/get.dart';

/// Keeps Home's greeting and "seva now" in step with the clock.
class HomeController extends GetxController {
  final now = DateTime.now().obs;
  Timer? _tick;

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
