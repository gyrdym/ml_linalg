import 'package:ml_linalg/linalg.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

void main() {
  group('Float32Vector', () {
    test('should create a vector using elements on specific inidces from '
        'given list', () {
      final vector = Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final query = vector.sample([1, 1, 0, 3]);
      expect(query, equals([3.0, 3.0, 10.0, 7.0]));
      expect(() => vector.sample([20, 0, 1]), throwsRangeError);
    });

    test('`unique` method', () {
      final vector = Vector.fromList([
        10.0,
        3.0,
        4.0,
        0.0,
        7.0,
        4.0,
        12.0,
        3.0,
        12.0,
        9.0,
        0.0,
        12.0,
        10.0,
        3.0
      ]);
      final unique = vector.unique();
      expect(unique, equals([10.0, 3.0, 4.0, 0.0, 7.0, 12.0, 9.0]));
    });
  });
}
