import 'dart:typed_data';

import 'package:linalg/src/simd/vector/float32/float32x4_vector.dart';
import 'package:linalg/vector.dart';
import 'package:matcher/matcher.dart';
import 'package:test/test.dart';

void main() {
  group('Float32x4Vector', () {
    group('`from` constructor', () {
      test('should create a vector from dynamic-length list, length is greater than 4', () {
        final vector1 = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
        expect(vector1.toList(), equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));
        expect(vector1.length, equals(6));
      });

      test('should create a vector from dynamic-length list, length is less than 4', () {
        final vector = Float32x4Vector.from([1.0, 2.0]);
        expect(vector.toList(), equals([1.0, 2.0]));
        expect(vector.length, equals(2));
      });

      test('should create a vector from fixed-length list, length is greater than 4', () {
        final vector = Float32x4Vector.from(List.filled(11, 1.0));
        expect(vector.toList(), equals([1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]));
        expect(vector.length, 11);
      });

      test('should create a vector from fixed-length list, length is less than 4', () {
        final vector = Float32x4Vector.from(List.filled(1, 2.0));
        expect(vector.toList(), equals([2.0]));
        expect(vector.length, 1);
      });
    });

    group('`fromSIMDList` constructor', () {
      final typedList = Float32x4List.fromList([
        Float32x4(1.0, 2.0, 3.0, 4.0),
        Float32x4(5.0, 6.0, 7.0, 8.0),
        Float32x4(9.0, 10.0, 0.0, 0.0)
      ]);

      test('should create a vector with length equal to the length of the source', () {
        final vector = Float32x4Vector.fromSIMDList(typedList);
        expect(vector.toList(), equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 0.0, 0.0]));
        expect(vector.length, equals(12));
      });

      test('should create a vector and limit its length if argument `length` is passed', () {
        final vector = Float32x4Vector.fromSIMDList(typedList, 10);
        expect(vector.toList(), equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]));
        expect(vector.length, equals(10));
      });
    });

    group('`filled` constructor', () {
      test('should create a vector filled with the passed value', () {
        final vector = Float32x4Vector.filled(10, 2.0);
        expect(vector.toList(), equals([2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]));
        expect(vector.length, equals(10));
      });
    });

    group('`zero` constructor', () {
      test('should fill a newly created vector with zeroes, case 1', () {
        final vector = Float32x4Vector.zero(10);
        expect(vector.toList(), equals([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]));
        expect(vector.length, equals(10));
      });

      test('should fill a newly created vector with zeroes, case 1', () {
        final vector = Float32x4Vector.zero(1);
        expect(vector.toList(), equals([0.0]));
        expect(vector.length, equals(1));
      });

      test('should fill a newly created vector with zeroes, case 1', () {
        final vector = Float32x4Vector.zero(2);
        expect(vector.toList(), equals([0.0, 0.0]));
        expect(vector.length, equals(2));
      });
    });
  });

  group('Float32x4Vector operations.', () {
    Float32x4Vector vector1;
    Float32x4Vector vector2;

    setUp(() {
      vector1 = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      vector2 = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
    });

    tearDown(() {
      vector1 = null;
      vector2 = null;
    });

    test('Addition', () {
      final result = vector1 + vector2;
      expect(result, equals([2.0, 4.0, 6.0, 8.0, 10.0]));
      expect(result.length, equals(5));

      final vector3 = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector3 + vector4, throwsRangeError);
    });

    test('Subtraction', () {
      final result = vector1 - vector2;
      expect(result, equals([0.0, 0.0, 0.0, 0.0, 0.0]));
      expect(result.length, equals(5));

      final vector3 = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector3 - vector4, throwsRangeError);
    });

    test('Multiplication', () {
      final result = vector1 * vector2;
      expect(result, equals([1.0, 4.0, 9.0, 16.0, 25.0]));
      expect(result.length, equals(5));

      final vector3 = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector3 * vector4, throwsRangeError);
    });

    test('Division', () {
      final result = vector1 / vector2;
      expect(result, equals([1.0, 1.0, 1.0, 1.0, 1.0]));
      expect(result.length, equals(5));

      final vector3 = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector3 / vector4, throwsRangeError);
    });

    test('Power', () {
      final result = vector1.toIntegerPower(3);
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([1.0, 8.0, 27.0, 64.0, 125.0]));
    });

    test('Dot product', () {
      final result = vector1.dot(vector2);
      expect(result, equals(55.0));
    });

    test('Scalar multiplication', () {
      final result = vector1.scalarMul(2.0);
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([2.0, 4.0, 6.0, 8.0, 10.0]));
    });

    test('Scalar division', () {
      final result = vector1.scalarDiv(2.0);
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([0.5, 1.0, 1.5, 2.0, 2.5]));
    });

    test('Scalar addition', () {
      final result = vector1.scalarAdd(13.0);
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([14.0, 15.0, 16.0, 17.0, 18.0]));
    });

    test('Scalar substruction', () {
      final vector = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final result = vector.scalarSub(13.0);
      expect(result != vector, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([-12.0, -11.0, -10.0, -9.0, -8.0]));
    });

    test('Euclidean distance (from vector to the same vector)', () {
      final vector = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0]);
      final distance = vector.distanceTo(vector);
      expect(distance, equals(0.0), reason: 'Wrong vector distance calculation');
    });

    test('Vector distance', () {
      final vector1 = Float32x4Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final vector2 = Float32x4Vector.from([1.0, 3.0, 2.0, 11.5, 10.0, 15.5]);
      expect(vector1.distanceTo(vector2, Norm.euclidean), equals(10.88577052853862), reason: 'Wrong vector distance calculation');
      expect(vector1.distanceTo(vector2, Norm.manhattan), equals(20.0), reason: 'Wrong vector distance calculation');
    });

    test('Vector norm', () {
      final vector = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.norm(Norm.euclidean), equals(7.416198487095663), reason: 'Wrong norm calculation');
      expect(vector.norm(Norm.manhattan), equals(15.0), reason: 'Wrong norm calculation');
    });

    test('Vector elements sum', () {
      final vector = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.sum(), equals(15.0));
    });

    test('Vector elements absolute value', () {
      final vector = Float32x4Vector.from([-3.0, 4.5, -12.0, -23.5, 44.0]);
      final result = vector.abs();
      expect(result, equals([3.0, 4.5, 12.0, 23.5, 44.0]));
      expect(result, isNot(vector));
    });

    test('`copy` method', () {
      final vector = Float32x4Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final tmp = vector.copy();
      expect(tmp, equals([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]));
      expect(identical(tmp, vector), isFalse);
    });

    test('`query` method', () {
      final vector = Float32x4Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final query = vector.query([1, 1, 0, 3]);
      expect(query, equals([3.0, 3.0, 10.0, 7.0]));
      expect(() => vector.query([20, 0, 1]), throwsRangeError);
    });

    test('`unique` method', () {
      final vector = Float32x4Vector.from([10.0, 3.0, 4.0, 0.0, 7.0, 4.0, 12.0, 3.0, 12.0, 9.0, 0.0, 12.0, 10.0, 3.0]);
      final unique = vector.unique();
      expect(unique, equals([10.0, 3.0, 4.0, 0.0, 7.0, 12.0, 9.0]));
    });

    test('`max` method, more than four elements', () {
      final vector = Float32x4Vector.from([10.0, 12.0, 4.0, 7.0, 9.0, 12.0]);
      expect(vector.max(), 12.0);
    });

    test('`max` method, four elements', () {
      final vector = Float32x4Vector.from([10.0, 11.0, -4.0, 0.0]);
      expect(vector.max(), 11.0);
    });

    test('`max` method, less than four elements', () {
      final vector = Float32x4Vector.from([7.0, -4.0, 0.0]);
      expect(vector.max(), 7.0);
    });

    test('`min` method, more than four elements', () {
      final vector = Float32x4Vector.from([10.0, 1.0, 4.0, 7.0, 9.0, 1.0]);
      expect(vector.min(), 1.0);
    });

    test('`min` method, four elements', () {
      final vector = Float32x4Vector.from([10.0, 0.0, 4.0, 7.0]);
      expect(vector.min(), 0.0);
    });

    test('`min` method, less than four elements', () {
      final vector = Float32x4Vector.from([10.0, 1.0, 4.0]);
      expect(vector.min(), 1.0);
    });

    test('[] operator, case 1', () {
      final vector = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector[0], 1.0);
      expect(vector[1], 2.0);
      expect(vector[2], 3.0);
      expect(vector[3], 4.0);
      expect(vector[4], 5.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[5], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('[] operator, case 2', () {
      final vector = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0]);
      expect(vector[0], 1.0);
      expect(vector[1], 2.0);
      expect(vector[2], 3.0);
      expect(vector[3], 4.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[4], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('[] operator, case 3', () {
      final vector = Float32x4Vector.from([1.0, 2.0, 3.0]);
      expect(vector[0], 1.0);
      expect(vector[1], 2.0);
      expect(vector[2], 3.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[3], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('[] operator, case 4', () {
      final vector = Float32x4Vector.from([1.0, 2.0]);
      expect(vector[0], 1.0);
      expect(vector[1], 2.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[2], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('[] operator, case 5', () {
      final vector = Float32x4Vector.from([1.0]);
      expect(vector[0], 1.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[1], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('`subVector` method', () {
      final vector = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final actual = vector.subVector(1, 5);
      final expected = [2.0, 3.0, 4.0, 5.0];
      expect(actual, expected);
    });
  });
}
