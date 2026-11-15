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

      test('should return zero when comparing a matrix with itself', () {
        final matrix = matrixFromRows(
          [
            [-2, 0.5, 3],
            [4, -5, 6],
          ],
          dtype,
        ).toMutable();

        expect(matrix.differenceNorm(matrix), 0);
      });

      test('should support an operand with a different dtype', () {
        final otherDtype =
            dtype == DType.float32 ? DType.float64 : DType.float32;
        final matrix = matrixFromRows([
          [1, 2]
        ], dtype)
            .toMutable();
        final other = matrixFromRows([
          [4, 6]
        ], otherDtype);

        expect(matrix.differenceNorm(other), 5);
      });

      test('should propagate infinite and NaN differences', () {
        final infinite = matrixFromRows([
          [double.infinity]
        ], dtype)
            .toMutable();
        final finite = matrixFromRows([
          [0]
        ], dtype);
        final sameInfinity = matrixFromRows([
          [double.infinity]
        ], dtype);

        expect(infinite.differenceNorm(finite), double.infinity);
        expect(infinite.differenceNorm(sameInfinity).isNaN, isTrue);
      });

      test('should return zero for matrices with zero elements', () {
        final matrix = matrixFromFlattened([], 2, 0, dtype).toMutable();
        final other = matrixFromFlattened([], 2, 0, dtype);

        expect(matrix.differenceNorm(other), 0);
      });

      if (dtype == DType.float64) {
        test(
          'should preserve a finite norm when squaring would overflow',
          () {
            final matrix = matrixFromRows([
              [1e200]
            ], DType.float64)
                .toMutable();
            final zero = matrixFromRows([
              [0]
            ], DType.float64);

            expect(matrix.differenceNorm(zero), closeTo(1e200, 1e185));
          },
          skip: 'TODO: use a scaled sum-of-squares algorithm.',
        );
        test(
          'should preserve a nonzero norm when squaring would underflow',
          () {
            final matrix = matrixFromRows([
              [1e-200]
            ], DType.float64)
                .toMutable();
            final zero = matrixFromRows([
              [0]
            ], DType.float64);

            expect(matrix.differenceNorm(zero), closeTo(1e-200, 1e-215));
          },
          skip: 'TODO: use a scaled sum-of-squares algorithm.',
        );
      }
    });
  }
}
