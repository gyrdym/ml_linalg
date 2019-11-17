import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void main() {
  group(dtypeToVectorTestTitle[DType.float32], () {
    group('fromSimdList constructor', () {
      final typedList = Float32x4List.fromList([
        Float32x4(1.0, 2.0, 3.0, 4.0),
        Float32x4(5.0, 6.0, 7.0, 8.0),
        Float32x4(9.0, 10.0, 0.0, 0.0),
      ]);

      test('should create a vector with length equal to the length of the '
          'source', () {
        final vector = Vector.fromSimdList(typedList, 12, dtype: DType.float32);
        expect(
          vector.toList(),
          equals(
              [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 0.0, 0.0]),
        );
        expect(vector.length, equals(12));
        expect(vector.dtype, DType.float32);
      });

      test('should create a vector and limit its length if argument `length` '
          'is given', () {
        final vector = Vector.fromSimdList(typedList, 10, dtype: DType.float32);
        expect(vector,
            equals([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]));
        expect(vector.length, equals(10));
        expect(vector.dtype, DType.float32);
      });
    });
  });

  group(dtypeToVectorTestTitle[DType.float64], () {
    group('fromSimdList constructor', () {
      final typedList = Float64x2List.fromList([
        Float64x2(1.0, 2.0),
        Float64x2(5.0, 6.0),
        Float64x2(9.0, 10.0),
      ]);

      test('should create a vector with length equal to the length of the '
          'source', () {
        final vector = Vector.fromSimdList(typedList, 6, dtype: DType.float64);
        expect(vector.toList(), equals([1.0, 2.0, 5.0, 6.0, 9.0, 10.0]));
        expect(vector.length, equals(6));
        expect(vector.dtype, DType.float64);
      });

      test('should create a vector and limit its length if argument `length` '
          'is given', () {
        final vector = Vector.fromSimdList(typedList, 5, dtype: DType.float64);
        expect(vector, equals([1.0, 2.0, 5.0, 6.0, 9.0]));
        expect(vector.length, equals(5));
        expect(vector.dtype, DType.float64);
      });
    });
  });
}
