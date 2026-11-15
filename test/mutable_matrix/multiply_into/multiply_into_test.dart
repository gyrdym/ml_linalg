import 'package:ml_linalg/dtype.dart';
import 'package:test/test.dart';

import '../mutable_matrix_test_helpers.dart';

void main() {
  for (final dtype in [DType.float32, DType.float64]) {
    group(matrixTestTitle(dtype), () {
      test('should write a product into the supplied destination', () {
        final left = matrixFromRows(
          [
            [1, 2, 3, 4, 5],
            [2, 0, -1, 3, 1],
          ],
          dtype,
        ).toMutable();
        final right = matrixFromRows(
          [
            [1, 0],
            [0, 1],
            [1, 1],
            [0, 2],
            [-1, 1],
          ],
          dtype,
        );
        final destination = matrixFromRows(
          [
            [0, 0],
            [0, 0],
          ],
          dtype,
        ).toMutable();

        expect(left.multiplyInto(right, destination), same(destination));
        expectMatrixClose(destination, [
          [-1, 18],
          [0, 6],
        ]);
        expect(destination.toMatrix().sum(), 23);
        expectMatrixClose(left, [
          [1, 2, 3, 4, 5],
          [2, 0, -1, 3, 1],
        ]);
      });

      test(
        'should support a mutable right operand and an aliased destination',
        () {
          final matrix = matrixFromRows(
            [
              [1, 2],
              [3, 4],
            ],
            dtype,
          ).toMutable();
          final right = matrixFromRows(
            [
              [5, 6],
              [7, 8],
            ],
            dtype,
          ).toMutable();

          matrix.multiplyInto(right, matrix);

          expectMatrixClose(matrix, [
            [19, 22],
            [43, 50],
          ]);
        },
      );

      test('should throw when dimensions are incompatible', () {
        final left = matrixFromRows([
          [1, 2, 3]
        ], dtype)
            .toMutable();
        final right = matrixFromRows([
          [1, 2]
        ], dtype);
        final destination = matrixFromRows([
          [0]
        ], dtype)
            .toMutable();

        expect(
          () => left.multiplyInto(right, destination),
          throwsArgumentError,
        );
      });

      test('should throw when destination shape is incorrect', () {
        final left = matrixFromRows([
          [1, 2]
        ], dtype)
            .toMutable();
        final right = matrixFromRows([
          [1],
          [2]
        ], dtype);
        final destination = matrixFromRows([
          [0, 0]
        ], dtype)
            .toMutable();

        expect(
          () => left.multiplyInto(right, destination),
          throwsArgumentError,
        );
      });
    });
  }
}
