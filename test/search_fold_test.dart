import 'package:flutter_test/flutter_test.dart';
import 'package:nityapath/core/utils/script_converter.dart';
import 'package:nityapath/core/utils/search_fold.dart';
import 'package:nityapath/data/models/enums.dart';

void main() {
  test('plain Latin typing finds IAST text', () {
    final roman = fold(
      ScriptConverter.convert('श्रीयमुनाष्टकम् नमामि', ReaderScript.roman),
    );
    expect(roman.contains(fold('shri')), isTrue);
    expect(roman.contains(fold('yamunashtak')), isTrue);
    expect(roman.contains(fold('namami')), isTrue);
    expect(fold('कृष्ण'), 'कृष्ण');
    expect(
      fold(ScriptConverter.convert('कृष्ण', ReaderScript.roman)),
      'krishna',
    );
  });
}
