import 'package:ml_linalg/dtype.dart';
import 'package:test/test.dart';

import '../mutable_matrix_test_helpers.dart';

void main() {
  for (final dtype in [DType.float32, DType.float64]) {
    group(matrixTestTitle(dtype), () {
      test('should create an independent mutable copy', () {
        final original = matrixFromRows(
          [
            [1, 2, 3],
            [4, 5, 6],
          ],
          dtype,
        );
        final mutable = original.toMutable();

        expect(mutable.dtype, dtype);
        expect(mutable.rowCount, 2);
        expect(mutable.columnCount, 3);
        expectMatrixClose(mutable, [
          [1, 2, 3],
          [4, 5, 6],
        ]);

        mutable.asFlattenedList[0] = 99;

        expectMatrixClose(mutable, [
          [99, 2, 3],
          [4, 5, 6],
        ]);
        expectMatrixClose(original, [
          [1, 2, 3],
          [4, 5, 6],
        ]);
      });

      test(
        'should create an immutable snapshot independent from later changes',
        () {
          final mutable = matrixFromRows(
            [
              [1, 2],
              [3, 4],
            ],
            dtype,
          ).toMutable();
          final snapshot = mutable.toMatrix();

          mutable.scale(2);

          expectMatrixClose(snapshot, [
            [1, 2],
            [3, 4],
          ]);
          expectMatrixClose(mutable, [
            [2, 4],
            [6, 8],
          ]);
        },
      );

      test('should expose rows and flattened row-major values', () {
        final mutable = matrixFromRows(
          [
            [1, 2],
            [3, 4],
          ],
          dtype,
        ).toMutable();

        expect(mutable[0], equals([1, 2]));
        expect(mutable[1], equals([3, 4]));
        expect(mutable.asFlattenedList, equals([1, 2, 3, 4]));
      });

      test('should reject row indices outside the matrix bounds', () {
        final mutable = matrixFromRows(
          [
            [1, 2],
            [3, 4],
          ],
          dtype,
        ).toMutable();

        expect(() => mutable[-1], throwsRangeError);
        expect(() => mutable[2], throwsRangeError);
      });

      test('should remain unchanged when source storage changes', () {
        final original = matrixFromRows(
          [
            [1, 2],
            [3, 4],
          ],
          dtype,
        );
        final mutable = original.toMutable();

        original.asFlattenedList[0] = 99;

        expectMatrixClose(mutable, [
          [1, 2],
          [3, 4],
        ]);
      });
    });
  }
}
