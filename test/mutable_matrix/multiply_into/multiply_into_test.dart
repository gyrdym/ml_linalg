import 'package:ml_linalg/dtype.dart';
import 'package:test/test.dart';

import '../mutable_matrix_test_helpers.dart';
import '../mutable_matrix_view.dart';

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

      test('should multiply two 1x1 matrices', () {
        final left = matrixFromRows([
          [-3.5]
        ], dtype)
            .toMutable();
        final right = matrixFromRows([
          [2]
        ], dtype);
        final destination = matrixFromRows([
          [0]
        ], dtype)
            .toMutable();

        left.multiplyInto(right, destination);

        expectMatrixClose(destination, [
          [-7]
        ]);
        expect(destination.toMatrix().sum(), -7);
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

      test('should support the right operand as the destination', () {
        final left = matrixFromRows(
          [
            [1, 2],
            [3, 4],
          ],
          dtype,
        ).toMutable();
        final destination = matrixFromRows(
          [
            [5, 6],
            [7, 8],
          ],
          dtype,
        ).toMutable();

        left.multiplyInto(destination, destination);

        expectMatrixClose(destination, [
          [19, 22],
          [43, 50],
        ]);
        expect(destination.toMatrix().sum(), 134);
      });

      test(
        'should support the same matrix as every operand',
        () {
          final matrix = matrixFromRows(
            [
              [1, 2],
              [3, 4],
            ],
            dtype,
          ).toMutable();

          matrix.multiplyInto(matrix, matrix);

          expectMatrixClose(matrix, [
            [7, 10],
            [15, 22],
          ]);
        },
      );

      test(
        'should handle a destination overlapping the left operand',
        () {
          final left = matrixFromRows(
            [
              [2, 3, 4],
              [5, 6, 7],
            ],
            dtype,
          ).toMutable();
          final destination = MutableMatrixView(
            typedPrefixView(left.asFlattenedList, 4),
            2,
            2,
            dtype,
          );
          final right = matrixFromRows(
            [
              [1, 2],
              [3, 4],
              [5, 6],
            ],
            dtype,
          );

          left.multiplyInto(right, destination);

          expectMatrixClose(destination, [
            [31, 40],
            [58, 76],
          ]);
        },
      );

      test(
        'should handle a destination overlapping the right operand',
        () {
          final left = matrixFromRows([
            [1, 2]
          ], dtype)
              .toMutable();
          final right = matrixFromRows(
            [
              [3, 4],
              [5, 6],
            ],
            dtype,
          ).toMutable();
          final destination = MutableMatrixView(
            typedPrefixView(right.asFlattenedList, 2),
            1,
            2,
            dtype,
          );

          left.multiplyInto(right, destination);

          expectMatrixClose(destination, [
            [13, 16]
          ]);
        },
      );

      test('should multiply matrices with a zero inner dimension', () {
        final left = matrixFromFlattened([], 2, 0, dtype).toMutable();
        final right = matrixFromFlattened([], 0, 3, dtype);
        final destination = matrixFromRows(
          [
            [-1, -1, -1],
            [-1, -1, -1],
          ],
          dtype,
        ).toMutable();

        left.multiplyInto(right, destination);

        expectMatrixClose(destination, [
          [0, 0, 0],
          [0, 0, 0],
        ]);
      });

      test('should multiply matrices with zero rows', () {
        final left = matrixFromFlattened([], 0, 2, dtype).toMutable();
        final right = matrixFromRows(
          [
            [1, 2, 3],
            [4, 5, 6],
          ],
          dtype,
        );
        final destination = matrixFromFlattened([], 0, 3, dtype).toMutable();

        left.multiplyInto(right, destination);

        expect(destination.rowCount, 0);
        expect(destination.columnCount, 3);
        expect(destination.asFlattenedList, isEmpty);
      });

      test(
        'should multiply matrices with inner dimensions around SIMD widths',
        () {
          final simdWidth = dtype == DType.float32 ? 4 : 2;
          final lengths = [1, simdWidth - 1, simdWidth, simdWidth + 1];

          for (final length in lengths.toSet()) {
            final values = List<double>.generate(
              length,
              (index) => index.toDouble() + 1,
            );
            final left =
                matrixFromFlattened(values, 1, length, dtype).toMutable();
            final right = matrixFromFlattened(
              List<double>.filled(length, 1),
              length,
              1,
              dtype,
            );
            final destination = matrixFromRows([
              [0]
            ], dtype)
                .toMutable();

            left.multiplyInto(right, destination);

            expect(destination[0].first, length * (length + 1) / 2);
          }
        },
      );

      test('should support operands and destination with different dtypes', () {
        final otherDtype =
            dtype == DType.float32 ? DType.float64 : DType.float32;
        final destinationDtype =
            dtype == DType.float32 ? DType.float64 : DType.float32;
        final left = matrixFromRows([
          [1.5, 2.5]
        ], dtype)
            .toMutable();
        final right = matrixFromRows([
          [2],
          [-1]
        ], otherDtype);
        final destination = matrixFromRows([
          [0]
        ], destinationDtype)
            .toMutable();

        left.multiplyInto(right, destination);

        expect(destination[0].first, closeTo(0.5, 1e-5));
      });

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
        expectMatrixClose(destination, [
          [0]
        ]);
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
        expectMatrixClose(destination, [
          [0, 0]
        ]);
      });

      test('should reject unsupported operands before writing', () {
        final left = matrixFromRows([
          [1]
        ], dtype)
            .toMutable();
        final destination = matrixFromRows([
          [0]
        ], dtype)
            .toMutable();

        expect(
          () => left.multiplyInto(Object(), destination),
          throwsArgumentError,
        );
        expectMatrixClose(destination, [
          [0]
        ]);
      });
    });
  }
}
