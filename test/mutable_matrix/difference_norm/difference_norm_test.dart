import 'package:ml_linalg/dtype.dart';
import 'package:test/test.dart';

import '../mutable_matrix_test_helpers.dart';

void main() {
  for (final dtype in [DType.float32, DType.float64]) {
    group(matrixTestTitle(dtype), () {
      test(
        'should return the Frobenius norm without changing either matrix',
        () {
          final matrix = matrixFromRows(
            [
              [1, 2, 3],
              [4, 5, 6],
            ],
            dtype,
          ).toMutable();
          final other = matrixFromRows(
            [
              [4, 6, 3],
              [4, 5, 18],
            ],
            dtype,
          );

          expect(matrix.differenceNorm(other), 13);
          expectMatrixClose(matrix, [
            [1, 2, 3],
            [4, 5, 6],
          ]);
          expectMatrixClose(other, [
            [4, 6, 3],
            [4, 5, 18],
          ]);
        },
      );

      test('should propagate NaN values', () {
        final matrix = matrixFromRows([
          [double.nan, 2, 3, 4]
        ], dtype)
            .toMutable();
        final other = matrixFromRows([
          [0, 0, 0, 0]
        ], dtype);

        expect(matrix.differenceNorm(other).isNaN, isTrue);
      });

      test('should throw when operand shapes differ', () {
        final matrix = matrixFromRows([
          [1, 2]
        ], dtype)
            .toMutable();
        final other = matrixFromRows([
          [1],
          [2]
        ], dtype);

        expect(() => matrix.differenceNorm(other), throwsArgumentError);
      });
    });
  }
}
