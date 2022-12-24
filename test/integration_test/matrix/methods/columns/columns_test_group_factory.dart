import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixColumnsTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('columns getter', () {
        test('should return matrix columns, matrix 3x4', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0],
            [20.0, 24.0, 28.0, 32.0],
            [36.0, .0, -8.0, -12.0],
          ], dtype: dtype);

          expect(
              matrix.columns,
              equals([
                [4.0, 20.0, 36.0],
                [8.0, 24.0, .0],
                [12.0, 28.0, -8.0],
                [16.0, 32.0, -12.0],
              ]));

          expect(matrix.dtype, dtype);
        });

        test('should return matrix columns, matrix 3x3', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0],
            [20.0, 24.0, 28.0],
            [36.0, .0, -8.0],
          ], dtype: dtype);

          expect(
              matrix.columns,
              equals([
                [4.0, 20.0, 36.0],
                [8.0, 24.0, .0],
                [12.0, 28.0, -8.0],
              ]));

          expect(matrix.dtype, dtype);
        });

        test('should return matrix columns, matrix 3x5', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 45.5],
            [20.0, 24.0, 28.0, 32.0, 22.5],
            [36.0, .0, -8.0, -12.0, 100],
          ], dtype: dtype);

          expect(
              matrix.columns,
              equals([
                [4.0, 20.0, 36.0],
                [8.0, 24.0, .0],
                [12.0, 28.0, -8.0],
                [16.0, 32.0, -12.0],
                [45.5, 22.5, 100.0],
              ]));

          expect(matrix.dtype, dtype);
        });

        test('should return matrix columns, matrix 1x5', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 45.5],
          ], dtype: dtype);

          expect(
              matrix.columns,
              equals([
                [4.0],
                [8.0],
                [12.0],
                [16.0],
                [45.5],
              ]));

          expect(matrix.dtype, dtype);
        });

        test('should return matrix columns, matrix 1x1', () {
          final matrix = Matrix.fromList([
            [4.0],
          ], dtype: dtype);

          expect(
              matrix.columns,
              equals([
                [4.0],
              ]));

          expect(matrix.dtype, dtype);
        });

        test('should return matrix columns, matrix 5x1', () {
          final matrix = Matrix.fromList([
            [4.0],
            [5.0],
            [6.0],
            [7.0],
            [8.0],
          ], dtype: dtype);

          expect(
              matrix.columns,
              equals([
                [4.0, 5.0, 6.0, 7.0, 8.0],
              ]));

          expect(matrix.dtype, dtype);
        });

        test('should return matrix columns, matrix 2x1', () {
          final matrix = Matrix.fromList([
            [4.0],
            [5.0],
          ], dtype: dtype);

          expect(
              matrix.columns,
              equals([
                [4.0, 5.0],
              ]));

          expect(matrix.dtype, dtype);
        });
      });
    });
