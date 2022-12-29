import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixSubtractionOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('- operator', () {
        test('should subtract matrix from another matrix', () {
          final matrix1 = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [10.0, 20.0, 30.0, 40.0],
            [-5.0, 16.0, 2.0, 18.0],
            [2.0, -1.0, -2.0, -7.0],
          ], dtype: dtype);

          final actual = matrix1 - matrix2;

          final expected = [
            [-9.0, -18.0, -27.0, -36.0],
            [10.0, -10.0, 5.0, -10.0],
            [7.0, 1.0, .0, 4.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 3);
          expect(actual.columnCount, 4);
          expect(actual.dtype, dtype);
        });

        test('should subtract 3x5 matrix from another 3x5 matrix', () {
          final matrix1 = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0, 10],
            [5.0, 6.0, 7.0, 8.0, 20],
            [9.0, .0, -2.0, -3.0, 30],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [10.0, 20.0, 30.0, 40.0, 3],
            [-5.0, 16.0, 2.0, 18.0, 4],
            [2.0, -1.0, -2.0, -7.0, 5],
          ], dtype: dtype);

          final actual = matrix1 - matrix2;

          final expected = [
            [-9.0, -18.0, -27.0, -36.0, 7],
            [10.0, -10.0, 5.0, -10.0, 16],
            [7.0, 1.0, .0, 4.0, 25],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 3);
          expect(actual.columnCount, 5);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should subtract 5x3 matrix from another 5x3 matrix', () {
          final matrix1 = Matrix.fromList([
            [1.0, 2.0, 3.0],
            [4.0, 10, 5.0],
            [6.0, 7.0, 8.0],
            [20, 9.0, .0],
            [-2.0, -3.0, 30],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [10.0, 20.0, 30.0],
            [40.0, 3, -5.0],
            [16.0, 2.0, 18.0],
            [4, 2.0, -1.0],
            [-2.0, -7.0, 5],
          ], dtype: dtype);

          final actual = matrix1 - matrix2;

          final expected = [
            [-9.0, -18.0, -27.0],
            [-36.0, 7, 10.0],
            [-10.0, 5.0, -10.0],
            [16, 7.0, 1.0],
            [.0, 4.0, 25],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 5);
          expect(actual.columnCount, 3);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should subtract a scalar from a 3x5 matrix', () {
          final matrix = Matrix.fromList([
            [1, 2, 3, 4, 5],
            [6, 7, 8, 9, 10],
            [11, 12, 13, 14, 15],
          ], dtype: dtype);
          final expected = [
            [-10, -9, -8, -7, -6],
            [-5, -4, -3, -2, -1],
            [0, 1, 2, 3, 4],
          ];
          final actual = matrix - 11;

          expect(actual, equals(expected));
          expect(actual.rowCount, 3);
          expect(actual.columnCount, 5);
          expect(actual.dtype, dtype);
        });

        test(
            'should subtract a scalar from a 3x5 matrix, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
          ], 3, 5, dtype: dtype);
          final expected = [
            [-10, -9, -8, -7, -6],
            [-5, -4, -3, -2, -1],
            [0, 1, 2, 3, 4],
          ];
          final actual = matrix - 11;

          expect(actual, equals(expected));
          expect(actual.rowCount, 3);
          expect(actual.columnCount, 5);
          expect(actual.dtype, dtype);
        });

        test('should subtract a scalar from a 5x1 matrix', () {
          final matrix = Matrix.fromList([
            [1],
            [2],
            [3],
            [4],
            [5],
          ], dtype: dtype);
          final expected = [
            [-10],
            [-9],
            [-8],
            [-7],
            [-6],
          ];
          final actual = matrix - 11;

          expect(actual, equals(expected));
          expect(actual.rowCount, 5);
          expect(actual.columnCount, 1);
          expect(actual.dtype, dtype);
        });

        test(
            'should subtract a scalar from a 5x1 matrix, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            5,
          ], 5, 1, dtype: dtype);
          final expected = [
            [-10],
            [-9],
            [-8],
            [-7],
            [-6],
          ];
          final actual = matrix - 11;

          expect(actual, equals(expected));
          expect(actual.rowCount, 5);
          expect(actual.columnCount, 1);
          expect(actual.dtype, dtype);
        });
      });
    });
