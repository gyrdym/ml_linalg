import 'dart:typed_data';

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

      test('should handle lengths around the SIMD width', () {
        final simdWidth = dtype == DType.float32 ? 4 : 2;
        final lengths = [1, simdWidth - 1, simdWidth, simdWidth + 1];

        for (final length in lengths.toSet()) {
          final values = List<double>.generate(
            length,
            (index) => index.toDouble() - 2.5,
          );
          final mutable =
              matrixFromFlattened(values, 1, length, dtype).toMutable();

          mutable.scale(-2);

          expectMatrixClose(
            mutable,
            [values.map((value) => value * -2).toList()],
          );
        }
      });

      test('should handle scaling by zero and one', () {
        final mutable = matrixFromRows(
          [
            [-3, 0.5],
            [4, -2],
          ],
          dtype,
        ).toMutable();

        expect(mutable.scale(1), same(mutable));
        expectMatrixClose(mutable, [
          [-3, 0.5],
          [4, -2],
        ]);

        mutable.scale(0);

        if (dtype == DType.float32) {
          expect(mutable.asFlattenedList, isA<Float32List>());
        } else {
          expect(mutable.asFlattenedList, isA<Float64List>());
        }
        expectMatrixClose(mutable, [
          [0, 0],
          [0, 0],
        ]);
      });

      test('should support matrices with zero elements', () {
        final mutable = matrixFromFlattened([], 2, 0, dtype).toMutable();

        expect(mutable.rowCount, 2);
        expect(mutable.columnCount, 0);
        expect(mutable.scale(3), same(mutable));
        expect(mutable.asFlattenedList, isEmpty);
      });

      test('should follow IEEE results for infinite and NaN factors', () {
        final mutable = matrixFromRows([
          [0, 1, -1]
        ], dtype)
            .toMutable();

        mutable.scale(double.infinity);

        expect(mutable[0].elementAt(0).isNaN, isTrue);
        expect(mutable[0].elementAt(1), double.infinity);
        expect(mutable[0].elementAt(2), double.negativeInfinity);

        mutable.scale(double.nan);

        expect(mutable.asFlattenedList.every((value) => value.isNaN), isTrue);
      });
    });
  }
}
