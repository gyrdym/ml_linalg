import 'package:test/test.dart';

Matcher iterable2dAlmostEqualTo(Iterable<Iterable<num>> expected,
        [num precision = 1e-5]) =>
    pairwiseCompare<Iterable<num>, Iterable<num>>(expected,
        (Iterable<num> expected, Iterable<num> actual) {
      if (expected.length != actual.length) {
        return false;
      }
      for (var i = 0; i < expected.length; i++) {
        if ((expected.elementAt(i) - actual.elementAt(i)).abs() >= precision) {
          return false;
        }
      }
      return true;
    }, '');

Matcher iterableAlmostEqualTo(Iterable<num> expected, [num precision = 1e-5]) =>
    pairwiseCompare<num, num>(
        expected,
        (expectedVal, actualVal) =>
            (expectedVal - actualVal).abs() <= precision,
        '');
