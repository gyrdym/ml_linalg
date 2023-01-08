import 'package:ml_linalg/axis.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';
import '../../../helpers.dart';

void matrixMeanTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('mean method', () {
        test('should calculate mean values column-wise for 3x6 matrix', () {
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

        test('should calculate mean values column-wise, 2x5 matrix', () {
          final matrix = Matrix.fromList([
            [10, 20, 30, 40, -10],
            [20, 40, 90, 40, -200],
          ], dtype: dtype);
          final means = matrix.mean(Axis.columns);

          expect(means, [15, 30, 60, 40, -105]);
          expect(means.dtype, dtype);
        });

        test('should calculate mean values column-wise for a 6x1 matrix', () {
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

        test('should calculate mean values column-wise for a 3x1 matrix', () {
          final matrix = Matrix.fromList([
            [10],
            [20],
            [30],
          ], dtype: dtype);
          final means = matrix.mean(Axis.columns);

          expect(means, equals([20]));
          expect(means.dtype, dtype);
        });

        test(
            'should calculate mean values column-wise for a 3x1 matrix, all zeroes',
            () {
          final matrix = Matrix.fromList([
            [0],
            [0],
            [0],
          ], dtype: dtype);
          final means = matrix.mean(Axis.columns);

          expect(means, equals([0]));
          expect(means.dtype, dtype);
        });

        test('should calculate mean values column-wise for a 1x1 matrix', () {
          final matrix = Matrix.fromList([
            [10],
          ], dtype: dtype);
          final means = matrix.mean(Axis.columns);

          expect(means, equals([10]));
          expect(means.dtype, dtype);
        });

        test(
            'should calculate mean values column-wise for a 1x1 matrix, 0 value',
            () {
          final matrix = Matrix.fromList([
            [0],
          ], dtype: dtype);
          final means = matrix.mean(Axis.columns);

          expect(means, equals([0]));
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

        test('should calculate mean values row-wise for 6x1 matrix', () {
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

        test('should calculate mean values row-wise for 5x1 matrix', () {
          final matrix = Matrix.fromList([
            [10],
            [20],
            [30],
            [40],
            [0],
          ], dtype: dtype);
          final means = matrix.mean(Axis.rows);

          expect(means, equals([10, 20, 30, 40, 0]));
          expect(means.dtype, dtype);
        });

        test('should calculate mean values row-wise for 3x1 matrix', () {
          final matrix = Matrix.fromList([
            [10],
            [20],
            [30],
          ], dtype: dtype);
          final means = matrix.mean(Axis.rows);

          expect(means, equals([10, 20, 30]));
          expect(means.dtype, dtype);
        });

        test('should calculate mean values row-wise for 1x1 matrix', () {
          final matrix = Matrix.fromList([
            [10],
          ], dtype: dtype);
          final means = matrix.mean(Axis.rows);

          expect(means, equals([10]));
          expect(means.dtype, dtype);
        });

        test('should calculate mean values row-wise for 1x1 matrix, zero value',
            () {
          final matrix = Matrix.fromList([
            [0],
          ], dtype: dtype);
          final means = matrix.mean(Axis.rows);

          expect(means, equals([0]));
          expect(means.dtype, dtype);
        });

        test('should calculate mean values row-wise for 1x6 matrix', () {
          final matrix = Matrix.fromList([
            [10, 20, 30, 40, 0, -10],
          ], dtype: dtype);
          final means = matrix.mean(Axis.rows);

          expect(means, equals([15]));
          expect(means.dtype, dtype);
        });

        test('should calculate mean values row-wise for 1x5 matrix', () {
          final matrix = Matrix.fromList([
            [10, 20, 30, 40, -10],
          ], dtype: dtype);
          final means = matrix.mean(Axis.rows);

          expect(means, equals([18]));
          expect(means.dtype, dtype);
        });

        test('should calculate mean values row-wise for 2x5 matrix', () {
          final matrix = Matrix.fromList([
            [10, 20, 30, 40, -10],
            [6, 7, 8, 9, 10],
          ], dtype: dtype);
          final means = matrix.mean(Axis.rows);

          expect(means, equals([18, 8]));
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
