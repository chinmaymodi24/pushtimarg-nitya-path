import '../../core/utils/script_converter.dart';
import 'enums.dart';

class Verse {
  Verse({required this.number, required this.dev, required this.meanings});

  final int number;

  /// Devanagari source text, lines separated by '\n'.
  final String dev;
  final Map<String, String> meanings;

  String? meaning(Lang l) {
    final m = meanings[l.code];
    return (m == null || m.isEmpty) ? null : m;
  }

  factory Verse.fromJson(Map<String, dynamic> j) => Verse(
        number: j['n'] as int,
        dev: j['dev'] as String,
        meanings: Map<String, String>.from(j['meaning'] as Map? ?? {}),
      );
}

class PathModel {
  PathModel({
    required this.id,
    required this.seva,
    required this.icon,
    required this.titleDev,
    required this.titleEn,
    required this.verses,
  });

  final String id;
  final String seva;
  final String icon;
  final String titleDev;
  final String titleEn;
  final List<Verse> verses;

  /// The path's name is shown in the app language, not the reading script.
  String title(Lang ui) => switch (ui) {
        Lang.gu => ScriptConverter.convert(titleDev, ReaderScript.gujarati),
        Lang.hi => titleDev,
        Lang.en => titleEn,
      };

  /// Title in every script, lower-cased, for search.
  late final String searchText = [
    titleDev,
    ScriptConverter.convert(titleDev, ReaderScript.gujarati),
    ScriptConverter.convert(titleDev, ReaderScript.roman),
    titleEn,
  ].join(' ').toLowerCase();

  factory PathModel.fromJson(Map<String, dynamic> j) => PathModel(
        id: j['id'] as String,
        seva: j['seva'] as String,
        icon: j['icon'] as String? ?? 'lotus',
        titleDev: j['title'] as String,
        titleEn: j['title_en'] as String? ?? j['title'] as String,
        verses: (j['verses'] as List)
            .map((e) => Verse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
