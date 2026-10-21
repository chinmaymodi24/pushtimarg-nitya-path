import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
