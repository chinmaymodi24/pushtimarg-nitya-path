import 'package:get/get.dart';

import '../../data/models/path_model.dart';
import '../../routes/app_routes.dart';
import '../services/settings_service.dart';

/// Opens a path in the reader, or says its text is still to come.
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
  Get.toNamed(Routes.reader, arguments: arguments ?? path.id);
}
