import 'package:get/get.dart';

import '../modules/more/info_view.dart';
import '../modules/paths/paths_controller.dart';
import '../modules/paths/seva_view.dart';
import '../modules/reader/reader_controller.dart';
import '../modules/reader/reader_view.dart';
import '../modules/settings/settings_page.dart';
import '../modules/settings/specimen_view.dart';
import '../modules/shell/shell_controller.dart';
import '../modules/shell/shell_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.shell,
      page: () => const ShellView(),
      binding: BindingsBuilder(() {
        Get.put(ShellController());
        Get.put(PathsController());
      }),
    ),
    GetPage(
      name: Routes.seva,
      page: () => const SevaView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => SevaController())),
    ),
    GetPage(
      name: Routes.reader,
      page: () => const ReaderView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => ReaderController())),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
    ),
    GetPage(name: Routes.specimen, page: () => const SpecimenView()),
    GetPage(name: Routes.info, page: () => const InfoView()),
  ];
}
