import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/path_model.dart';

class PathRepository extends GetxService {
  List<PathModel> _paths = const [];
  List<PathModel> get all => _paths;

  Future<PathRepository> load() async {
    final raw = await rootBundle.loadString('assets/data/paths.json');
    final list = jsonDecode(raw) as List;
    _paths = list
        .map((e) => PathModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return this;
  }

  List<PathModel> forSeva(String sevaId) =>
      _paths.where((p) => p.seva == sevaId).toList();

  List<PathModel> forCategory(String categoryId) =>
      _paths.where((p) => p.category == categoryId).toList();

  PathModel? byId(String id) {
    for (final p in _paths) {
      if (p.id == id) return p;
    }
    return null;
  }
}
