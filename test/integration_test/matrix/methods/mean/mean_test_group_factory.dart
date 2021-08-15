import 'package:ml_linalg/axis.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';
import '../../../../helpers.dart';

void matrixMeanTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('mean method', () {
        test('should calculate mean values column-wise', () {
          final matrix = Matrix.fromList([
            [10, 20, 30, 40, 0, -10],
            [20, 40, 90, 40, 0, -200],
            [30, 50, 10, 40, 0, 0],
          ], dtype: dtype);
          final means = matrix.mean(Axis.columns);

          expect(means,
              iterableAlmostEqualTo([20, 36.66, 43.33, 40, 0, -70], 1e-2));
          expect(means.dtype, dtype);
        });

        test(
            'should calculate mean values column-wise for a matrix with just one '
            'column', () {
          final matrix = Matrix.fromList([
            [10],
            [20],
            [30],
            [40],
            [0],
            [-10],
          ], dtype: dtype);
          final means = matrix.mean(Axis.columns);

          expect(means, equals([15]));
          expect(means.dtype, dtype);
        });

        test(
            'should calculate mean values column-wise for a matrix with just one '
            'row', () {
          final matrix = Matrix.fromList([
            [10, 20, 30, 40, 0, -10],
          ], dtype: dtype);
          final means = matrix.mean(Axis.columns);

          expect(means, equals([10, 20, 30, 40, 0, -10]));
          expect(means.dtype, dtype);
        });

        test('should calculate mean values column-wise for an empty matrix',
            () {
          final matrix = Matrix.empty(dtype: dtype);
          final means = matrix.mean(Axis.columns);

          expect(means, isEmpty);
          expect(means.dtype, dtype);
        });

        test('should calculate mean values row-wise', () {
          final matrix = Matrix.fromList([
            [0, 0, 0, 0],
            [10, 30, 40, 50],
            [-10, -20, 20, 40],
            [1, 1, 1, 1],
          ], dtype: dtype);
          final means = matrix.mean(Axis.rows);

          expect(means, iterableAlmostEqualTo([0, 32.5, 7.5, 1], 1e-3));
          expect(means.dtype, dtype);
        });

        test(
            'should calculate mean values row-wise for a matrix with just one '
            'column', () {
          final matrix = Matrix.fromList([
            [10],
            [20],
            [30],
            [40],
            [0],
            [-10],
          ], dtype: dtype);
          final means = matrix.mean(Axis.rows);

          expect(means, equals([10, 20, 30, 40, 0, -10]));
          expect(means.dtype, dtype);
        });

        test(
            'should calculate mean values row-wise for a matrix with just one '
            'row', () {
          final matrix = Matrix.fromList([
            [10, 20, 30, 40, 0, -10],
          ], dtype: dtype);
          final means = matrix.mean(Axis.rows);

          expect(means, equals([15]));
          expect(means.dtype, dtype);
        });

        test('should calculate mean values row-wise for an empty matrix', () {
          final matrix = Matrix.empty(dtype: dtype);
          final means = matrix.mean(Axis.rows);

          expect(means, isEmpty);
          expect(means.dtype, dtype);
        });
      });
    });
