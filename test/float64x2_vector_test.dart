import 'dart:typed_data';
import 'package:simd_vector/vector.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart';

void main() {
  group('Float64x2Vector constructors.', () {
    test('`from` constructor', () {
      //dynamic-length list
      Float64x2Vector vector1 = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(vector1.length, equals(6));

      //fixed-length list
      Float64x2Vector vector2 = new Float64x2Vector.from(new List.filled(11, 1.0));
      expect(vector2.length, 11);
    });

    test('`fromTypedList` constructor', () {
      Float64x2List typedList = new Float64x2List.fromList([
       new Float64x2(1.0, 2.0),
       new Float64x2(5.0, 6.0),
       new Float64x2(9.0, 10.0)
      ]);

      Float64x2Vector vector1 = new Float64x2Vector.fromSIMDList(typedList);

      expect(vector1.toList(), equals([1.0, 2.0, 5.0, 6.0, 9.0, 10.0]));
      expect(vector1.length, equals(6));

      Float64x2Vector vector2 = new Float64x2Vector.fromSIMDList(typedList, 5);

      expect(vector2.toList(), equals([1.0, 2.0, 5.0, 6.0, 9.0]));
      expect(vector2.length, equals(5));
    });

    test('`filled` constructor', () {
      Float64x2Vector vector = new Float64x2Vector.filled(10, 2.0);

      expect(vector.toList(), equals([2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]));
      expect(vector.length, equals(10));
    });
  });

  group('Float64x2Vector operations.', () {
    Float64x2Vector vector1;
    Float64x2Vector vector2;

    setUp(() {
      vector1 = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      vector2 = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
    });

    tearDown(() {
      vector1 = null;
      vector2 = null;
    });

    test('Addition', () {
      final result = vector1 + vector2;
      expect(result.toList(), equals([2.0, 4.0, 6.0, 8.0, 10.0]));
      expect(result.length, equals(5));

      final vector3 = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector3 + vector4, throwsRangeError);
    });

    test('Subtraction', () {
      final result = vector1 - vector2;
      expect(result.toList(), equals([0.0, 0.0, 0.0, 0.0, 0.0]));
      expect(result.length, equals(5));

      final vector3 = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector3 - vector4, throwsRangeError);
    });

    test('Multiplication', () {
      final result = vector1 * vector2;
      expect(result.toList(), equals([1.0, 4.0, 9.0, 16.0, 25.0]));
      expect(result.length, equals(5));

      final vector3 = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector3 * vector4, throwsRangeError);
    });

    test('Division', () {
      final result = vector1 / vector2;
      expect(result.toList(), equals([1.0, 1.0, 1.0, 1.0, 1.0]));
      expect(result.length, equals(5));

      final vector3 = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final vector4 = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(() => vector3 / vector4, throwsRangeError);
    });

    test('Power', () {
      final result = vector1.toIntegerPower(3);
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.toList(), equals([1.0, 8.0, 27.0, 64.0, 125.0]));
    });

    test('Dot product', () {
      final result = vector1.dot(vector2);
      expect(result, equals(55.0));
    });

    test('Scalar multiplication', () {
      final result = vector1.scalarMul(2.0);
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.toList(), equals([2.0, 4.0, 6.0, 8.0, 10.0]));
    });

    test('Scalar division', () {
      final result = vector1.scalarDiv(2.0);
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.toList(), equals([0.5, 1.0, 1.5, 2.0, 2.5]));
    });

    test('Scalar addition', () {
      final result = vector1.scalarAdd(13.0);
      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.toList(), equals([14.0, 15.0, 16.0, 17.0, 18.0]));
    });

    test('Scalar substruction', () {
      final vector = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      final result = vector.scalarSub(13.0);
      expect(result != vector, isTrue);
      expect(result.length, equals(5));
      expect(result.toList(), equals([-12.0, -11.0, -10.0, -9.0, -8.0]));
    });

    test('Euclidean distance (from vector to the same vector)', () {
      final vector = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0]);
      final distance = vector.distanceTo(vector);
      expect(distance, equals(0.0), reason: 'Wrong vector distance calculation');
    });

    test('Vector distance', () {
      final vector1 = new Float64x2Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final vector2 = new Float64x2Vector.from([1.0, 3.0, 2.0, 11.5, 10.0, 15.5]);
      expect(vector1.distanceTo(vector2, Norm.EUCLIDEAN), equals(10.88577052853862), reason: 'Wrong vector distance calculation');
      expect(vector1.distanceTo(vector2, Norm.MANHATTAN), equals(20.0), reason: 'Wrong vector distance calculation');
    });

    test('Vector norm', () {
      final vector = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.norm(Norm.EUCLIDEAN), equals(7.416198487095663), reason: 'Wrong norm calculation');
      expect(vector.norm(Norm.MANHATTAN), equals(15.0), reason: 'Wrong norm calculation');
    });

    test('Vector elements sum', () {
      final vector = new Float64x2Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      expect(vector.sum(), equals(15.0));
    });

    test('Vector elements absolute value', () {
      final vector = new Float64x2Vector.from([-3.0, 4.5, -12.0, -23.5, 44.0]);
      final result = vector.abs();
      expect(result.toList(), equals([3.0, 4.5, 12.0, 23.5, 44.0]));
      expect(result, isNot(vector));
    });

    test('`copy` method', () {
      final vector = new Float64x2Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final tmp = vector.copy();
      expect(tmp.toList(), equals([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]));
      expect(identical(tmp, vector), isFalse);
    });

    test('`query` method', () {
      final vector = new Float64x2Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      final query = vector.query([1, 1, 0, 3]);
      expect(query.toList(), equals([3.0, 3.0, 10.0, 7.0]));
      expect(() => vector.query([20, 0, 1]), throwsRangeError);
    });
  });

  test('`unique` method', () {
    final vector = new Float64x2Vector.from([10.0, 3.0, 4.0, 0.0, 7.0, 4.0, 12.0, 3.0, 12.0, 9.0, 0.0, 12.0, 10.0, 3.0]);
    final unique = vector.unique();
    expect(unique.toList(), equals([10.0, 3.0, 4.0, 0.0, 7.0, 12.0, 9.0]));
  });

  test('`max` method', () {
    final vector = new Float64x2Vector.from([10.0, 12.0, 4.0, 7.0, 9.0, 12.0]);
    expect(vector.max(), 12.0);
  });

  test('`min` method', () {
    final vector = new Float64x2Vector.from([10.0, 1.0, 4.0, 7.0, 9.0, 1.0]);
    expect(vector.min(), 1.0);
  });
}
