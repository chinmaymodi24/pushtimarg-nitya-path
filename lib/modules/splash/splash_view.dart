import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/palette.dart';
import '../../core/widgets/page_scaffold.dart';
import 'splash_controller.dart';

const splashLogo = 'assets/images/splash_logo.webp';
const splashLogoDark = 'assets/images/splash_logo_dark.webp';

/// Decodes the splash artwork before the first frame, so the hand-off from
/// the native splash never shows an empty screen.
Future<void> precacheSplash() => Future.wait([
  for (final a in [splashLogo, splashLogoDark]) _decode(AssetImage(a)),
]);

Future<void> _decode(ImageProvider image) {
  final done = Completer<void>();
  final stream = image.resolve(ImageConfiguration.empty);
  late final ImageStreamListener listener;
  listener = ImageStreamListener(
    (_, _) {
      stream.removeListener(listener);
      if (!done.isCompleted) done.complete();
    },
    onError: (_, _) {
      stream.removeListener(listener);
      if (!done.isCompleted) done.complete();
    },
  );
  stream.addListener(listener);
  return done.future;
}

/// Same artwork, size and position as the native splash, so the hand-off
/// is seamless; then a small loading bar and the mantra fade in below.
class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  /// The native splash draws its 1200px image at xxxhdpi, i.e. 300dp.
  static const _logoBox = 300.0;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return PageScaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Center(
            child: Image.asset(
              dark ? splashLogoDark : splashLogo,
              width: _logoBox,
              height: _logoBox,
              gaplessPlayback: true,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 56,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (_, t, child) => Opacity(opacity: t, child: child),
              child: Column(
                children: [
                  SizedBox(
                    width: 96,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        minHeight: 3,
                        backgroundColor: p.chipBorder,
                        valueColor: AlwaysStoppedAnimation(p.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'mantra'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: p.heading,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
