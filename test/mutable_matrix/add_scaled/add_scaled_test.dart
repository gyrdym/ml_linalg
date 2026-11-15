import 'package:ml_linalg/dtype.dart';
import 'package:test/test.dart';

import '../mutable_matrix_test_helpers.dart';

void main() {
  for (final dtype in [DType.float32, DType.float64]) {
    group(matrixTestTitle(dtype), () {
      test('should add a scaled matrix in place and preserve the original', () {
        final original = matrixFromRows(
          [
            [1, 2, 3],
            [4, 5, 6],
          ],
          dtype,
        );
        final other = matrixFromRows(
          [
            [2, -4, 6],
            [-8, 10, -12],
          ],
          dtype,
        );
        final mutable = original.toMutable();

        expect(mutable.addScaled(other, -0.5), same(mutable));
        expectMatrixClose(mutable, [
          [0, 4, 0],
          [8, 0, 12],
        ]);
        expect(mutable.toMatrix().sum(), 24);
        expectMatrixClose(original, [
          [1, 2, 3],
          [4, 5, 6],
        ]);
      });

      test('should accept a mutable matrix as the other operand', () {
        final mutable = matrixFromRows(
          [
            [1, 2],
            [3, 4],
          ],
          dtype,
        ).toMutable();
        final other = matrixFromRows(
          [
            [10, 20],
            [30, 40],
          ],
          dtype,
        ).toMutable();

        mutable.addScaled(other, 0.1);

        expectMatrixClose(mutable, [
          [2, 4],
          [6, 8],
        ]);
      });

      test('should throw when operand shapes differ', () {
        final mutable = matrixFromRows([
          [1, 2]
        ], dtype)
            .toMutable();
        final other = matrixFromRows([
          [1],
          [2]
        ], dtype);

        expect(() => mutable.addScaled(other, 1), throwsArgumentError);
      });
    });
  }
}
