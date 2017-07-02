import 'dart:typed_data';
import 'package:dart_vector/vector.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart';

void main() {
  Float32x4Vector vector1;
  Float32x4Vector vector2;
  Float32x4Vector vector3;
  Float32x4Vector vector4;

  group('Vector fundamental:\n', () {
    tearDown(() {
      vector1 = null;
      vector2 = null;
    });

    test('Vector initialization via default constructor... ', () {
      vector1 = new Float32x4Vector(5);
      expect(vector1.asTypedList(), equals([0.0, 0.0, 0.0, 0.0, 0.0]));
      expect(vector1.length, equals(5));
    });

    test('Vector initialization via `from` constructor... ', () {
      //dynamic-length list
      vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
      expect(vector1.length, equals(6));

      //fixed-length list
      vector2 = new Float32x4Vector.from(new List.filled(11, 1.0));
      expect(vector2.length, 11);
    });

    test('Vector initialization via `fromTypedList` constructor... ', () {
      Float32x4List typedList = new Float32x4List.fromList([
        new Float32x4(1.0, 2.0, 3.0, 4.0),
        new Float32x4(5.0, 6.0, 7.0, 8.0),
        new Float32x4(9.0, 10.0, 0.0, 0.0)
      ]);

      vector1 = new Float32x4Vector.fromTypedList(typedList);
      expect(vector1.length, equals(12));

      vector1 = new Float32x4Vector.fromTypedList(typedList, 10);
      expect(vector1.asTypedList(), equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]));
      expect(vector1.length, equals(10));
    });

    test('Vector initialization via `fill` constructor... ', () {
      vector1 = new Float32x4Vector.filled(10, 2.0);

      expect(vector1.asTypedList(), equals([2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]));
      expect(vector1.length, equals(10));
    });
  });

  group('Vector operations:\n', () {
    setUp(() {
      vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      vector2 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
    });

    tearDown(() {
      vector1 = null;
      vector2 = null;
      vector3 = null;
      vector4 = null;
    });

    test('Vectors addition... ', () {
      Float32x4Vector result = vector1 + vector2;

      expect(result.asTypedList(), equals([2.0, 4.0, 6.0, 8.0, 10.0]));
      expect(result.length, equals(5));

      vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 + vector4, throwsRangeError);
    });

    test('Vectors subtraction... ', () {
      Float32x4Vector result = vector1 - vector2;

      expect(result.asTypedList(), equals([0.0, 0.0, 0.0, 0.0, 0.0]));
      expect(result.length, equals(5));

      vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 - vector4, throwsRangeError);
    });

    test('Vectors multiplication... ', () {
      Float32x4Vector result = vector1 * vector2;

      expect(result.asTypedList(), equals([1.0, 4.0, 9.0, 16.0, 25.0]));
      expect(result.length, equals(5));

      vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 * vector4, throwsRangeError);
    });

    test('Vectors division... ', () {
      Float32x4Vector result = vector1 / vector2;

      expect(result.asTypedList(), equals([1.0, 1.0, 1.0, 1.0, 1.0]));
      expect(result.length, equals(5));

      vector3 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
      vector4 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);

      expect(() => vector3 / vector4, throwsRangeError);
    });

    test('element-wise vector power... ', () {
      Float32x4Vector result = vector1.intPow(3);

      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.asTypedList(), equals([1.0, 8.0, 27.0, 64.0, 125.0]));
    });

    test('vector multiplication (scalar format)... ', () {
      double result = vector1.dot(vector2);

      expect(result, equals(55.0));
    });

    test('vector and scalar multiplication... ', () {
      Float32x4Vector result = vector1.scalarMul(2.0);

      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.asTypedList(), equals([2.0, 4.0, 6.0, 8.0, 10.0]));
    });

    test('vector and scalar division... ', () {
      Float32x4Vector result = vector1.scalarDiv(2.0);

      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.asTypedList(), equals([0.5, 1.0, 1.5, 2.0, 2.5]));
    });

    test('add a scalar to a vector... ', () {
      Float32x4Vector result = vector1.scalarAdd(13.0);

      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.asTypedList(), equals([14.0, 15.0, 16.0, 17.0, 18.0]));
    });

    test('subtract a scalar from a vector... ', () {
      Float32x4Vector result = vector1.scalarSub(13.0);

      expect(result != vector1, isTrue);
      expect(result.length, equals(5));
      expect(result.asTypedList(), equals([-12.0, -11.0, -10.0, -9.0, -8.0]));
    });

    test('find the euclidean distance between two identical vectors... ', () {
      double distance1 = vector1.distanceTo(vector2);

      expect(distance1, equals(0.0), reason: 'Wrong vector distance calculation');
    });

    test('find the distance between two different vectors... ', () {
      vector1 = new Float32x4Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      vector2 = new Float32x4Vector.from([1.0, 3.0, 2.0, 11.5, 10.0, 15.5]);

      expect(vector1.distanceTo(vector2, Norm.EUCLIDEAN), equals(10.88577052853862), reason: 'Wrong vector distance calculation');
      expect(vector1.distanceTo(vector2, Norm.MANHATTAN), equals(20.0), reason: 'Wrong vector distance calculation');
    });

    test('find a norm of a vector', () {
      expect(vector1.norm(Norm.EUCLIDEAN), equals(7.416198487095663), reason: 'Wrong norm calculation');
      expect(vector1.norm(Norm.MANHATTAN), equals(15.0), reason: 'Wrong norm calculation');
    });

    test('find the sum of vector elements... ', () {
      expect(vector1.sum(), equals(15.0));
    });

    test('find the absolute value of an each element of a vector... ', () {
      vector1 = new Float32x4Vector.from([-3.0, 4.5, -12.0, -23.5, 44.0]);
      Float32x4Vector result = vector1.abs();
      expect(result.asTypedList(), equals([3.0, 4.5, 12.0, 23.5, 44.0]));
      expect(result, isNot(vector1));
    });

    test('`copy` method testing... ', () {
      Float32x4Vector vector1 = new Float32x4Vector.from([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]);
      Float32x4Vector tmp = vector1.copy();
      expect(tmp.asTypedList(), equals([10.0, 3.0, 4.0, 7.0, 9.0, 12.0]));
      expect(tmp == vector1, isTrue);
      expect(identical(tmp, vector1), isFalse);
    });
  });
}
