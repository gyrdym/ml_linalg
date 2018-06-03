import 'dart:typed_data';
import 'package:simd_vector/vector.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart';

void main() {
  group('Float32x4Vector constructors.', () {
    test('`from` constructor', () {
      //from dynamic-length list
      Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(vector1, equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));
      expect(vector1.length, equals(6));

      vector1 = new Float32x4Vector.from([1.0, 2.0]);
      expect(vector1, equals([1.0, 2.0]));
      expect(vector1.length, equals(2));

      //from fixed-length list
      Float32x4Vector vector2 = new Float32x4Vector.from(new List.filled(11, 1.0));
      expect(vector2, equals([1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]));
      expect(vector2.length, 11);

      vector2 = new Float32x4Vector.from(new List.filled(1, 2.0));
      expect(vector2, equals([2.0]));
      expect(vector2.length, 1);
    });

    test('`fromSIMDList` constructor', () {
      final typedList = new Float32x4List.fromList([
        new Float32x4(1.0, 2.0, 3.0, 4.0),
        new Float32x4(5.0, 6.0, 7.0, 8.0),
        new Float32x4(9.0, 10.0, 0.0, 0.0)
      ]);

      Float32x4Vector vector = new Float32x4Vector.fromSIMDList(typedList);
      expect(vector, equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 0.0, 0.0]));
      expect(vector.length, equals(12));

      vector = new Float32x4Vector.fromSIMDList(typedList, 10);
      expect(vector, equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]));
      expect(vector.length, equals(10));
    });

    test('`filled` constructor', () {
      final vector = new Float32x4Vector.filled(10, 2.0);
      expect(vector, equals([2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]));
      expect(vector.length, equals(10));
    });

    test('`zero` constructor', () {
      Float32x4Vector vector = new Float32x4Vector.zero(10);

      expect(vector, equals([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]));
      expect(vector.length, equals(10));

      vector = new Float32x4Vector.zero(1);

      expect(vector, equals([0.0]));
      expect(vector.length, equals(1));

      vector = new Float32x4Vector.zero(2);

      expect(vector, equals([0.0, 0.0]));
      expect(vector.length, equals(2));
    });
  });

  group('Float32x4Vector operations.', () {
    Float32x4Vector vector1;
    Float32x4Vector vector2;

    setUp(() {
      vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      vector2 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
    });

    tearDown(() {
      vector1 = null;
      vector2 = null;
    });

    test('Addition', () {
      final result = vector1 + vector2;

      expect(result, equals([2.0, 4.0, 6.0, 8.0, 10.0]));
      expect(result.length, equals(5));

      final vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 + vector4, throwsRangeError);
    });

    test('Subtraction', () {
      final result = vector1 - vector2;

      expect(result, equals([0.0, 0.0, 0.0, 0.0, 0.0]));
      expect(result.length, equals(5));

      final vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 - vector4, throwsRangeError);
    });

    test('Multiplication', () {
      final result = vector1 * vector2;

      expect(result, equals([1.0, 4.0, 9.0, 16.0, 25.0]));
      expect(result.length, equals(5));

      final vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 * vector4, throwsRangeError);
    });

    test('Division', () {
      final result = vector1 / vector2;

      expect(result, equals([1.0, 1.0, 1.0, 1.0, 1.0]));
      expect(result.length, equals(5));

      final vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 / vector4, throwsRangeError);
    });

    test('Power', () {
      final result = vector1.toIntegerPower(3);

      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([1.0, 8.0, 27.0, 64.0, 125.0]));
    });

    test('Dot product', () {
      double result = vector1.dot(vector2);

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
      final vector = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final result = vector.scalarSub(13.0);

      expect(result != vector, isTrue);
      expect(result.length, equals(5));
      expect(result, equals([-12.0, -11.0, -10.0, -9.0, -8.0]));
    });

    test('Euclidean distance (from vector to the same vector)', () {
      final vector = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0]);
      final distance = vector.distanceTo(vector);

      expect(distance, equals(0.0), reason: 'Wrong vector distance calculation');
    });

    test('Vector distance', () {
      final vector1 = new Float32x4Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final vector2 = new Float32x4Vector.from([1.0, 3.0, 2.0, 11.5, 10.0, 15.5]);

      expect(vector1.distanceTo(vector2, Norm.EUCLIDEAN), equals(10.88577052853862), reason: 'Wrong vector distance calculation');
      expect(vector1.distanceTo(vector2, Norm.MANHATTAN), equals(20.0), reason: 'Wrong vector distance calculation');
    });

    test('Vector norm', () {
      final vector = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.norm(Norm.EUCLIDEAN), equals(7.416198487095663), reason: 'Wrong norm calculation');
      expect(vector.norm(Norm.MANHATTAN), equals(15.0), reason: 'Wrong norm calculation');
    });

    test('Vector elements sum', () {
      final vector = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.sum(), equals(15.0));
    });

    test('Vector elements absolute value', () {
      final vector = new Float32x4Vector.from([-3.0, 4.5, -12.0, -23.5, 44.0]);
      final result = vector.abs();

      expect(result, equals([3.0, 4.5, 12.0, 23.5, 44.0]));
      expect(result, isNot(vector));
    });

    test('`copy` method', () {
      final vector = new Float32x4Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final tmp = vector.copy();

      expect(tmp, equals([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]));
      expect(identical(tmp, vector), isFalse);
    });

    test('`query` method', () {
      final vector = new Float32x4Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final query = vector.query([1, 1, 0, 3]);

      expect(query, equals([3.0, 3.0, 10.0, 7.0]));
      expect(() => vector.query([20, 0, 1]), throwsRangeError);
    });

    test('`unique` method', () {
      final vector = new Float32x4Vector.from([10.0, 3.0, 4.0, 0.0, 7.0, 4.0, 12.0, 3.0, 12.0, 9.0, 0.0, 12.0, 10.0, 3.0]);
      final unique = vector.unique();
      expect(unique, equals([10.0, 3.0, 4.0, 0.0, 7.0, 12.0, 9.0]));
    });

    test('`max` method', () {
      final vector = new Float32x4Vector.from([10.0, 12.0, 4.0, 7.0, 9.0, 12.0]);
      expect(vector.max(), 12.0);
    });

    test('`min` method', () {
      final vector = new Float32x4Vector.from([10.0, 1.0, 4.0, 7.0, 9.0, 1.0]);
      expect(vector.min(), 1.0);
    });

    test('[] operator, case 1', () {
      final vector = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
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
      final vector = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0]);
      expect(vector[0], 1.0);
      expect(vector[1], 2.0);
      expect(vector[2], 3.0);
      expect(vector[3], 4.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[4], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('[] operator, case 3', () {
      final vector = new Float32x4Vector.from([1.0, 2.0, 3.0]);
      expect(vector[0], 1.0);
      expect(vector[1], 2.0);
      expect(vector[2], 3.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[3], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('[] operator, case 4', () {
      final vector = new Float32x4Vector.from([1.0, 2.0]);
      expect(vector[0], 1.0);
      expect(vector[1], 2.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[2], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('[] operator, case 5', () {
      final vector = new Float32x4Vector.from([1.0]);
      expect(vector[0], 1.0);
      expect(() => vector[-1], throwsRangeError);
      expect(() => vector[1], throwsRangeError);
      expect(() => vector[100], throwsRangeError);
    });

    test('`reversed` method', () {
      final vector1 = new Float32x4Vector.from([1.0]);
      final vector2 = new Float32x4Vector.from([1.0, 2.0]);
      final vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0]);
      final vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0]);
      final vector5 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector6 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      final vector7 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]);
      final vector8 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]);
      final vector9 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]);

      expect(vector1.reversed, equals([1.0]));
      expect(vector2.reversed, equals([2.0, 1.0]));
      expect(vector3.reversed, equals([3.0, 2.0, 1.0]));
      expect(vector4.reversed, equals([4.0, 3.0, 2.0, 1.0]));
      expect(vector5.reversed, equals([5.0, 4.0, 3.0, 2.0, 1.0]));
      expect(vector6.reversed, equals([6.0, 5.0, 4.0, 3.0, 2.0, 1.0]));
      expect(vector7.reversed, equals([7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0]));
      expect(vector8.reversed, equals([8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0]));
      expect(vector9.reversed, equals([9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0]));
    });
  });
}
