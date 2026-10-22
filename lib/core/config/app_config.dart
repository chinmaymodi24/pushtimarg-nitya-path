/// App-wide constants that the developer may want to change in one place.
abstract class AppConfig {
  static const version = '1.0.0';
  static const contactEmail = 'chinmaymodi24@gmail.com';

  /// Shown as +91 97148 88466; dialled with the country code.
  static const contactPhone = '+919714888466';
  static const contactPhoneDisplay = '+91 97148 88466';

  /// Approximate start of each seva (minutes after midnight), used only to
  /// highlight "now" on Home. Timings differ by haveli; adjust here.
  static const sevaStarts = <String, int>{
    'mangla': 5 * 60,
    'shringar': 7 * 60 + 30,
    'gwal': 9 * 60,
    'rajbhog': 10 * 60 + 30,
    'utthapan': 15 * 60 + 30,
    'bhog': 16 * 60 + 30,
    'sandhya': 17 * 60 + 45,
    'shayan': 19 * 60,
  };

  /// Beads in one mala.
  static const malaBeads = 108;
}
