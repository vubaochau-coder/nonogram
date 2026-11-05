extension ListExtension<T> on List<T> {
  /// Returns an unmodifiable version of this list.
  List<T> toUnmodifiable() => List<T>.unmodifiable(this);
}

extension List2DExtension<T> on List<List<T>> {
  /// Returns an unmodifiable version of this 2D list (both outer and inner lists).
  List<List<T>> toUnmodifiable2D() {
    return List<List<T>>.unmodifiable(map((row) => List<T>.unmodifiable(row)));
  }
}
