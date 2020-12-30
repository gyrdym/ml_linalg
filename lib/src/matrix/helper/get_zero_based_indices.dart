import 'package:xrange/xrange.dart';

Iterable<int> getZeroBasedIndices(int maxIndex) =>
    maxIndex == 0
        ? []
        : integers(0, maxIndex);
