import 'package:flutter/material.dart';

/// Every colour the app uses, designed separately for light and dark.
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.bgTop,
    required this.bgBottom,
    required this.card,
    required this.cardBorder,
    required this.shadow,
    required this.text,
    required this.subtext,
    required this.heading,
    required this.primary,
    required this.gold,
    required this.chip,
    required this.chipBorder,
    required this.chipSelected,
    required this.onChipSelected,
    required this.iconTile,
    required this.navBg,
    required this.verse,
    required this.meaning,
    required this.pill,
    required this.pillBorder,
  });

  final Color bgTop, bgBottom, card, cardBorder, shadow, text, subtext;
  final Color heading, primary, gold, chip, chipBorder, onChipSelected;
  final Color iconTile, navBg, verse, meaning, pill, pillBorder;
  final List<Color> chipSelected;

  static const light = Palette(
    bgTop: Color(0xFFFFFAF1),
    bgBottom: Color(0xFFFBEEDA),
    card: Color(0xFFFFFDF9),
    cardBorder: Color(0xFFF3E4CB),
    shadow: Color(0x1FB0702E),
    text: Color(0xFF3A2414),
    subtext: Color(0xFF8C7560),
    heading: Color(0xFFB9581B),
    primary: Color(0xFFE8821E),
    gold: Color(0xFFD9A441),
    chip: Color(0xFFFFFFFF),
    chipBorder: Color(0xFFEBDCC3),
    chipSelected: [Color(0xFFF4AE62), Color(0xFFE8821E)],
    onChipSelected: Colors.white,
    iconTile: Color(0xFFFDF0DC),
    navBg: Color(0xFFFFFFFF),
    verse: Color(0xFF2E1A0C),
    meaning: Color(0xFF4A3424),
    pill: Color(0xFFFCE7C8),
    pillBorder: Color(0xFFE9A458),
  );

  static const dark = Palette(
    bgTop: Color(0xFF21160C),
    bgBottom: Color(0xFF110A05),
    card: Color(0xFF28190D),
    cardBorder: Color(0xFF3D2A15),
    shadow: Color(0x66000000),
    text: Color(0xFFF3E3C4),
    subtext: Color(0xFFB39C7C),
    heading: Color(0xFFE9A23B),
    primary: Color(0xFFE59A33),
    gold: Color(0xFFC9922F),
    chip: Color(0xFF2E1F11),
    chipBorder: Color(0xFF4A3420),
    chipSelected: [Color(0xFFEDAE4E), Color(0xFFC97A1B)],
    onChipSelected: Color(0xFF1A1007),
    iconTile: Color(0xFF35240F),
    navBg: Color(0xFF1C130A),
    verse: Color(0xFFF8ECD3),
    meaning: Color(0xFFDCC8A5),
    pill: Color(0xFF2E1F11),
    pillBorder: Color(0xFFB8842F),
  );

  @override
  Palette copyWith() => this;

  @override
  Palette lerp(ThemeExtension<Palette>? other, double t) =>
      t < 0.5 ? this : (other as Palette? ?? this);
}

extension PaletteX on BuildContext {
  Palette get pal => Theme.of(this).extension<Palette>()!;
}
