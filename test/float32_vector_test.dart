import 'package:ml_linalg/linalg.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

void main() {
  group('Float32Vector', () {
    test('should normalize itself (eucleadean norm)', () {
      final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.normalize(Norm.euclidean);
      final expected = [0.134, 0.269, 0.404, 0.539, 0.674];
      expect(actual, iterableAlmostEqualTo(expected, 1e-3));
      expect(actual.norm(Norm.euclidean), closeTo(1.0, 1e-3));
    });

    test('should normalize itself (Manhattan norm)', () {
      final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0]);
      final actual = vector.normalize(Norm.manhattan);
      final expected = [1 / 15, -2 / 15, 3 / 15, -4 / 15, 5 / 15];
      expect(actual, iterableAlmostEqualTo(expected, 1e-3));
      expect(actual.norm(Norm.manhattan), closeTo(1.0, 1e-3));
    });

    test('should rescale its every element into range [0...1]', () {
      final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0, 0.0]);
      final actual = vector.rescale(); // min = -4, diff = 9
      final expected = [5 / 9, 2 / 9, 7 / 9, 0.0, 1.0, 4 / 9];
      expect(actual, iterableAlmostEqualTo(expected, 1e-3));
      expected.forEach((element) => expect(element, inInclusiveRange(0, 1)));
    });

    test('should find vector elements sum', () {
      final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.sum(), equals(15.0));
    });

    test('should find vector elements absolute value', () {
      final vector = Vector.fromList([-3.0, 4.5, -12.0, -23.5, 44.0]);
      final result = vector.abs();
      expect(result, equals([3.0, 4.5, 12.0, 23.5, 44.0]));
      expect(result, isNot(vector));
    });

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
