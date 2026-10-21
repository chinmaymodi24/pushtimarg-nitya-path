import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/enums.dart';

/// Holds the three independent language axes plus theme and text size.
/// Changing one never touches the others.
class SettingsController extends GetxController {
  static const minScale = 0.8;
  static const maxScale = 1.8;

  final _box = GetStorage();

  final script = ReaderScript.gujarati.obs; // axis 1
  final showMeaning = true.obs; // axis 2 on/off
  final meaningLang = Lang.gu.obs; // axis 2 language
  final uiLang = Lang.gu.obs; // axis 3
  final textScale = 1.0.obs;
  final themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    script.value = _enum(ReaderScript.values, 'script', ReaderScript.gujarati);
    showMeaning.value = _box.read<bool>('showMeaning') ?? true;
    meaningLang.value = _enum(Lang.values, 'meaningLang', Lang.gu);
    uiLang.value = _enum(Lang.values, 'uiLang', Lang.gu);
    textScale.value =
        (_box.read<double>('textScale') ?? 1.0).clamp(minScale, maxScale);
    themeMode.value = _enum(ThemeMode.values, 'themeMode', ThemeMode.light);
  }

  T _enum<T extends Enum>(List<T> values, String key, T fallback) {
    final name = _box.read<String>(key);
    return values.firstWhere((e) => e.name == name, orElse: () => fallback);
  }

  void setScript(ReaderScript v) {
    script.value = v;
    _box.write('script', v.name);
  }

  void setShowMeaning(bool v) {
    showMeaning.value = v;
    _box.write('showMeaning', v);
  }

  void setMeaningLang(Lang v) {
    meaningLang.value = v;
    _box.write('meaningLang', v.name);
  }

  void setUiLang(Lang v) {
    uiLang.value = v;
    _box.write('uiLang', v.name);
    Get.updateLocale(Locale(v.code));
  }

  void setTextScale(double v) {
    textScale.value = v.clamp(minScale, maxScale);
    _box.write('textScale', textScale.value);
  }

  void setThemeMode(ThemeMode v) {
    themeMode.value = v;
    _box.write('themeMode', v.name);
  }

  void toggleDark(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    setThemeMode(dark ? ThemeMode.light : ThemeMode.dark);
  }
}
