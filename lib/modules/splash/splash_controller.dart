import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(
      const Duration(milliseconds: 2200),
      () => Get.offAllNamed(Routes.shell),
    );
  }
}
