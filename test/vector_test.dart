import 'dart:typed_data';
import 'package:dart_vector/vector.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart';

void main() {
  group('Float32x4Vector\n', () {
    test('Default constructor', () {
      Float32x4Vector vector = new Float32x4Vector(5);
      expect(vector.asList(), equals([0.0, 0.0, 0.0, 0.0, 0.0]));
      expect(vector.length, equals(5));
    });

    test('`from` constructor', () {
      //dynamic-length list
      Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(vector1.length, equals(6));

      //fixed-length list
      Float32x4Vector vector2 = new Float32x4Vector.from(new List.filled(11, 1.0));
      expect(vector2.length, 11);
    });

    test('`fromTypedList` constructor', () {
      Float32x4List typedList = new Float32x4List.fromList([
        new Float32x4(1.0, 2.0, 3.0, 4.0),
        new Float32x4(5.0, 6.0, 7.0, 8.0),
        new Float32x4(9.0, 10.0, 0.0, 0.0)
      ]);

      Float32x4Vector vector = new Float32x4Vector.fromTypedList(typedList);
      expect(vector.length, equals(12));

      vector = new Float32x4Vector.fromTypedList(typedList, 10);
      expect(vector.asList(), equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]));
      expect(vector.length, equals(10));
    });

    test('`filled` constructor', () {
      Float32x4Vector vector = new Float32x4Vector.filled(10, 2.0);

      expect(vector.asList(), equals([2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]));
      expect(vector.length, equals(10));
    });
  });

  group('Vector operations.', () {
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
      Float32x4Vector result = vector1 + vector2;

      expect(result.asList(), equals([2.0, 4.0, 6.0, 8.0, 10.0]));
      expect(result.length, equals(5));

      Float32x4Vector vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      Float32x4Vector vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 + vector4, throwsRangeError);
    });

    test('Subtraction', () {
      Float32x4Vector result = vector1 - vector2;

      expect(result.asList(), equals([0.0, 0.0, 0.0, 0.0, 0.0]));
      expect(result.length, equals(5));

      Float32x4Vector vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      Float32x4Vector vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 - vector4, throwsRangeError);
    });

    test('Multiplication', () {
      Float32x4Vector result = vector1 * vector2;

      expect(result.asList(), equals([1.0, 4.0, 9.0, 16.0, 25.0]));
      expect(result.length, equals(5));

      Float32x4Vector vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      Float32x4Vector vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 * vector4, throwsRangeError);
    });

    test('Division', () {
      Float32x4Vector result = vector1 / vector2;

      expect(result.asList(), equals([1.0, 1.0, 1.0, 1.0, 1.0]));
      expect(result.length, equals(5));

      Float32x4Vector vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      Float32x4Vector vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 / vector4, throwsRangeError);
    });

    test('Power', () {
      Float32x4Vector result = vector1.intPow(3);

      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.asList(), equals([1.0, 8.0, 27.0, 64.0, 125.0]));
    });

    test('Dot product', () {
      double result = vector1.dot(vector2);

      expect(result, equals(55.0));
    });

    test('Scalar multiplication', () {
      Float32x4Vector result = vector1.scalarMul(2.0);

      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.asList(), equals([2.0, 4.0, 6.0, 8.0, 10.0]));
    });

    test('Scalar division', () {
      Float32x4Vector result = vector1.scalarDiv(2.0);

      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.asList(), equals([0.5, 1.0, 1.5, 2.0, 2.5]));
    });

    test('Scalar addition', () {
      Float32x4Vector result = vector1.scalarAdd(13.0);

      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.asList(), equals([14.0, 15.0, 16.0, 17.0, 18.0]));
    });

    test('Scalar substruction', () {
      Float32x4Vector vector = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      Float32x4Vector result = vector.scalarSub(13.0);

      expect(result != vector, isTrue);
      expect(result.length, equals(5));
      expect(result.asList(), equals([-12.0, -11.0, -10.0, -9.0, -8.0]));
    });

    test('Euclidean distance (from vector to the same vector)', () {
      Float32x4Vector vector = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0]);
      double distance = vector.distanceTo(vector);

      expect(distance, equals(0.0), reason: 'Wrong vector distance calculation');
    });

    test('Vector distance', () {
      Float32x4Vector vector1 = new Float32x4Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      Float32x4Vector vector2 = new Float32x4Vector.from([1.0, 3.0, 2.0, 11.5, 10.0, 15.5]);

      expect(vector1.distanceTo(vector2, Norm.EUCLIDEAN), equals(10.88577052853862), reason: 'Wrong vector distance calculation');
      expect(vector1.distanceTo(vector2, Norm.MANHATTAN), equals(20.0), reason: 'Wrong vector distance calculation');
    });

    test('Vector norm', () {
      Float32x4Vector vector = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);

      expect(vector.norm(Norm.EUCLIDEAN), equals(7.416198487095663), reason: 'Wrong norm calculation');
      expect(vector.norm(Norm.MANHATTAN), equals(15.0), reason: 'Wrong norm calculation');
    });

    test('Vector elements sum', () {
      Float32x4Vector vector = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);

      expect(vector.sum(), equals(15.0));
    });

    test('Vector elements absolute value', () {
      Float32x4Vector vector = new Float32x4Vector.from([-3.0, 4.5, -12.0, -23.5, 44.0]);
      Float32x4Vector result = vector.abs();

      expect(result.asList(), equals([3.0, 4.5, 12.0, 23.5, 44.0]));
      expect(result, isNot(vector));
    });

    test('`copy` method', () {
      Float32x4Vector vector = new Float32x4Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      Float32x4Vector tmp = vector.copy();

      expect(tmp.asList(), equals([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]));
      expect(tmp == vector, isTrue);
      expect(identical(tmp, vector), isFalse);
    });
  });
}
