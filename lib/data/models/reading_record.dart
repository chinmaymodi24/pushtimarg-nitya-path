/// What the user has read of one path. Stored on the device only.
class ReadRecord {
  ReadRecord({
    required this.pathId,
    required this.lastReadAt,
    required this.progress,
    required this.verse,
    this.readCount = 0,
    this.completedCount = 0,
  });

  final String pathId;
  DateTime lastReadAt;

  /// 0..1 of the page scrolled.
  double progress;

  /// 1-based verse the reader was on.
  int verse;
  int readCount;
  int completedCount;

  bool get isComplete => progress >= 0.98;

  Map<String, dynamic> toJson() => {
        'id': pathId,
        'at': lastReadAt.millisecondsSinceEpoch,
        'p': progress,
        'v': verse,
        'reads': readCount,
        'done': completedCount,
      };

  factory ReadRecord.fromJson(Map j) => ReadRecord(
        pathId: j['id'] as String,
        lastReadAt: DateTime.fromMillisecondsSinceEpoch(j['at'] as int),
        progress: (j['p'] as num).toDouble(),
        verse: j['v'] as int,
        readCount: j['reads'] as int? ?? 0,
        completedCount: j['done'] as int? ?? 0,
      );
}

/// One completed mala.
class MalaEntry {
  MalaEntry({required this.completedAt, this.seconds});

  final DateTime completedAt;

  /// Time from the first bead to the 108th, when known.
  final int? seconds;

  Map<String, dynamic> toJson() =>
      {'at': completedAt.millisecondsSinceEpoch, 's': seconds};

  factory MalaEntry.fromJson(Map j) => MalaEntry(
        completedAt: DateTime.fromMillisecondsSinceEpoch(j['at'] as int),
        seconds: j['s'] as int?,
      );
}
