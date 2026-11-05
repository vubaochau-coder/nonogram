class NonogramCompletedProgress {
  final String puzzleId;
  final int level;
  final int bestCompletionMs;
  final DateTime completedAt;
  final DateTime lastPlayedAt;

  const NonogramCompletedProgress({
    required this.puzzleId,
    required this.level,
    required this.bestCompletionMs,
    required this.completedAt,
    required this.lastPlayedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'puzzleId': puzzleId,
      'level': level,
      'bestCompletionMs': bestCompletionMs,
      'completedAt': completedAt.toIso8601String(),
      'lastPlayedAt': lastPlayedAt.toIso8601String(),
    };
  }

  factory NonogramCompletedProgress.fromMap(Map<String, dynamic> map) {
    return NonogramCompletedProgress(
      puzzleId: map['puzzleId'] as String,
      level: map['level'] as int,
      bestCompletionMs: map['bestCompletionMs'] as int,
      completedAt: DateTime.parse(map['completedAt'] as String),
      lastPlayedAt: DateTime.parse(map['lastPlayedAt'] as String),
    );
  }

  NonogramCompletedProgress copyWith({
    String? puzzleId,
    int? level,
    int? bestCompletionMs,
    DateTime? completedAt,
    DateTime? lastPlayedAt,
  }) {
    return NonogramCompletedProgress(
      puzzleId: puzzleId ?? this.puzzleId,
      level: level ?? this.level,
      bestCompletionMs: bestCompletionMs ?? this.bestCompletionMs,
      completedAt: completedAt ?? this.completedAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is NonogramCompletedProgress &&
      other.puzzleId == puzzleId &&
      other.level == level &&
      other.bestCompletionMs == bestCompletionMs &&
      other.completedAt == completedAt &&
      other.lastPlayedAt == lastPlayedAt;

  @override
  int get hashCode =>
      Object.hash(puzzleId, level, bestCompletionMs, completedAt, lastPlayedAt);
}
