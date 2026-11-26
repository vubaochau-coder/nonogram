import 'package:collection/collection.dart';
import 'package:nonogram/engine/model/nonogram_cell_state.dart';

class NonogramGridEquality {
  static bool equals(
    List<List<NonogramCellState>> a,
    List<List<NonogramCellState>> b,
  ) {
    return const DeepCollectionEquality().equals(a, b);
  }
}
