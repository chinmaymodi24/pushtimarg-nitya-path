import 'package:get/get.dart';

import '../../data/models/path_model.dart';
import '../../data/repository/path_repository.dart';

class ReaderController extends GetxController {
  late final PathModel path;

  @override
  void onInit() {
    super.onInit();
    path = Get.find<PathRepository>().byId(Get.arguments as String)!;
  }
}
