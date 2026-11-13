import 'package:equatable/equatable.dart';

/// Công cụ hỗ trợ khi chơi.
enum PowerUp { hint, wand }

/// Kho gợi ý / gậy phép dùng chung cho mọi màn, lưu trên máy. Gồm hai phần:
///
/// - **Lượt vĩnh viễn** ([hints], [wands]): lượt tặng ban đầu ([starter]) và
///   quà mốc điểm danh; cộng dồn được.
/// - **Lượt trong ngày** ([dailyHints], [dailyWands]): quà điểm danh của gói
///   không quảng cáo, chỉ dùng được trong ngày [dailyDay] (xem [activeOn]),
///   không cộng dồn sang hôm sau. Khi dùng, lượt trong ngày bị trừ trước.
class PowerUpInventory extends Equatable {
  const PowerUpInventory({
    required this.hints,
    required this.wands,
    this.dailyHints = 0,
    this.dailyWands = 0,
    this.dailyDay,
  });

  static const starter = PowerUpInventory(hints: 3, wands: 1);

  /// Lượt vĩnh viễn.
  final int hints;
  final int wands;

  /// Lượt trong ngày [dailyDay] (số ngày kể từ 1970-01-01, lịch địa phương).
  final int dailyHints;
  final int dailyWands;
  final int? dailyDay;

  int get totalHints => hints + dailyHints;
  int get totalWands => wands + dailyWands;

  int totalOf(PowerUp powerUp) => switch (powerUp) {
    PowerUp.hint => totalHints,
    PowerUp.wand => totalWands,
  };

  int dailyOf(PowerUp powerUp) => switch (powerUp) {
    PowerUp.hint => dailyHints,
    PowerUp.wand => dailyWands,
  };

  bool get hasDaily => dailyHints > 0 || dailyWands > 0;

  /// Kho như ngày [today]: lượt trong ngày của ngày khác đã hết hạn.
  PowerUpInventory activeOn(int today) =>
      dailyDay == today ? this : PowerUpInventory(hints: hints, wands: wands);

  /// Dùng một lượt: trừ lượt trong ngày trước, hết mới trừ lượt vĩnh viễn.
  PowerUpInventory consume(PowerUp powerUp) {
    switch (powerUp) {
      case PowerUp.hint:
        if (dailyHints > 0) return _copy(dailyHints: dailyHints - 1);
        return _copy(hints: hints > 0 ? hints - 1 : 0);
      case PowerUp.wand:
        if (dailyWands > 0) return _copy(dailyWands: dailyWands - 1);
        return _copy(wands: wands > 0 ? wands - 1 : 0);
    }
  }

  /// Thêm [amount] lượt vĩnh viễn.
  PowerUpInventory addPermanent(PowerUp powerUp, int amount) =>
      switch (powerUp) {
        PowerUp.hint => _copy(hints: hints + amount),
        PowerUp.wand => _copy(wands: wands + amount),
      };

  /// Đặt lượt trong ngày [day] (thay hẳn lượt trong ngày cũ).
  PowerUpInventory withDaily({
    required int hints,
    required int wands,
    required int day,
  }) => PowerUpInventory(
    hints: this.hints,
    wands: this.wands,
    dailyHints: hints,
    dailyWands: wands,
    dailyDay: day,
  );

  PowerUpInventory _copy({
    int? hints,
    int? wands,
    int? dailyHints,
    int? dailyWands,
  }) => PowerUpInventory(
    hints: hints ?? this.hints,
    wands: wands ?? this.wands,
    dailyHints: dailyHints ?? this.dailyHints,
    dailyWands: dailyWands ?? this.dailyWands,
    dailyDay: dailyDay,
  );

  Map<String, dynamic> toMap() => {
    'hints': hints,
    'wands': wands,
    'dailyHints': dailyHints,
    'dailyWands': dailyWands,
    'dailyDay': dailyDay,
  };

  factory PowerUpInventory.fromMap(Map<String, dynamic> map) =>
      PowerUpInventory(
        hints: (map['hints'] as int?) ?? starter.hints,
        wands: (map['wands'] as int?) ?? starter.wands,
        dailyHints: (map['dailyHints'] as int?) ?? 0,
        dailyWands: (map['dailyWands'] as int?) ?? 0,
        dailyDay: map['dailyDay'] as int?,
      );

  @override
  List<Object?> get props => [hints, wands, dailyHints, dailyWands, dailyDay];
}
