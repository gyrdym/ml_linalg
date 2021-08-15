import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixSumTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('sum method', () {
        test('should sum matrix elements', () {
          final result = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype)
              .sum();

          expect(result, equals(410));
        });

        test(
            'should sum matrix elements if there is only one element, '
            'positive number', () {
          final result = Matrix.fromList([
            [4.0],
          ], dtype: dtype)
              .sum();

          expect(result, equals(4));
        });

        test(
            'should sum matrix elements if there is only one element, '
            'negative number', () {
          final result = Matrix.fromList([
            [-1124.4],
          ], dtype: dtype)
              .sum();

          expect(result, closeTo(-1124.4, 1e-2));
        });

        test(
            'should return zero if the matrix consists of just one zero '
            'element', () {
          final result = Matrix.fromList([
            [0.0],
          ], dtype: dtype)
              .sum();

          expect(result, equals(0));
        });

        test('should return double.nan if the matrix is empty', () {
          final result = Matrix.fromList([], dtype: dtype).sum();

          expect(result, isNaN);
        });
      });
    });
