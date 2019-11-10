import 'dart:typed_data';

import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/src/matrix/float32/float32_matrix.dart';
import 'package:ml_linalg/src/vector/float32x4_vector.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

void main() {
  group('Float32Vector', () {
    Float32x4Vector vector1;
    Float32x4Vector vector2;

    setUp(() {
      vector1 = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      vector2 = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
    });

    tearDown(() {
      vector1 = null;
      vector2 = null;
    });

    test('should perform division by another vector', () {
      final vector1 = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector1 / vector2;
      expect(actual, equals([1.0, 1.0, 1.0, 1.0, 1.0]));
      expect(actual.length, equals(5));
    });

    test('should throw an error if one tries to divide it by a vector of '
        'different length', () {
      final vector1 = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector1 / vector2, throwsRangeError);
    });

    test('should map an existing vector to a new one processing 4 elements in '
        'a time', () {
      final vector = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      int iteration = 0;
      final actual = vector.fastMap((Float32x4 element) {
        iteration++;
        return element.scale(3.0);
      });
      final expected = [3.0, 6.0, 9.0, 12.0, 15.0, 18.0];
      expect(iteration, equals(2));
      expect(actual, equals(expected));
    });

    test('should raise its elements to the integer power', () {
      final result = vector1.toIntegerPower(3);
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([1.0, 8.0, 27.0, 64.0, 125.0]));
    });

    test('should perform dot product with another vector', () {
      final result = vector1.dot(vector2);
      expect(result, equals(55.0));
    });

    test('should be multiplied by a scalar', () {
      final result = vector1 * 2.0;
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([2.0, 4.0, 6.0, 8.0, 10.0]));
    });

    test('should be divided by a scalar', () {
      final result = vector1 / 2.0;
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([0.5, 1.0, 1.5, 2.0, 2.5]));
    });

    test('should perform addition of a scalar', () {
      final result = vector1 + 13.0;
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([14.0, 15.0, 16.0, 17.0, 18.0]));
    });

    test('should perform substruction of a scalar', () {
      final vector = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final result = vector - 13.0;
      expect(result != vector, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([-12.0, -11.0, -10.0, -9.0, -8.0]));
    });

    test('should find Euclidean distance (from vector to the same vector)', () {
      final vector = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0]);
      final distance = vector.distanceTo(vector);
      expect(distance, equals(0.0),
          reason: 'Wrong vector distance calculation');
    });

    test('should find euclidean distance', () {
      final vector1 = Float32x4Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final vector2 = Float32x4Vector.fromList([1.0, 3.0, 2.0, 11.5, 10.0, 15.5]);
      expect(vector1.distanceTo(vector2, distance: Distance.euclidean),
          equals(10.88577052853862));
    });

    test('should find manhattan distance', () {
      final vector1 = Float32x4Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final vector2 = Float32x4Vector.fromList([1.0, 3.0, 2.0, 11.5, 10.0, 15.5]);
      expect(vector1.distanceTo(vector2, distance: Distance.manhattan),
          equals(20.0));
    });

    test('should find cosine distance (the same vectors)', () {
      final vector1 = Float32x4Vector.fromList([1.0, 0.0]);
      final vector2 = Float32x4Vector.fromList([1.0, 0.0]);
      expect(vector1.distanceTo(vector2, distance: Distance.cosine),
          equals(0.0));
    });

    test('should find cosine distance (different vectors)', () {
      final vector1 = Float32x4Vector.fromList([4.0, 3.0]);
      final vector2 = Float32x4Vector.fromList([2.0, 4.0]);
      expect(vector1.distanceTo(vector2, distance: Distance.cosine),
          closeTo(0.1055, 1e-4));
    });

    test('should find cosine distance (different vectors with negative '
        'elements)', () {
      final vector1 = Float32x4Vector.fromList([4.0, -3.0]);
      final vector2 = Float32x4Vector.fromList([-2.0, 4.0]);
      expect(vector1.distanceTo(vector2, distance: Distance.cosine),
          closeTo(1.8944, 1e-4));
    });

    test('should find cosine distance (one of two vectors is zero-vector)', () {
      final vector1 = Float32x4Vector.fromList([0.0, 0.0]);
      final vector2 = Float32x4Vector.fromList([-2.0, 4.0]);
      expect(() => vector1.distanceTo(vector2, distance: Distance.cosine),
          throwsException);
    });

    test('should find vector norm', () {
      final vector = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.norm(Norm.euclidean), equals(closeTo(7.41, 1e-2)));
      expect(vector.norm(Norm.manhattan), equals(15.0));
    });

    test('should normalize itself (eucleadean norm)', () {
      final vector = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.normalize(Norm.euclidean);
      final expected = [0.134, 0.269, 0.404, 0.539, 0.674];
      expect(actual, iterableAlmostEqualTo(expected, 1e-3));
      expect(actual.norm(Norm.euclidean), closeTo(1.0, 1e-3));
    });

    test('should normalize itself (Manhattan norm)', () {
      final vector = Float32x4Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0]);
      final actual = vector.normalize(Norm.manhattan);
      final expected = [1 / 15, -2 / 15, 3 / 15, -4 / 15, 5 / 15];
      expect(actual, iterableAlmostEqualTo(expected, 1e-3));
      expect(actual.norm(Norm.manhattan), closeTo(1.0, 1e-3));
    });

    test('should rescale its every element into range [0...1]', () {
      final vector = Float32x4Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0, 0.0]);
      final actual = vector.rescale(); // min = -4, diff = 9
      final expected = [5 / 9, 2 / 9, 7 / 9, 0.0, 1.0, 4 / 9];
      expect(actual, iterableAlmostEqualTo(expected, 1e-3));
      expected.forEach((element) => expect(element, inInclusiveRange(0, 1)));
    });

    test('should find vector elements sum', () {
      final vector = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.sum(), equals(15.0));
    });

    test('should find vector elements absolute value', () {
      final vector = Float32x4Vector.fromList([-3.0, 4.5, -12.0, -23.5, 44.0]);
      final result = vector.abs();
      expect(result, equals([3.0, 4.5, 12.0, 23.5, 44.0]));
      expect(result, isNot(vector));
    });

    test('should create a vector using elements on specific inidces from '
        'given list', () {
      final vector = Float32x4Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final query = vector.sample([1, 1, 0, 3]);
      expect(query, equals([3.0, 3.0, 10.0, 7.0]));
      expect(() => vector.sample([20, 0, 1]), throwsRangeError);
    });

    test('`unique` method', () {
      final vector = Float32x4Vector.fromList([
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

    group('max', () {
      test('should find a minimal element for the vector with more than 4 '
          'elements', () {
        final vector = Float32x4Vector.fromList([10.0, 12.0, 4.0, 7.0, 9.0, 12.0]);
        expect(vector.max(), 12.0);
      });

      test('should find a minimal element for the vector with 4 elements', () {
        final vector = Float32x4Vector.fromList([10.0, 11.0, -4.0, 0.0]);
        expect(vector.max(), 11.0);
      });

      test('should find a minimal element for the vector with less than 4 '
          'elements', () {
        final vector = Float32x4Vector.fromList([7.0, -4.0, 0.0]);
        expect(vector.max(), 7.0);
      });
    });

    group('min', () {
      test('should find a minimal element for the vector with more than 4 '
          'elements', () {
        final vector = Float32x4Vector.fromList([10.0, 1.0, 4.0, 7.0, 9.0, 1.0]);
        expect(vector.min(), 1.0);
      });

      test('should find a minimal element for the vector with 4 '
          'elements', () {
        final vector = Float32x4Vector.fromList([10.0, 0.0, 4.0, 7.0]);
        expect(vector.min(), 0.0);
      });

      test('should find a minimal element for the vector with length that is '
          'less than 4', () {
        final vector = Float32x4Vector.fromList([10.0, 1.0, 4.0]);
        expect(vector.min(), 1.0);
      });
    });

    group('[]', () {
      test('should provide indexed access ([] operator, case 1)', () {
        final vector = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
        expect(vector[0], 1.0);
        expect(vector[1], 2.0);
        expect(vector[2], 3.0);
        expect(vector[3], 4.0);
        expect(vector[4], 5.0);
        expect(() => vector[-1], throwsRangeError);
        expect(() => vector[5], throwsRangeError);
        expect(() => vector[100], throwsRangeError);
      });

      test('should provide indexed access ([] operator, case 2)', () {
        final vector = Float32x4Vector.fromList([1.0, 2.0, 3.0, 4.0]);
        expect(vector[0], 1.0);
        expect(vector[1], 2.0);
        expect(vector[2], 3.0);
        expect(vector[3], 4.0);
        expect(() => vector[-1], throwsRangeError);
        expect(() => vector[4], throwsRangeError);
        expect(() => vector[100], throwsRangeError);
      });

      test('should provide indexed access ([] operator, case 3)', () {
        final vector = Float32x4Vector.fromList([1.0, 2.0, 3.0]);
        expect(vector[0], 1.0);
        expect(vector[1], 2.0);
        expect(vector[2], 3.0);
        expect(() => vector[-1], throwsRangeError);
        expect(() => vector[3], throwsRangeError);
        expect(() => vector[100], throwsRangeError);
      });

      test('should provide indexed access ([] operator, case 4)', () {
        final vector = Float32x4Vector.fromList([1.0, 2.0]);
        expect(vector[0], 1.0);
        expect(vector[1], 2.0);
        expect(() => vector[-1], throwsRangeError);
        expect(() => vector[2], throwsRangeError);
        expect(() => vector[100], throwsRangeError);
      });

      test('should provide indexed access ([] operator, case 5)', () {
        final vector = Float32x4Vector.fromList([1.0]);
        expect(vector[0], 1.0);
        expect(() => vector[-1], throwsRangeError);
        expect(() => vector[1], throwsRangeError);
        expect(() => vector[100], throwsRangeError);
      });
    });

    group('sqrt', () {
      test('should extract square root of each element', () {
        final vector = Float32x4Vector.fromList([4, 25, 9]);
        expect(vector.sqrt(), equals([2, 5, 3]));
      });

      test('should return NaN value for negative elements', () {
        final vector = Float32x4Vector.fromList([-4, -25, -9]);
        expect(vector.sqrt(), equals([isNaN, isNaN, isNaN]));
      });
    });
  });
}
