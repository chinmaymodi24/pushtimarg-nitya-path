import 'package:get/get.dart';

import '../../data/models/enums.dart';
import '../config/app_config.dart';

/// Greeting, date line and current seva for a moment in time.
abstract class DayInfo {
  static String greetingKey(DateTime t) {
    final h = t.hour;
    if (h >= 4 && h < 12) return 'greet_morning';
    if (h >= 12 && h < 16) return 'greet_afternoon';
    if (h >= 16 && h < 20) return 'greet_evening';
    return 'greet_night';
  }

  /// The seva whose start time is the latest one already passed; before the
  /// first seva of the day it is still the previous night's shayan.
  static String currentSeva(DateTime t) {
    final m = t.hour * 60 + t.minute;
    var current = AppConfig.sevaStarts.keys.last;
    for (final e in AppConfig.sevaStarts.entries) {
      if (m >= e.value) current = e.key;
    }
    return current;
  }

  static const _days = {
    Lang.gu: [
      'સોમવાર',
      'મંગળવાર',
      'બુધવાર',
      'ગુરુવાર',
      'શુક્રવાર',
      'શનિવાર',
      'રવિવાર',
    ],
    Lang.hi: [
      'सोमवार',
      'मंगलवार',
      'बुधवार',
      'गुरुवार',
      'शुक्रवार',
      'शनिवार',
      'रविवार',
    ],
    Lang.en: [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ],
  };
  static const _months = {
    Lang.gu: [
      'જાન્યુઆરી',
      'ફેબ્રુઆરી',
      'માર્ચ',
      'એપ્રિલ',
      'મે',
      'જૂન',
      'જુલાઈ',
      'ઑગસ્ટ',
      'સપ્ટેમ્બર',
      'ઑક્ટોબર',
      'નવેમ્બર',
      'ડિસેમ્બર',
    ],
    Lang.hi: [
      'जनवरी',
      'फ़रवरी',
      'मार्च',
      'अप्रैल',
      'मई',
      'जून',
      'जुलाई',
      'अगस्त',
      'सितंबर',
      'अक्टूबर',
      'नवंबर',
      'दिसंबर',
    ],
    Lang.en: [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ],
  };

  /// "બુધવાર, 22 ઑક્ટોબર"
  static String date(DateTime t, Lang l) =>
      '${_days[l]![t.weekday - 1]}, ${t.day} ${_months[l]![t.month - 1]}';

  static String greeting(DateTime t) => greetingKey(t).tr;
}
