int getLengthOfFirstOrZero(Iterable<Iterable> collection) =>
    collection.isNotEmpty ? collection.first.length : 0;
