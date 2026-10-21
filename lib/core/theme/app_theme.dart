import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/enums.dart';

/// Reading-specific colours that ColorScheme has no slot for.
class PathColors extends ThemeExtension<PathColors> {
  const PathColors({
    required this.card,
    required this.verse,
    required this.meaning,
    required this.heading,
    required this.divider,
    required this.chip,
    required this.chipSelected,
    required this.onChipSelected,
  });

  final Color card, verse, meaning, heading, divider, chip, chipSelected;
  final Color onChipSelected;

  static const light = PathColors(
    card: Color(0xFFFFFBF2),
    verse: Color(0xFF3B2412),
    meaning: Color(0xFF5A4030),
    heading: Color(0xFFB4521B),
    divider: Color(0xFFD9A441),
    chip: Color(0xFFFBE9CC),
    chipSelected: Color(0xFFE8821E),
    onChipSelected: Colors.white,
  );

  static const dark = PathColors(
    card: Color(0xFF251A10),
    verse: Color(0xFFF6E8CC),
    meaning: Color(0xFFD8C3A0),
    heading: Color(0xFFE9A23B),
    divider: Color(0xFF8A6A2C),
    chip: Color(0xFF33261A),
    chipSelected: Color(0xFFE0A33A),
    onChipSelected: Color(0xFF1A110A),
  );

  @override
  PathColors copyWith() => this;

  @override
  PathColors lerp(ThemeExtension<PathColors>? other, double t) =>
      t < 0.5 ? this : (other as PathColors? ?? this);
}

extension ThemeX on BuildContext {
  PathColors get pc => Theme.of(this).extension<PathColors>()!;
}

class AppTheme {
  AppTheme._();

  static ThemeData light(Lang ui) => _build(
        ui,
        Brightness.light,
        const ColorScheme.light(
          primary: Color(0xFFE8821E),
          secondary: Color(0xFFD9A441),
          surface: Color(0xFFFFF8EC),
          onSurface: Color(0xFF3B2412),
        ),
        PathColors.light,
      );

  static ThemeData dark(Lang ui) => _build(
        ui,
        Brightness.dark,
        const ColorScheme.dark(
          primary: Color(0xFFE0A33A),
          secondary: Color(0xFF8A6A2C),
          surface: Color(0xFF1A110A),
          onSurface: Color(0xFFF6E8CC),
        ),
        PathColors.dark,
      );

  static ThemeData _build(
      Lang ui, Brightness b, ColorScheme cs, PathColors pc) {
    final base = ThemeData(brightness: b, colorScheme: cs, useMaterial3: true);
    final text = switch (ui) {
      Lang.gu => GoogleFonts.notoSansGujaratiTextTheme(base.textTheme),
      Lang.hi => GoogleFonts.notoSansDevanagariTextTheme(base.textTheme),
      Lang.en => GoogleFonts.notoSansTextTheme(base.textTheme),
    }
        .apply(bodyColor: cs.onSurface, displayColor: cs.onSurface);
    return base.copyWith(
      scaffoldBackgroundColor: cs.surface,
      textTheme: text,
      extensions: [pc],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: pc.heading,
        titleTextStyle: text.titleLarge?.copyWith(
            color: pc.heading, fontWeight: FontWeight.w700),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: pc.card,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(
            text.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: cs.primary,
        thumbColor: cs.primary,
        inactiveTrackColor: pc.divider.withValues(alpha: 0.35),
      ),
    );
  }

  /// Verse font for each script. Serif, with genuine glyph coverage.
  static TextStyle verseStyle(ReaderScript s, double size, Color color) {
    final h = s == ReaderScript.roman ? 1.7 : 2.0;
    return switch (s) {
      ReaderScript.gujarati => GoogleFonts.notoSerifGujarati(
          fontSize: size, height: h, color: color, fontWeight: FontWeight.w500),
      ReaderScript.devanagari => GoogleFonts.notoSerifDevanagari(
          fontSize: size, height: h, color: color, fontWeight: FontWeight.w500),
      ReaderScript.roman => GoogleFonts.notoSerif(
          fontSize: size, height: h, color: color),
    };
  }

  static TextStyle meaningStyle(Lang l, double size, Color color) {
    const h = 1.8;
    return switch (l) {
      Lang.gu => GoogleFonts.notoSansGujarati(
          fontSize: size, height: h, color: color),
      Lang.hi => GoogleFonts.notoSansDevanagari(
          fontSize: size, height: h, color: color),
      Lang.en => GoogleFonts.notoSerif(fontSize: size, height: 1.6, color: color),
    };
  }
}
