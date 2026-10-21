import 'package:get/get.dart';

import '../../data/models/path_model.dart';
import '../../data/repository/path_repository.dart';

/// Used by both the "Paths" tab (all) and a single seva page (arguments = id).
class PathsController extends GetxController {
  final _repo = Get.find<PathRepository>();
  String? sevaId;
  late final List<PathModel> paths;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    sevaId = arg is String ? arg : null;
    paths = sevaId == null ? _repo.all : _repo.forSeva(sevaId!);
  }
}

/// Separate type so a seva page never shares the tab's instance.
class SevaController extends PathsController {}
