import '../../core/utils/script_converter.dart';
import '../../core/utils/search_fold.dart';
import 'category.dart';
import 'enums.dart';

class Verse {
  Verse({required this.number, required this.dev, required this.meanings});

  final int number;

  /// Devanagari source text, lines separated by '\n'.
  final String dev;
  final Map<String, String> meanings;

  /// Verse in every script plus all meanings, folded, for search.
  late final String searchText = fold(
    [
      dev,
      ScriptConverter.convert(dev, ReaderScript.gujarati),
      ScriptConverter.convert(dev, ReaderScript.roman),
      ...meanings.values,
    ].join(' '),
  );

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
    required this.category,
    required this.icon,
    required this.titleDev,
    required this.titleGu,
    required this.titleEn,
    required this.verses,
  });

  final String id;

  /// Seva this path is read in, when known.
  final String? seva;
  final String category;
  final String icon;
  final String titleDev;

  /// Gujarati title when it should not be derived from [titleDev].
  final String? titleGu;
  final String titleEn;
  final List<Verse> verses;

  /// Listed paths whose text has not been added yet have no verses.
  bool get available => verses.isNotEmpty;

  /// The path's name is shown in the app language, not the reading script.
  String title(Lang ui) => switch (ui) {
    Lang.gu =>
      titleGu ?? ScriptConverter.convert(titleDev, ReaderScript.gujarati),
    Lang.hi => titleDev,
    Lang.en => titleEn,
  };

  /// Title in every script, lower-cased, for search.
  late final String searchText = fold(
    [
      titleDev,
      titleGu ?? ScriptConverter.convert(titleDev, ReaderScript.gujarati),
      ScriptConverter.convert(titleDev, ReaderScript.roman),
      titleEn,
    ].join(' '),
  );

  factory PathModel.fromJson(Map<String, dynamic> j) => PathModel(
    id: j['id'] as String,
    seva: j['seva'] as String?,
    category: j['category'] as String,
    icon: j['icon'] as String? ?? categoryById(j['category'] as String).icon,
    titleDev: j['title'] as String,
    titleGu: j['title_gu'] as String?,
    titleEn: j['title_en'] as String? ?? j['title'] as String,
    verses: (j['verses'] as List)
        .map((e) => Verse.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
