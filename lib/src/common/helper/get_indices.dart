import 'package:xrange/integers.dart';

Iterable<int> getIndices(int maxIndex) =>
    maxIndex == 0
        ? []
        : integers(0, maxIndex, upperClosed: false);