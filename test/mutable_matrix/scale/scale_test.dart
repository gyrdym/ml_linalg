import 'package:ml_linalg/dtype.dart';
import 'package:test/test.dart';

import '../mutable_matrix_test_helpers.dart';

void main() {
  for (final dtype in [DType.float32, DType.float64]) {
    group(matrixTestTitle(dtype), () {
      test('should scale every element in place and return itself', () {
        final original = matrixFromRows(
          [
            [1, 2, 3],
            [4, 5, 6],
          ],
          dtype,
        );
        final mutable = original.toMutable();

        expect(mutable.scale(0.5), same(mutable));
        expectMatrixClose(mutable, [
          [0.5, 1, 1.5],
          [2, 2.5, 3],
        ]);
        expect(mutable.toMatrix().sum(), closeTo(10.5, 1e-5));
        expectMatrixClose(original, [
          [1, 2, 3],
          [4, 5, 6],
        ]);
      });

      test('should scale negative and fractional values', () {
        final mutable = matrixFromRows(
          [
            [-2.5, 1.5, -4],
            [6.25, -8.5, 0.5],
          ],
          dtype,
        ).toMutable();

        mutable.scale(-2);

        expectMatrixClose(mutable, [
          [5, -3, 8],
          [-12.5, 17, -1],
        ]);
      });
    });
  }
}
