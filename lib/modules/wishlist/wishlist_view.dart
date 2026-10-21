import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/favorites_service.dart';
import '../../core/theme/palette.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/page_scaffold.dart';
import '../../data/models/path_model.dart';
import '../../data/repository/path_repository.dart';
import '../paths/path_tile.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final fav = Get.find<FavoritesController>();
    final repo = Get.find<PathRepository>();
    return PageScaffold(
      body: Column(
        children: [
          PageHeader(title: 'wishlist'.tr, onBack: Get.back),
          Expanded(
            child: Obx(() {
              final paths =
                  fav.ids.map(repo.byId).whereType<PathModel>().toList();
              if (paths.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.favorite_border_rounded,
                          size: 56, color: p.pillBorder),
                      const SizedBox(height: 14),
                      Text('wishlist_empty'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, height: 1.6, color: p.subtext)),
                    ]),
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [for (final x in paths) PathTile(x)],
              );
            }),
          ),
        ],
      ),
    );
  }
}
