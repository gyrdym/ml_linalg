import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void main() {
  final expected = [
    [4.0, 8.0, 12.0, 16.0, 20.0],
    [20.0, 24.0, 28.0, 32.0, 36.0],
    [36.0, .0, -8.0, -12.0, -28.0],
  ];

  group(dtypeToMatrixTestTitle[DType.float32], () {
    group('fastMap method', () {
      test('should map the matrix elements row-wise 4 elements a time', () {
        final matrix = createOriginalData(DType.float32);
        final actual = matrix
            .fastMap((Float32x4 element) => element.scale(4.0));

        expect(actual, equals(expected));
        expect(actual.rowsNum, 3);
        expect(actual.columnsNum, 5);
        expect(actual.dtype, DType.float32);
      });
    });
  });

  group(dtypeToMatrixTestTitle[DType.float64], () {
    group('fastMap method', () {
      test('should map the matrix elements row-wise 2 elements a time', () {
        final matrix = createOriginalData(DType.float64);
        final actual = matrix
            .fastMap((Float64x2 element) => element.scale(4.0));

        expect(actual, equals(expected));
        expect(actual.rowsNum, 3);
        expect(actual.columnsNum, 5);
        expect(actual.dtype, DType.float64);
      });
    });
  });
}

Matrix createOriginalData(DType dtype) =>
    Matrix.fromList([
      [1.0, 2.0, 3.0, 4.0, 5.0],
      [5.0, 6.0, 7.0, 8.0, 9.0],
      [9.0, .0, -2.0, -3.0, -7.0],
    ], dtype: dtype);
