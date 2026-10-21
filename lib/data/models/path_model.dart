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
    required this.titleDev,
    required this.verses,
  });

  final String id;
  final String seva;
  final String titleDev;
  final List<Verse> verses;

  factory PathModel.fromJson(Map<String, dynamic> j) => PathModel(
        id: j['id'] as String,
        seva: j['seva'] as String,
        titleDev: j['title'] as String,
        verses: (j['verses'] as List)
            .map((e) => Verse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
