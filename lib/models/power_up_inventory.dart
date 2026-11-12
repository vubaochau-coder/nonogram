import 'package:equatable/equatable.dart';

/// Công cụ hỗ trợ khi chơi.
enum PowerUp { hint, wand }

/// Kho gợi ý / gậy phép dùng chung cho mọi màn, lưu trên máy.
///
/// Người chơi mới được tặng [starter] một lần duy nhất. Qua màn không được
/// trả lại, giải màn không được thưởng: dùng hết thì chỉ có thể xem quảng cáo
/// để dùng thêm từng lượt (không tích luỹ được).
class PowerUpInventory extends Equatable {
  const PowerUpInventory({required this.hints, required this.wands});

  static const starter = PowerUpInventory(hints: 3, wands: 1);

  final int hints;
  final int wands;

  int countOf(PowerUp powerUp) => switch (powerUp) {
    PowerUp.hint => hints,
    PowerUp.wand => wands,
  };

  PowerUpInventory copyWith({int? hints, int? wands}) =>
      PowerUpInventory(hints: hints ?? this.hints, wands: wands ?? this.wands);

  Map<String, dynamic> toMap() => {'hints': hints, 'wands': wands};

  factory PowerUpInventory.fromMap(Map<String, dynamic> map) =>
      PowerUpInventory(
        hints: (map['hints'] as int?) ?? starter.hints,
        wands: (map['wands'] as int?) ?? starter.wands,
      );

  @override
  List<Object?> get props => [hints, wands];
}
