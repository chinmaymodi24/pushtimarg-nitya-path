import 'package:get/get.dart';

import '../../data/models/path_model.dart';
import '../../routes/app_routes.dart';
import '../services/reading_service.dart';
import '../services/settings_service.dart';

/// Opens a path in the reader, or says its text is still to come. A path
/// that was started and not finished reopens where the reader left off.
void openPath(PathModel path, {Object? arguments}) {
  if (!path.available) {
    final ui = Get.find<SettingsController>().uiLang.value;
    Get.closeAllSnackbars();
    Get.rawSnackbar(
      message: 'path_coming_soon'.trParams({'name': path.title(ui)}),
      duration: const Duration(seconds: 3),
    );
    return;
  }
  final r = Get.find<ReadingController>().records[path.id];
  final resume = r != null && !r.isComplete && r.progress > 0;
  Get.toNamed(
    Routes.reader,
    arguments:
        arguments ?? (resume ? {'id': path.id, 'resume': r.progress} : path.id),
  );
}
