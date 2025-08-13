extension $IterableExtension<T> on Iterable<T> {
  T? get firstOrNull {
    return isEmpty ? null : first;
  }
}

extension $NullableIterableExtension<T> on Iterable<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNullOrNotEmpty => this != null && this!.isNotEmpty;
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E element, int index) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E element, int index) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}
