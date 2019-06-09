import 'dart:typed_data';

import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/src/matrix/float32/float32_matrix.dart';
import 'package:ml_linalg/src/vector/float32/float32_vector.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

import 'unit_test_helpers/float_iterable_almost_equal_to.dart';

void main() {
  group('Float32Vector', () {
    group('`fromList` constructor', () {
      test('should create a vector from dynamic-length list, length is '
          'greater than 4', () {
        final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
        expect(vector1, equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));
        expect(vector1.length, equals(6));
      });

      test('should create a vector from dynamic-length list, length is less '
          'than 4', () {
        final vector = Float32Vector.fromList([1.0, 2.0]);
        expect(vector, equals([1.0, 2.0]));
        expect(vector.length, equals(2));
      });

      test('should create a vector from fixed-length list, length is greater '
          'than 4', () {
        final vector = Float32Vector.fromList(List.filled(11, 1.0));
        expect(vector,
            equals([1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]));
        expect(vector.length, 11);
      });

      test('should create a vector from fixed-length list, length is less '
          'than 4', () {
        final vector = Float32Vector.fromList(List.filled(1, 2.0));
        expect(vector, equals([2.0]));
        expect(vector.length, 1);
      });

      test('should create a vector from an empty list', () {
        final vector = Float32Vector.fromList([]);
        expect(vector, equals(<double>[]));
        expect(vector.length, 0);
      });
    });

    group('`fromSIMDList` constructor', () {
      final typedList = Float32x4List.fromList([
        Float32x4(1.0, 2.0, 3.0, 4.0),
        Float32x4(5.0, 6.0, 7.0, 8.0),
        Float32x4(9.0, 10.0, 0.0, 0.0)
      ]);

      test('should create a vector with length equal to the length of the '
          'source', () {
        final vector = Float32Vector.fromSimdList(typedList, 12);
        expect(
            vector.toList(),
            equals(
                [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 0.0, 0.0]));
        expect(vector.length, equals(12));
      });

      test('should create a vector and limit its length if argument `length` '
          'is given', () {
        final vector = Float32Vector.fromSimdList(typedList, 10);
        expect(vector,
            equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]));
        expect(vector.length, equals(10));
      });
    });

    group('`filled` constructor', () {
      test('should create a vector filled with the passed value', () {
        final vector = Float32Vector.filled(10, 2.0);
        expect(
            vector, equals([2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]));
        expect(vector.length, equals(10));
      });
    });

    group('`zero` constructor', () {
      test('should fill a newly created vector with zeroes, case 1', () {
        final vector = Float32Vector.zero(10);
        expect(
            vector, equals([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]));
        expect(vector.length, equals(10));
      });

      test('should fill a newly created vector with zeroes, case 1', () {
        final vector = Float32Vector.zero(1);
        expect(vector, equals([0.0]));
        expect(vector.length, equals(1));
      });

      test('should fill a newly created vector with zeroes, case 1', () {
        final vector = Float32Vector.zero(2);
        expect(vector, equals([0.0, 0.0]));
        expect(vector.length, equals(2));
      });
    });
  });

  group('Float32Vector', () {
    Float32Vector vector1;
    Float32Vector vector2;

    setUp(() {
      vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      vector2 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
    });

    tearDown(() {
      vector1 = null;
      vector2 = null;
    });

    test('should perform addition of another vector', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector1 + vector2;
      final expected = [2.0, 4.0, 6.0, 8.0, 10.0];
      expect(actual, equals(expected));
      expect(actual.length, equals(5));
    });

    test('should compare with another vector and return `true` if vectors are'
        'equal', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector1 == vector2, isTrue);
    });

    test('should compare with another vector and return `true` if vectors are'
        'have all zero values', () {
      final vector1 = Float32Vector.fromList([0.0, 0.0, 0.0, 0.0, 0.0]);
      final vector2 = Float32Vector.fromList([0.0, 0.0, 0.0, 0.0, 0.0]);
      expect(vector1 == vector2, isTrue);
    });

    test('should compare with another vector and return `false` if vectors are'
        'different', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32Vector.fromList([1.0, 2.0, 30.0, 4.0, 5.0]);
      expect(vector1 == vector2, isFalse);
    });

    test('should compare with another vector and return `false` if vectors are'
        'have opposite values', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32Vector.fromList([-1.0, -2.0, -3.0, -4.0, -5.0]);
      expect(vector1 == vector2, isFalse);
    });

    test('should compare with another vector and return `false` if one vector'
        'have all zero values', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32Vector.fromList([0.0, 0.0, 0.0, 0.0, 0.0]);
      expect(vector1 == vector2, isFalse);
    });

    test('should compare with another vector and return `false` if vectors '
        'have different lengths', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      final vector2 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector1 == vector2, isFalse);
    });

    test('should compare with another object and return `false` if another '
        'object is not a vector', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      final vector2 = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0];
      // ignore: unrelated_type_equality_checks
      expect(vector1 == vector2, isFalse);
    });

    test('should throw an exception if one tries to sum vectors of different '
        'lengths', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector1 + vector2, throwsRangeError);
    });

    test('should perform addition of a column matrix', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final matrix = Float32Matrix.fromList([
        [1.0],
        [2.0],
        [3.0],
        [4.0],
        [5.0],
      ]);
      final actual = vector + matrix;
      final expected = [2.0, 4.0, 6.0, 8.0, 10.0];
      expect(actual, equals(expected));
      expect(actual.length, equals(5));
    });

    test('should perform addition of a rows matrix', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final matrix = Float32Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0, 5.0]
      ]);
      final actual = vector + matrix;
      final expected = [2.0, 4.0, 6.0, 8.0, 10.0];
      expect(actual, equals(expected));
      expect(actual.length, equals(5));
    });

    test('should perform a subtraction of another vector', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final result = vector1 - vector2;
      expect(result, equals([0.0, 0.0, 0.0, 0.0, 0.0]));
      expect(result.length, equals(5));
    });

    test('should throw an exception if one tries to subtract a vector of '
        'different length', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector1 - vector2, throwsRangeError);
    });

    test('should perform subtraction of a column matrix', () {
      final vector = Float32Vector.fromList([2.0, 6.0, 12.0, 15.0, 18.0]);
      final matrix = Float32Matrix.fromList([
        [1.0],
        [2.0],
        [3.0],
        [4.0],
        [5.0],
      ]);
      final actual = vector - matrix;
      final expected = [1.0, 4.0, 9.0, 11.0, 13.0];
      expect(actual, equals(expected));
      expect(actual.length, equals(5));
    });

    test('should perform subtraction of a row matrix', () {
      final vector = Float32Vector.fromList([2.0, 6.0, 12.0, 15.0, 18.0]);
      final matrix = Float32Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0, 5.0]
      ]);
      final actual = vector - matrix;
      final expected = [1.0, 4.0, 9.0, 11.0, 13.0];
      expect(actual, equals(expected));
      expect(actual.length, equals(5));
    });

    test('should perform subtraction of a row matrix', () {
      final vector = Float32Vector.fromList([2.0, 6.0, 12.0, 15.0, 18.0]);
      final matrix = Float32Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0, 5.0]
      ]);
      final actual = vector - matrix;
      final expected = [1.0, 4.0, 9.0, 11.0, 13.0];
      expect(actual, equals(expected));
      expect(actual.length, equals(5));
    });

    test('should perform multiplication by another vector', () {
      final actual = vector1 * vector2;
      expect(actual, equals([1.0, 4.0, 9.0, 16.0, 25.0]));
      expect(actual.length, equals(5));
    });

    test('should throw an error if one tries to multiple by a vector of '
        'different length', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector1 * vector2, throwsRangeError);
    });

    test('should perform multiplication by a matrix', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0]);
      final matrix = Float32Matrix.fromList([
        [2.0, 3.0],
        [4.0, 5.0],
        [6.0, 7.0],
      ]);
      final actual = vector * matrix;
      final expected = [28.0, 34.0];
      expect(actual, equals(expected));
      expect(actual.length, equals(2));
    });

    test('should throw an exception if one tries to multiple by an '
        'inappropriate matrix', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0]);
      final matrix = Float32Matrix.fromList([
        [2.0, 3.0],
        [4.0, 5.0],
      ]);
      final actual = () => vector * matrix;
      expect(actual, throwsException,
          reason: 'the matrix has different row number than the vector');
    });

    test('should perform division by another vector', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector1 / vector2;
      expect(actual, equals([1.0, 1.0, 1.0, 1.0, 1.0]));
      expect(actual.length, equals(5));
    });

    test('should throw an error if one tries to divide it by a vector of '
        'different length', () {
      final vector1 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector2 = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector1 / vector2, throwsRangeError);
    });

    test('should map an existing vector to a new one processing 4 elements in '
        'a time', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
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
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final result = vector - 13.0;
      expect(result != vector, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([-12.0, -11.0, -10.0, -9.0, -8.0]));
    });

    test('should find Euclidean distance (from vector to the same vector)', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0]);
      final distance = vector.distanceTo(vector);
      expect(distance, equals(0.0),
          reason: 'Wrong vector distance calculation');
    });

    test('should find euclidean distance', () {
      final vector1 = Float32Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final vector2 = Float32Vector.fromList([1.0, 3.0, 2.0, 11.5, 10.0, 15.5]);
      expect(vector1.distanceTo(vector2, distance: Distance.euclidean),
          equals(10.88577052853862));
    });

    test('should find manhattan distance', () {
      final vector1 = Float32Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final vector2 = Float32Vector.fromList([1.0, 3.0, 2.0, 11.5, 10.0, 15.5]);
      expect(vector1.distanceTo(vector2, distance: Distance.manhattan),
          equals(20.0));
    });

    test('should find cosine distance (the same vectors)', () {
      final vector1 = Float32Vector.fromList([1.0, 0.0]);
      final vector2 = Float32Vector.fromList([1.0, 0.0]);
      expect(vector1.distanceTo(vector2, distance: Distance.cosine),
          equals(0.0));
    });

    test('should find cosine distance (different vectors)', () {
      final vector1 = Float32Vector.fromList([4.0, 3.0]);
      final vector2 = Float32Vector.fromList([2.0, 4.0]);
      expect(vector1.distanceTo(vector2, distance: Distance.cosine),
          closeTo(0.1055, 1e-4));
    });

    test('should find cosine distance (different vectors with negative '
        'elements)', () {
      final vector1 = Float32Vector.fromList([4.0, -3.0]);
      final vector2 = Float32Vector.fromList([-2.0, 4.0]);
      expect(vector1.distanceTo(vector2, distance: Distance.cosine),
          closeTo(1.8944, 1e-4));
    });

    test('should find cosine distance (one of two vectors is zero-vector)', () {
      final vector1 = Float32Vector.fromList([0.0, 0.0]);
      final vector2 = Float32Vector.fromList([-2.0, 4.0]);
      expect(() => vector1.distanceTo(vector2, distance: Distance.cosine),
          throwsException);
    });

    test('should find vector norm', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.norm(Norm.euclidean), equals(closeTo(7.41, 1e-2)));
      expect(vector.norm(Norm.manhattan), equals(15.0));
    });

    test('should normalize itself (eucleadean norm)', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.normalize(Norm.euclidean);
      final expected = [0.134, 0.269, 0.404, 0.539, 0.674];
      expect(actual, vectorAlmostEqualTo(expected, 1e-3));
      expect(actual.norm(Norm.euclidean), closeTo(1.0, 1e-3));
    });

    test('should normalize itself (Manhattan norm)', () {
      final vector = Float32Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0]);
      final actual = vector.normalize(Norm.manhattan);
      final expected = [1 / 15, -2 / 15, 3 / 15, -4 / 15, 5 / 15];
      expect(actual, vectorAlmostEqualTo(expected, 1e-3));
      expect(actual.norm(Norm.manhattan), closeTo(1.0, 1e-3));
    });

    test('should rescale its every element into range [0...1]', () {
      final vector = Float32Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0, 0.0]);
      final actual = vector.rescale(); // min = -4, diff = 9
      final expected = [5 / 9, 2 / 9, 7 / 9, 0.0, 1.0, 4 / 9];
      expect(actual, vectorAlmostEqualTo(expected, 1e-3));
      expected.forEach((element) => expect(element, inInclusiveRange(0, 1)));
    });

    test('should find vector elements sum', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.sum(), equals(15.0));
    });

    test('should find vector elements absolute value', () {
      final vector = Float32Vector.fromList([-3.0, 4.5, -12.0, -23.5, 44.0]);
      final result = vector.abs();
      expect(result, equals([3.0, 4.5, 12.0, 23.5, 44.0]));
      expect(result, isNot(vector));
    });

    test('should create a vector using elements on specific inidces from '
        'given list', () {
      final vector = Float32Vector.fromList([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final query = vector.query([1, 1, 0, 3]);
      expect(query, equals([3.0, 3.0, 10.0, 7.0]));
      expect(() => vector.query([20, 0, 1]), throwsRangeError);
    });

    test('`unique` method', () {
      final vector = Float32Vector.fromList([
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

    test('`max` method, more than four elements', () {
      final vector = Float32Vector.fromList([10.0, 12.0, 4.0, 7.0, 9.0, 12.0]);
      expect(vector.max(), 12.0);
    });

    test('`max` method, four elements', () {
      final vector = Float32Vector.fromList([10.0, 11.0, -4.0, 0.0]);
      expect(vector.max(), 11.0);
    });

    test('`max` method, less than four elements', () {
      final vector = Float32Vector.fromList([7.0, -4.0, 0.0]);
      expect(vector.max(), 7.0);
    });

    test('`min` method, more than four elements', () {
      final vector = Float32Vector.fromList([10.0, 1.0, 4.0, 7.0, 9.0, 1.0]);
      expect(vector.min(), 1.0);
    });

    test('`min` method, four elements', () {
      final vector = Float32Vector.fromList([10.0, 0.0, 4.0, 7.0]);
      expect(vector.min(), 0.0);
    });

    test('`min` method, less than four elements', () {
      final vector = Float32Vector.fromList([10.0, 1.0, 4.0]);
      expect(vector.min(), 1.0);
    });

    test('should provide indexed access ([] operator, case 1)', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
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
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0]);
      expect(vector[0], 1.0);
      expect(vector[1], 2.0);
      expect(vector[2], 3.0);
      expect(vector[3], 4.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[4], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('should provide indexed access ([] operator, case 3)', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0]);
      expect(vector[0], 1.0);
      expect(vector[1], 2.0);
      expect(vector[2], 3.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[3], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('should provide indexed access ([] operator, case 4)', () {
      final vector = Float32Vector.fromList([1.0, 2.0]);
      expect(vector[0], 1.0);
      expect(vector[1], 2.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[2], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('should provide indexed access ([] operator, case 5)', () {
      final vector = Float32Vector.fromList([1.0]);
      expect(vector[0], 1.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[1], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });
  });

  group('Float32x4Vector.subvector', () {
    test('should cut out a subvector (`end` exclusive)', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.subvector(1, 4);
      final expected = [2.0, 3.0, 4.0];
      expect(actual, expected);
    });

    test('should cut out a subvector of length 1 if `start` is equal to the '
        'last index of the vector', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.subvector(4, 5);
      final expected = [5.0];
      expect(actual, expected);
    });

    test('should cut out rest of the vector if `end` is not specified', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 7.0]);
      final actual = vector.subvector(1);
      final expected = [2.0, 3.0, 4.0, 5.0, 7.0];
      expect(actual, expected);
    });

    test('should cut out rest of the vector if `end` is specified and greater'
        'that the vector length', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 7.0]);
      final actual = vector.subvector(1, 20);
      final expected = [2.0, 3.0, 4.0, 5.0, 7.0];
      expect(actual, expected);
    });

    test('should throw a range error if `start` is negative', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 7.0]);
      final actual = () => vector.subvector(-1, 20);
      expect(actual, throwsRangeError);
    });

    test('should throw a range error if `start` is greater than `end`', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 7.0]);
      final actual = () => vector.subvector(3, 2);
      expect(actual, throwsRangeError);
    });

    test('should throw a range error if `start` is equal to the `end`', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = () => vector.subvector(4, 4);
      expect(actual, throwsRangeError);
    });
  });

  group('Float32x4Vector.subvectorByRange', () {
    test('should return a proper vector using closed range', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.subvectorByRange(ZRange.closed(1, 3));
      expect(actual, equals([2.0, 3.0, 4.0]));
    });

    test('should return a proper vector using open range', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.subvectorByRange(ZRange.open(1, 3));
      expect(actual, equals([3.0]));
    });

    test('should return a proper vector using open-closed range', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.subvectorByRange(ZRange.openClosed(1, 3));
      expect(actual, equals([3.0, 4.0]));
    });

    test('should return a proper vector using closed-open range', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.subvectorByRange(ZRange.closedOpen(1, 3));
      expect(actual, equals([2.0, 3.0]));
    });

    test('should return a proper vector using upper boundless range', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.subvectorByRange(ZRange.atLeast(2));
      expect(actual, equals([3.0, 4.0, 5.0]));
    });

    test('should return a proper vector using lower boundless range', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.subvectorByRange(ZRange.atMost(2));
      expect(actual, equals([1.0, 2.0, 3.0]));
    });

    test('should return a copy of the vector using absolutely boundless '
        'range', () {
      final vector = Float32Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.subvectorByRange(ZRange.all());
      expect(actual, equals([1.0, 2.0, 3.0, 4.0, 5.0]));
    });
  });

  group('Float32x4Vector.hashCode', () {
    test('should return the same hashcode for equal vectors, case 1', () {
      final hash1 = Float32Vector.fromList([0, 0, 0, 0, 1]).hashCode;
      final hash2 = Float32Vector.fromList([0, 0, 0, 0, 1]).hashCode;
      expect(hash1, equals(hash2));
    });

    test('should return the same hashcode for equal vectors, case 2', () {
      final hash1 = Float32Vector.fromList([-10, double.infinity, 345, 20, 1])
          .hashCode;
      final hash2 = Float32Vector.fromList([-10, double.infinity, 345, 20, 1])
          .hashCode;
      expect(hash1, equals(hash2));
    });

    test('should return the same hashcode for equal vectors, case 3', () {
      final hash1 = Float32Vector.fromList([0, 0, 0, 0, 0]).hashCode;
      final hash2 = Float32Vector.fromList([0, 0, 0, 0, 0]).hashCode;
      expect(hash1, equals(hash2));
    });

    test('should return a different hashcode for unequal vectors, case 1', () {
      final hash1 = Float32Vector.fromList([0, 0, 0, 1, 0]).hashCode;
      final hash2 = Float32Vector.fromList([0, 0, 0, 0, 1]).hashCode;
      expect(hash1, isNot(equals(hash2)));
    });

    test('should return a different hashcode for unequal vectors, case 2', () {
      final hash1 = Float32Vector.fromList([0, 0, 0, 10, 0]).hashCode;
      final hash2 = Float32Vector.fromList([0, 0, 0, 1, 0, 0]).hashCode;
      expect(hash1, isNot(equals(hash2)));
    });

    test('should return a different hashcode for unequal vectors, case 3', () {
      final hash1 = Float32Vector.fromList([-32, 12, 0, 10, 0]).hashCode;
      final hash2 = Float32Vector.fromList([32, 12, 0, 10, 0]).hashCode;
      expect(hash1, isNot(equals(hash2)));
    });
  });
}
