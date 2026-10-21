import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/japa_service.dart';
import '../../core/theme/palette.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/logo_header.dart';
import '../../core/widgets/svg_icon.dart';
import '../../data/models/seva.dart';
import '../../routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        const LogoHeader(height: 210, logoWidth: 240),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text('daily_paths'.tr,
              style: TextStyle(
                  fontSize: 19, fontWeight: FontWeight.w700, color: p.text)),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sevaList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 82,
          ),
          itemBuilder: (_, i) => _SevaCard(sevaList[i]),
        ),
        const SizedBox(height: 14),
        const _JapaBanner(),
      ],
    );
  }
}

class _SevaCard extends StatelessWidget {
  const _SevaCard(this.seva);
  final Seva seva;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      onTap: () => Get.toNamed(Routes.seva, arguments: seva.id),
      child: Row(
        children: [
          SvgIcon(seva.icon, size: 42),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(seva.nameKey.tr,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: p.text,
                          height: 1.3)),
                ),
                Text(seva.subKey.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.5, color: p.subtext)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: p.subtext, size: 22),
        ],
      ),
    );
  }
}

/// Shortcut to the japa counter with today's mala count.
class _JapaBanner extends StatelessWidget {
  const _JapaBanner();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final japa = Get.find<JapaController>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [p.iconTile, p.card],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: p.pillBorder.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(color: p.shadow, blurRadius: 14, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed(Routes.japa),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: p.chipSelected),
                  ),
                  child: Icon(Icons.blur_circular_rounded,
                      size: 32, color: p.onChipSelected),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('japa_sub'.tr,
                          style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.w700,
                              color: p.heading)),
                      const SizedBox(height: 2),
                      Obx(() => Text(
                            '${'japa_title'.tr} · ${'japa_home'.tr}: ${japa.malasToday.value}',
                            style: TextStyle(fontSize: 13.5, color: p.subtext),
                          )),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: p.subtext),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
