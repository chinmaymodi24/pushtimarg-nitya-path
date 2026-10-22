import 'package:flutter/material.dart';

import '../../core/translations/app_translations.dart';
import '../../core/utils/search_fold.dart';
import '../../routes/app_routes.dart';

/// One searchable place in the app.
class Feature {
  Feature(this.icon, this.titleKey, this.route, this.extra, {this.args})
    : haystack = fold(
        [
          extra,
          for (final l in AppTranslations().keys.values) l[titleKey] ?? '',
        ].join(' '),
      );

  final IconData icon;
  final String titleKey;
  final String route;
  final Object? args;

  /// Extra words people may type, in any language.
  final String extra;
  final String haystack;
}

/// Every feature of the app, with words people may use to look for it.
final features = <Feature>[
  Feature(
    Icons.blur_circular_rounded,
    'japa_title',
    Routes.japa,
    'mala jap japa counter mantra sharanam શરણં ગણતરી माला गिनती',
  ),
  Feature(
    Icons.history_toggle_off_rounded,
    'mala_history',
    Routes.japaHistory,
    'mala history japa record ઇતિહાસ',
  ),
  Feature(
    Icons.favorite_border_rounded,
    'wishlist',
    Routes.wishlist,
    'wishlist favourite favorite saved heart pasand પસંદ યાદી सूची',
  ),
  Feature(
    Icons.history_rounded,
    'history',
    Routes.history,
    'reading history recent continue last read vachan વાંચેલા पढ़ा',
  ),
  Feature(
    Icons.settings_outlined,
    'settings',
    Routes.settings,
    'settings setting options સેટિંગ',
  ),
  Feature(
    Icons.translate_rounded,
    'script',
    Routes.settings,
    'script lipi gujarati devanagari roman લિપિ लिपि',
  ),
  Feature(
    Icons.subject_rounded,
    'meaning',
    Routes.settings,
    'meaning translation arth bhavarth અર્થ ભાવાર્થ भावार्थ',
  ),
  Feature(
    Icons.language_rounded,
    'app_language',
    Routes.settings,
    'app language bhasha ભાષા भाषा english hindi gujarati',
  ),
  Feature(
    Icons.format_size_rounded,
    'text_size',
    Routes.settings,
    'text size font akshar bigger smaller zoom અક્ષર કદ मोटा',
  ),
  Feature(
    Icons.dark_mode_outlined,
    'theme',
    Routes.settings,
    'theme dark light night mode raat રાત ડાર્ક લાઈટ रात',
  ),
  Feature(
    Icons.rate_review_outlined,
    'feedback',
    Routes.feedback,
    'feedback suggestion error mistake report bhul ભૂલ સૂચન त्रुटि सुझाव',
  ),
  Feature(
    Icons.call_outlined,
    'contact',
    Routes.contact,
    'contact call phone mobile number email mail whatsapp ફોન ઈમેલ વોટ્સએપ फ़ोन',
  ),
  Feature(
    Icons.account_circle_outlined,
    'about',
    Routes.about,
    'about app version information વિશે बारे',
  ),
  Feature(
    Icons.shield_outlined,
    'privacy',
    Routes.legal,
    'privacy policy data ગોપનીયતા गोपनीयता',
    args: 'privacy',
  ),
  Feature(
    Icons.description_outlined,
    'terms',
    Routes.legal,
    'terms conditions use rules શરતો शर्तें',
    args: 'terms',
  ),
];
