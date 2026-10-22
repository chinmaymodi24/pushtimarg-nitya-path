import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nityapath/core/theme/app_theme.dart';
import 'package:nityapath/core/translations/app_translations.dart';
import 'package:nityapath/core/widgets/bottom_nav.dart';
import 'package:nityapath/data/models/enums.dart';

void main() {
  testWidgets('tab bar animates its pill and icon when the tab changes', (
    t,
  ) async {
    final current = ValueNotifier(0);
    await t.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light(Lang.gu),
        translations: AppTranslations(),
        locale: const Locale('gu'),
        home: Scaffold(
          bottomNavigationBar: ValueListenableBuilder<int>(
            valueListenable: current,
            builder: (_, i, _) => AppBottomNav(current: i),
          ),
        ),
      ),
    );

    double scaleOf(int tab) => t
        .widgetList<AnimatedScale>(find.byType(AnimatedScale))
        .elementAt(tab)
        .scale;
    double rendered(int tab) {
      final e = find.byType(ScaleTransition).at(tab);
      return t.widget<ScaleTransition>(e).scale.value;
    }

    expect(scaleOf(0), 1.08);
    expect(scaleOf(1), 1.0);

    current.value = 1;
    await t.pump();
    await t.pump(const Duration(milliseconds: 120));
    // Mid-way: the new tab's icon is still growing, the old one shrinking.
    expect(rendered(1), inExclusiveRange(1.0, 1.08 + 0.05));
    expect(rendered(1), isNot(1.08));
    expect(rendered(0), lessThan(1.08));

    await t.pumpAndSettle();
    expect(rendered(1), closeTo(1.08, 0.001));
    expect(rendered(0), closeTo(1.0, 0.001));
  });
}
