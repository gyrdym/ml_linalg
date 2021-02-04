import 'package:quiver/iterables.dart';

Iterable<int> getZeroBasedIndices(int maxIndex) =>
    maxIndex == 0
        ? []
        : count(0).take(maxIndex).map((value) => value.toInt());
