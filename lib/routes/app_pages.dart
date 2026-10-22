import 'package:get/get.dart';

import '../modules/contact/contact_view.dart';
import '../modules/feedback/feedback_controller.dart';
import '../modules/feedback/feedback_view.dart';
import '../modules/history/history_controller.dart';
import '../modules/history/history_view.dart';
import '../modules/home/home_controller.dart';
import '../modules/japa/japa_history_view.dart';
import '../modules/japa/japa_view.dart';
import '../modules/legal/legal_view.dart';
import '../modules/more/about_view.dart';
import '../modules/paths/paths_controller.dart';
import '../modules/paths/paths_tab_controller.dart';
import '../modules/paths/seva_view.dart';
import '../modules/reader/reader_controller.dart';
import '../modules/reader/reader_view.dart';
import '../modules/settings/settings_page.dart';
import '../modules/settings/specimen_view.dart';
import '../modules/shell/shell_controller.dart';
import '../modules/shell/shell_view.dart';
import '../modules/splash/splash_controller.dart';
import '../modules/splash/splash_view.dart';
import '../modules/wishlist/wishlist_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: Routes.shell,
      page: () => const ShellView(),
      binding: BindingsBuilder(() {
        Get.put(ShellController(), permanent: true);
        Get.put(HomeController(), permanent: true);
        Get.put(PathsTabController(), permanent: true);
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
    GetPage(name: Routes.settings, page: () => const SettingsPage()),
    GetPage(name: Routes.specimen, page: () => const SpecimenView()),
    GetPage(name: Routes.japa, page: () => const JapaView()),
    GetPage(name: Routes.wishlist, page: () => const WishlistView()),
    GetPage(
      name: Routes.feedback,
      page: () => const FeedbackView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => FeedbackController())),
    ),
    GetPage(name: Routes.contact, page: () => const ContactView()),
    GetPage(name: Routes.about, page: () => const AboutView()),
    GetPage(name: Routes.legal, page: () => const LegalView()),
    GetPage(name: Routes.japaHistory, page: () => const JapaHistoryView()),
    GetPage(
      name: Routes.history,
      page: () => const HistoryView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => HistoryController())),
    ),
  ];
}
