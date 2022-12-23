import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixAddOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('+ operator', () {
        test('should perform addition of a matrix', () {
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

          final actual = matrix1 + matrix2;
          final expected = [
            [11.0, 22.0, 33.0, 44.0],
            [0.0, 22.0, 9.0, 26.0],
            [11.0, -1.0, -4.0, -10.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 3);
          expect(actual.columnsNum, 4);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should perform addition of a matrix, all ones', () {
          final matrix1 = Matrix.fromList([
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
          ], dtype: dtype);

          final actual = matrix1 + matrix2;
          final expected = [
            [2.0, 2.0, 2.0, 2.0, 2.0],
            [2.0, 2.0, 2.0, 2.0, 2.0],
            [2.0, 2.0, 2.0, 2.0, 2.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 3);
          expect(actual.columnsNum, 5);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should perform addition of a matrix, all zeroes', () {
          final matrix1 = Matrix.fromList([
            [0.0, 0.0, 0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0, 0.0],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [0.0, 0.0, 0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0, 0.0],
          ], dtype: dtype);

          final actual = matrix1 + matrix2;
          final expected = [
            [0.0, 0.0, 0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0, 0.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 3);
          expect(actual.columnsNum, 5);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should perform addition of a matrix, 1x1 matrix', () {
          final matrix1 = Matrix.fromList([
            [53.0],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [111.0],
          ], dtype: dtype);

          final actual = matrix1 + matrix2;
          final expected = [
            [164.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 1);
          expect(actual.columnsNum, 1);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should perform addition of a matrix, 3x1 matrix', () {
          final matrix1 = Matrix.fromList([
            [53.0],
            [23.0],
            [11.0],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [53.0],
            [98.0],
            [17.0],
          ], dtype: dtype);

          final actual = matrix1 + matrix2;
          final expected = [
            [106.0],
            [121.0],
            [28.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 3);
          expect(actual.columnsNum, 1);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should perform addition of a matrix, negative values', () {
          final matrix1 = Matrix.fromList([
            [1.0, 1.0, 1.0, -21.0, 3.0],
            [1.0, 1.0, -5.0, 1.0, -10.0],
            [1.0, 10.0, 1.0, 1.0, 1.0],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [1.0, 1.0, 1.0, 1.0, 11.0],
            [1.0, 1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0, -11.0],
          ], dtype: dtype);

          final actual = matrix1 + matrix2;
          final expected = [
            [2.0, 2.0, 2.0, -20.0, 14.0],
            [2.0, 2.0, -4.0, 2.0, -9.0],
            [2.0, 11.0, 2.0, 2.0, -10.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 3);
          expect(actual.columnsNum, 5);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should throw an error if matrices are of different shape', () {
          final matrix1 = Matrix.fromList([
            [123.0, 234.3],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [111.0],
          ], dtype: dtype);

          final actual = () => matrix1 + matrix2;

          expect(actual, throwsException);
        });

        test('should perform addition of a scalar', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final actual = matrix + 7;

          final expected = [
            [8.0, 9.0, 10.0, 11.0],
            [12.0, 13.0, 14.0, 15.0],
            [16.0, 7.0, 5.0, 4.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 3);
          expect(actual.columnsNum, 4);
          expect(actual.dtype, dtype);
        });

        test('should perform addition of a scalar, scalar is 0', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final actual = matrix + 0;

          final expected = [
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 3);
          expect(actual.columnsNum, 4);
          expect(actual.dtype, dtype);
        });
      });
    });
