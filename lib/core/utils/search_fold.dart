/// Lower-cases and strips Roman diacritics so "shri krishna" finds
/// "śrī kṛṣṇa". Indic script text passes through unchanged.
String fold(String s) {
  final b = StringBuffer();
  for (final r in s.toLowerCase().runes) {
    final c = String.fromCharCode(r);
    b.write(_map[c] ?? c);
  }
  return b.toString();
}

const _map = {
  'ā': 'a',
  'ī': 'i',
  'ū': 'u',
  'ṛ': 'ri',
  'ṝ': 'ri',
  'ḷ': 'l',
  'ṃ': 'm',
  'ṁ': 'm',
  'ḥ': 'h',
  'ś': 'sh',
  'ṣ': 'sh',
  'ṭ': 't',
  'ḍ': 'd',
  'ṇ': 'n',
  'ñ': 'n',
  'ṅ': 'n',
  '̐': '',
  '’': '',
};
