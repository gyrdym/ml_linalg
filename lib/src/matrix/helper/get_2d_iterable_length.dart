int get2dIterableLength(Iterable<Iterable> iterable) =>
    iterable.isNotEmpty && iterable.first.isEmpty
        ? 0
        : iterable.length;
