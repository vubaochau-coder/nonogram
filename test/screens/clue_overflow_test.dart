import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/screens/play/engine/clue_overflow.dart';

void main() {
  // Dải hiện được 6 ô số, mỗi ô dày 20.
  ClueOverflow of(int count, {double scroll = 0}) => ClueOverflow.of(
    count: count,
    depth: 20,
    visibleExtent: 120,
    scroll: scroll,
  );

  test('lines that fit show no chip', () {
    expect(of(0).any, isFalse);
    expect(of(3).any, isFalse);
    expect(of(6).any, isFalse);
  });

  test('one number cut on the far side: chip covers one more, shows +2', () {
    // 7 số, thấy 6: chip đè số thứ 6 nên còn 2 số chưa thấy.
    final o = of(7);
    expect(o.far, 2);
    expect(o.near, 0);
  });

  test('scrolled all the way out: the chip moves to the grid side', () {
    final o = of(7, scroll: 20);
    expect(o.far, 0);
    expect(o.near, 2);
  });

  test('scrolled half way: chips on both sides', () {
    // 10 số, thấy 6, đã cuộn ra 2 ô: phía xa còn 2 khuất + 1 dưới chip,
    // phía gần 2 khuất + 1 dưới chip.
    final o = of(10, scroll: 40);
    expect(o.far, 3);
    expect(o.near, 3);
  });

  test('a half-hidden number counts as hidden', () {
    final o = of(6, scroll: 10);
    expect(o.far, 0);
    expect(o.near, 2);
  });

  test('short lines pushed out by scrolling get a grid-side chip', () {
    // Dải đã cuộn ra xa vì một hàng dài khác: hai số của hàng ngắn khuất
    // hẳn về phía lưới.
    final o = of(2, scroll: 40);
    expect(o.far, 0);
    expect(o.near, 2);
  });
}
