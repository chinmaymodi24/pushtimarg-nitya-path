import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/reading_service.dart';
import '../../data/models/path_model.dart';
import '../../data/repository/path_repository.dart';

/// Tracks how far the user has read. A visit counts only once the user
/// actually scrolls; opening a path and leaving records nothing.
class ReaderController extends GetxController {
  /// Scrolled this far (px) before a visit counts as reading.
  static const _engageAfter = 24.0;

  /// A path short enough to fit without scrolling counts after this long.
  static const _shortPathDwell = Duration(seconds: 15);

  late final PathModel path;
  final scroll = ScrollController();
  late final List<GlobalKey> verseKeys;

  final progress = 0.0.obs;
  final verse = 1.obs;

  double? _resumeAt;
  bool _engaged = false;
  bool _sessionCounted = false;
  bool _completedThisSession = false;
  DateTime _lastSave = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _dwell;

  final _reading = Get.find<ReadingController>();

  @override
  void onInit() {
    super.onInit();
    final a = Get.arguments;
    final id = a is Map ? a['id'] as String : a as String;
    if (a is Map) _resumeAt = (a['resume'] as num?)?.toDouble();
    path = Get.find<PathRepository>().byId(id)!;
    verseKeys = List.generate(path.verses.length, (_) => GlobalKey());
    scroll.addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scroll.hasClients) return;
      final max = scroll.position.maxScrollExtent;
      final r = _resumeAt;
      if (r != null && r > 0 && max > 0) {
        scroll.jumpTo((r * max).clamp(0, max));
      } else if (max <= 0) {
        progress.value = 1;
        verse.value = path.verses.length;
        _dwell = Timer(_shortPathDwell, () {
          _engaged = true;
          _save(force: true);
        });
      }
    });
  }

  void _onScroll() {
    final pos = scroll.position;
    final max = pos.maxScrollExtent;
    progress.value = max <= 0 ? 1 : (pos.pixels / max).clamp(0.0, 1.0);
    verse.value = _currentVerse();
    if (!_engaged && pos.pixels > _engageAfter) _engaged = true;
    _save();
  }

  /// Last verse whose top has passed a line a third of the way down.
  int _currentVerse() {
    if (progress.value >= 0.98) return path.verses.length;
    final ctx = Get.context;
    final line = ctx == null ? 300.0 : MediaQuery.sizeOf(ctx).height * 0.35;
    var current = 1;
    for (var i = 0; i < verseKeys.length; i++) {
      final box =
          verseKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy <= line) current = i + 1;
    }
    return current;
  }

  int get versesLeft => path.verses.length - verse.value;

  void _save({bool force = false}) {
    if (!_engaged) return;
    final now = DateTime.now();
    final completedNow = progress.value >= 0.98 && !_completedThisSession;
    if (!force &&
        !completedNow &&
        now.difference(_lastSave) < const Duration(milliseconds: 1500)) {
      return;
    }
    _lastSave = now;
    _reading.save(
      path.id,
      progress: progress.value,
      verse: verse.value,
      newSession: !_sessionCounted,
      completedNow: completedNow,
    );
    _sessionCounted = true;
    if (completedNow) _completedThisSession = true;
  }

  @override
  void onClose() {
    _dwell?.cancel();
    _save(force: true);
    scroll.removeListener(_onScroll);
    scroll.dispose();
    super.onClose();
  }
}
