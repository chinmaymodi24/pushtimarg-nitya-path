import 'package:get/get.dart';

abstract class TimeFormat {
  static String ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'ago_now'.tr;
    if (d.inHours < 1) return 'ago_min'.trParams({'n': '${d.inMinutes}'});
    if (d.inDays < 1) return 'ago_hour'.trParams({'n': '${d.inHours}'});
    return 'ago_day'.trParams({'n': '${d.inDays}'});
  }

  /// "આજે", "ગઈકાલે" or dd-mm-yyyy.
  static String day(DateTime t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(t.year, t.month, t.day);
    final diff = today.difference(that).inDays;
    if (diff == 0) return 'today'.tr;
    if (diff == 1) return 'yesterday'.tr;
    return '${_pad(t.day)}-${_pad(t.month)}-${t.year}';
  }

  static String clock(DateTime t) => '${_pad(t.hour)}:${_pad(t.minute)}';

  static String duration(int seconds) => seconds < 60
      ? 'seconds_n'.trParams({'n': '$seconds'})
      : 'minutes_n'.trParams({'n': '${(seconds / 60).round()}'});

  static String _pad(int n) => n.toString().padLeft(2, '0');
}
