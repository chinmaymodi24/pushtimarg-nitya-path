import 'package:flutter/material.dart';

import '../../data/models/enums.dart';
import 'palette.dart';

class AppTheme {
  AppTheme._();

  /// UI font follows the app language; the others cover mixed-script labels.
  static String uiFont(Lang l) => switch (l) {
        Lang.gu => 'NotoSansGujarati',
        Lang.hi => 'NotoSansDevanagari',
        Lang.en => 'NotoSans',
      };

  static const fallback = ['NotoSansGujarati', 'NotoSansDevanagari', 'NotoSans'];

  static ThemeData light(Lang ui) => _build(ui, Brightness.light, Palette.light);
  static ThemeData dark(Lang ui) => _build(ui, Brightness.dark, Palette.dark);

  static ThemeData _build(Lang ui, Brightness b, Palette p) {
    final cs = ColorScheme.fromSeed(
      seedColor: p.primary,
      brightness: b,
      primary: p.primary,
      surface: p.bgTop,
      onSurface: p.text,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: cs,
      fontFamily: uiFont(ui),
      fontFamilyFallback: fallback,
      scaffoldBackgroundColor: Colors.transparent,
      extensions: [p],
      splashFactory: InkRipple.splashFactory,
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? p.primary : p.chipBorder),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 5,
        activeTrackColor: p.primary,
        inactiveTrackColor: p.chipBorder,
        thumbColor: p.primary,
        overlayColor: p.primary.withValues(alpha: 0.12),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: p.card),
    );
  }

  /// Path text. Indic scripts need more leading than Latin.
  static TextStyle verse(ReaderScript s, double size, Color color) {
    return TextStyle(
      fontFamily: switch (s) {
        ReaderScript.gujarati => 'NotoSerifGujarati',
        ReaderScript.devanagari => 'NotoSerifDevanagari',
        ReaderScript.roman => 'NotoSerif',
      },
      fontFamilyFallback: const ['NotoSerif', 'NotoSerifDevanagari'],
      fontSize: size,
      height: s == ReaderScript.roman ? 1.6 : 1.75,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle meaning(Lang l, double size, Color color) => TextStyle(
        fontFamily: uiFont(l),
        fontFamilyFallback: fallback,
        fontSize: size,
        height: l == Lang.en ? 1.55 : 1.7,
        color: color,
      );
}
