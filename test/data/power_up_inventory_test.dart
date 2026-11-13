import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/models/power_up_inventory.dart';

void main() {
  const day = 20000;
  final inventory = const PowerUpInventory(
    hints: 3,
    wands: 0,
  ).withDaily(hints: 2, wands: 1, day: day);

  test('totals include today-only uses', () {
    expect(inventory.totalHints, 5);
    expect(inventory.totalWands, 1);
    expect(inventory.dailyOf(PowerUp.hint), 2);
  });

  test('today-only uses are spent first', () {
    var inv = inventory.consume(PowerUp.hint);
    expect(inv.dailyHints, 1);
    expect(inv.hints, 3);
    inv = inv.consume(PowerUp.hint).consume(PowerUp.hint);
    expect(inv.dailyHints, 0);
    expect(inv.hints, 2);
  });

  test('today-only uses expire on another day', () {
    expect(inventory.activeOn(day), inventory);
    final tomorrow = inventory.activeOn(day + 1);
    expect(tomorrow.dailyHints, 0);
    expect(tomorrow.dailyWands, 0);
    expect(tomorrow.hints, 3);
  });

  test('never goes below zero', () {
    const empty = PowerUpInventory(hints: 0, wands: 0);
    expect(empty.consume(PowerUp.wand), empty);
  });

  test('round-trips through storage, old saves become permanent uses', () {
    expect(PowerUpInventory.fromMap(inventory.toMap()), inventory);
    expect(
      PowerUpInventory.fromMap({'hints': 1, 'wands': 2}),
      const PowerUpInventory(hints: 1, wands: 2),
    );
  });
}
