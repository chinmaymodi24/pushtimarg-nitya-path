import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/palette.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/page_scaffold.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final w = MediaQuery.sizeOf(context).width;
    return PageScaffold(
      body: Stack(
        children: [
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1100),
              curve: Curves.easeOutCubic,
              builder: (_, t, child) => Opacity(
                opacity: t,
                child: Transform.scale(scale: 0.92 + 0.08 * t, child: child),
              ),
              child: AppLogo(width: w * 0.78),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 56,
            child: Text(
              'mantra'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: p.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
