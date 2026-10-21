/// Axis 1: script the path text is written in.
enum ReaderScript { gujarati, devanagari, roman }

/// Axes 2 and 3 share the same set of languages but are stored separately.
enum Lang { gu, hi, en }

extension LangX on Lang {
  String get code => name;
  String get nativeName => switch (this) {
        Lang.gu => 'ગુજરાતી',
        Lang.hi => 'हिन्दी',
        Lang.en => 'English',
      };

  /// "Meaning" written in this language, for the heading above a meaning.
  String get meaningWord => switch (this) {
        Lang.gu => 'અર્થ',
        Lang.hi => 'अर्थ',
        Lang.en => 'Meaning',
      };
}

extension ReaderScriptX on ReaderScript {
  String get nativeName => switch (this) {
        ReaderScript.gujarati => 'ગુજરાતી',
        ReaderScript.devanagari => 'देवनागरी',
        ReaderScript.roman => 'Roman',
      };
}
