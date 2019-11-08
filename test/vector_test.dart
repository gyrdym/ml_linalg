import 'dart:typed_data';

import 'package:ml_linalg/src/vector/float32x4_vector.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

void main() {
  group('Vector', () {
    group('float32', () {
      test('should create vector instance via `fromList` constructor', () {
        expect(Vector.fromList([1, 2, 3]), isA<Float32x4Vector>());
        expect(Vector.fromList([1, 2, 3]), hasLength(3));
      });

      test('should create vector instance via `zero` constructor', () {
        expect(Vector.zero(5), isA<Float32x4Vector>());
        expect(Vector.zero(5), hasLength(5));
      });

      test('should create vector instance via `fromSimdList` constructor', () {
        expect(Vector.fromSimdList(
            Float32x4List.fromList([Float32x4.zero()]),
            3
        ), isA<Float32x4Vector>());
        expect(Vector.fromSimdList(
            Float32x4List.fromList([Float32x4.zero()]),
            3
        ), hasLength(3));
      });

      test('should create vector instance via `filled` constructor', () {
        expect(Vector.filled(7, 3), isA<Float32x4Vector>());
        expect(Vector.filled(7, 3), hasLength(7));
      });

      test('should create vector instance via `randomFilled` constructor', () {
        expect(Vector.randomFilled(11), isA<Float32x4Vector>());
        expect(Vector.randomFilled(11), hasLength(11));
      });
    });
  });
}
