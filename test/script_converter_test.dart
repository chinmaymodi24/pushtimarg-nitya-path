import 'package:flutter_test/flutter_test.dart';
import 'package:nityapath/core/utils/script_converter.dart';
import 'package:nityapath/data/models/enums.dart';

void main() {
  const dev = 'नमामि यमुनामहं सकलसिद्धिहेतुं मुदा ।';

  test('Devanagari to Gujarati', () {
    expect(ScriptConverter.convert(dev, ReaderScript.gujarati),
        'નમામિ યમુનામહં સકલસિદ્ધિહેતું મુદા ।');
  });

  test('Devanagari to Roman (IAST)', () {
    expect(ScriptConverter.convert(dev, ReaderScript.roman),
        'namāmi yamunāmahaṃ sakalasiddhihetuṃ mudā |');
    expect(ScriptConverter.convert('श्रीमद्द्वारवतीश', ReaderScript.roman),
        'śrīmaddvāravatīśa');
  });

  test('verse marker', () {
    expect(ScriptConverter.verseMark(12, ReaderScript.gujarati), '॥ ૧૨ ॥');
    expect(ScriptConverter.verseMark(2, ReaderScript.roman), '|| 2 ||');
  });
}
