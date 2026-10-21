import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// The user's wishlist of paths, stored on the device only.
class FavoritesController extends GetxController {
  final _box = GetStorage();
  final ids = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    ids.assignAll(List<String>.from(_box.read<List>('favorites') ?? const []));
  }

  bool isFav(String id) => ids.contains(id);

  /// Returns true when the path was added.
  bool toggle(String id) {
    final added = !ids.contains(id);
    added ? ids.add(id) : ids.remove(id);
    _box.write('favorites', ids.toList());
    return added;
  }
}
