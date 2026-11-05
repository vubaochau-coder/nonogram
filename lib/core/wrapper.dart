class Wrapper<T> {
  const Wrapper(this.value);

  final T value;
}

extension WrapperNullableExt<T> on Wrapper<T?>? {
  T? unWrapOr(T? other) {
    if (this == null) return other;
    return this!.value;
  }
}
