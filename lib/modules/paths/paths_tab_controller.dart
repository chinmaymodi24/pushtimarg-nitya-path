import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/favorites_service.dart';
import '../../data/models/path_model.dart';
import '../../data/models/seva.dart';
import '../../data/repository/path_repository.dart';

/// The "Paths" tab: search, a filter (all / wishlist / one seva) and the
/// scroll state of the filter chips so the arrows know when to show.
class PathsTabController extends GetxController {
  static const all = 'all';
  static const fav = 'fav';

  final _repo = Get.find<PathRepository>();
  final _fav = Get.find<FavoritesController>();

  final search = TextEditingController();
  final query = ''.obs;
  final filter = all.obs;

  final chips = ScrollController();
  final canLeft = false.obs;
  final canRight = false.obs;

  @override
  void onInit() {
    super.onInit();
    search.addListener(() => query.value = search.text);
    chips.addListener(updateArrows);
  }

  void updateArrows() {
    if (!chips.hasClients) return;
    final pos = chips.position;
    canLeft.value = pos.pixels > 4;
    canRight.value = pos.pixels < pos.maxScrollExtent - 4;
  }

  void scrollChips(bool right) {
    if (!chips.hasClients) return;
    final pos = chips.position;
    final step = pos.viewportDimension * 0.6;
    chips.animateTo(
      (pos.pixels + (right ? step : -step)).clamp(0, pos.maxScrollExtent),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void select(String f) => filter.value = f;

  /// Visible paths grouped by seva, in seva order; empty groups dropped.
  List<(Seva, List<PathModel>)> get groups {
    final q = query.value.trim().toLowerCase();
    final f = filter.value;
    final favs = _fav.ids.toSet();
    final out = <(Seva, List<PathModel>)>[];
    for (final s in sevaList) {
      if (f != all && f != fav && f != s.id) continue;
      final items = _repo.forSeva(s.id).where((p) {
        if (f == fav && !favs.contains(p.id)) return false;
        return q.isEmpty || p.searchText.contains(q);
      }).toList();
      if (items.isNotEmpty) out.add((s, items));
    }
    return out;
  }

  @override
  void onClose() {
    search.dispose();
    chips.dispose();
    super.onClose();
  }
}
