int getLengthOfFirstOrZero<T extends Iterable<double>>(List<T> collection) =>
    collection.isNotEmpty ? collection.first.length : 0;
