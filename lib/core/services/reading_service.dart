import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/reading_record.dart';

/// Reading history and "continue where you left off".
class ReadingController extends GetxController {
  final _box = GetStorage();
  final records = <String, ReadRecord>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final raw = _box.read<List>('reading') ?? const [];
    for (final e in raw) {
      final r = ReadRecord.fromJson(e as Map);
      records[r.pathId] = r;
    }
  }

  /// Most recently read first.
  List<ReadRecord> get sorted =>
      records.values.toList()
        ..sort((a, b) => b.lastReadAt.compareTo(a.lastReadAt));

  ReadRecord? get last => records.isEmpty ? null : sorted.first;

  void save(
    String pathId, {
    required double progress,
    required int verse,
    bool newSession = false,
    bool completedNow = false,
  }) {
    final r =
        records[pathId] ??
        ReadRecord(
          pathId: pathId,
          lastReadAt: DateTime.now(),
          progress: 0,
          verse: 1,
        );
    r
      ..lastReadAt = DateTime.now()
      ..progress = progress
      ..verse = verse;
    if (newSession) r.readCount++;
    if (completedNow) r.completedCount++;
    records[pathId] = r;
    records.refresh();
    _persist();
  }

  void remove(String pathId) {
    records.remove(pathId);
    _persist();
  }

  void clear() {
    records.clear();
    _persist();
  }

  void _persist() =>
      _box.write('reading', records.values.map((r) => r.toJson()).toList());
}
