import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/services/settings_service.dart';
import 'core/theme/app_theme.dart';
import 'core/translations/app_translations.dart';
import 'data/models/enums.dart';
import 'data/repository/path_repository.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final settings = Get.put(SettingsController(), permanent: true);
  Get.put(await PathRepository().load(), permanent: true);
  runApp(App(settings));
}

class App extends StatelessWidget {
  const App(this.settings, {super.key});
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          title: 'Pushtimarg Nitya Path',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(settings.uiLang.value),
          darkTheme: AppTheme.dark(settings.uiLang.value),
          themeMode: settings.themeMode.value,
          translations: AppTranslations(),
          locale: Locale(settings.uiLang.value.code),
          fallbackLocale: const Locale('en'),
          initialRoute: Routes.splash,
          defaultTransition: Transition.cupertino,
          getPages: AppPages.pages,
        ));
  }
}
