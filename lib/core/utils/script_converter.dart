import '../../data/models/enums.dart';

/// Content is stored once, in Devanagari. Gujarati and Roman are derived,
/// so a matra is proofread in a single place.
class ScriptConverter {
  ScriptConverter._();

  static String convert(String dev, ReaderScript script) {
    switch (script) {
      case ReaderScript.devanagari:
        return dev;
      case ReaderScript.gujarati:
        return _toGujarati(dev);
      case ReaderScript.roman:
        return _toRoman(dev);
    }
  }

  static String _toGujarati(String s) {
    final out = StringBuffer();
    for (final c in s.runes) {
      final inBlock = (c >= 0x0901 && c <= 0x0963) ||
          (c >= 0x0966 && c <= 0x096F) ||
          c == 0x0950;
      out.writeCharCode(inBlock ? c + 0x180 : c);
    }
    return out.toString();
  }

  static const _vowels = {
    'अ': 'a', 'आ': 'ā', 'इ': 'i', 'ई': 'ī', 'उ': 'u', 'ऊ': 'ū',
    'ऋ': 'ṛ', 'ॠ': 'ṝ', 'ए': 'e', 'ऐ': 'ai', 'ओ': 'o', 'औ': 'au',
  };
  static const _matras = {
    'ा': 'ā', 'ि': 'i', 'ी': 'ī', 'ु': 'u', 'ू': 'ū', 'ृ': 'ṛ',
    'ॄ': 'ṝ', 'े': 'e', 'ै': 'ai', 'ो': 'o', 'ौ': 'au',
  };
  static const _consonants = {
    'क': 'k', 'ख': 'kh', 'ग': 'g', 'घ': 'gh', 'ङ': 'ṅ',
    'च': 'c', 'छ': 'ch', 'ज': 'j', 'झ': 'jh', 'ञ': 'ñ',
    'ट': 'ṭ', 'ठ': 'ṭh', 'ड': 'ḍ', 'ढ': 'ḍh', 'ण': 'ṇ',
    'त': 't', 'थ': 'th', 'द': 'd', 'ध': 'dh', 'न': 'n',
    'प': 'p', 'फ': 'ph', 'ब': 'b', 'भ': 'bh', 'म': 'm',
    'य': 'y', 'र': 'r', 'ल': 'l', 'व': 'v',
    'श': 'ś', 'ष': 'ṣ', 'स': 's', 'ह': 'h', 'ळ': 'ḷ',
  };
  static const _signs = {
    'ं': 'ṃ', 'ः': 'ḥ', 'ँ': 'm̐', 'ऽ': '’', 'ॐ': 'oṃ',
    '।': '|', '॥': '||',
  };
  static const _digits = '०१२३४५६७८९';

  static String _toRoman(String s) {
    final chars = s.runes.map(String.fromCharCode).toList();
    final out = StringBuffer();
    for (var i = 0; i < chars.length; i++) {
      final c = chars[i];
      if (_consonants.containsKey(c)) {
        out.write(_consonants[c]);
        final next = i + 1 < chars.length ? chars[i + 1] : '';
        if (next == '्') {
          i++;
        } else if (_matras.containsKey(next)) {
          out.write(_matras[next]);
          i++;
        } else {
          out.write('a');
        }
      } else if (_vowels.containsKey(c)) {
        out.write(_vowels[c]);
      } else if (_signs.containsKey(c)) {
        out.write(_signs[c]);
      } else if (_digits.contains(c) && c.isNotEmpty) {
        out.write(_digits.indexOf(c));
      } else {
        out.write(c);
      }
    }
    return out.toString();
  }

  /// "॥ 1 ॥" as in the designs; Roman gets "|| 1 ||".
  static String verseMark(int n, ReaderScript script) =>
      script == ReaderScript.roman ? '|| $n ||' : '॥ $n ॥';
}
