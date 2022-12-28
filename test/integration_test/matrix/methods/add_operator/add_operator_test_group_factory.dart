import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixAddOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('+ operator', () {
        test('should add a matrix', () {
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
          expect(actual.rowCount, 3);
          expect(actual.colCount, 4);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should add a matrix, fromFlattenedList constructor', () {
          final matrix1 = Matrix.fromFlattenedList([
            1.0,
            2.0,
            3.0,
            4.0,
            5.0,
            6.0,
            7.0,
            8.0,
            9.0,
            .0,
            -2.0,
            -3.0,
          ], 3, 4, dtype: dtype);

          final matrix2 = Matrix.fromFlattenedList([
            10.0,
            20.0,
            30.0,
            40.0,
            -5.0,
            16.0,
            2.0,
            18.0,
            2.0,
            -1.0,
            -2.0,
            -7.0,
          ], 3, 4, dtype: dtype);

          final actual = matrix1 + matrix2;
          final expected = [
            [11.0, 22.0, 33.0, 44.0],
            [0.0, 22.0, 9.0, 26.0],
            [11.0, -1.0, -4.0, -10.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 3);
          expect(actual.colCount, 4);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should add a matrix, all ones', () {
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
          expect(actual.rowCount, 3);
          expect(actual.colCount, 5);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should add a matrix, all zeroes', () {
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
          expect(actual.rowCount, 3);
          expect(actual.colCount, 5);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should add a matrix, 1x1 matrix', () {
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
          expect(actual.rowCount, 1);
          expect(actual.colCount, 1);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should add a matrix, 3x1 matrix', () {
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
          expect(actual.rowCount, 3);
          expect(actual.colCount, 1);
          expect(actual.dtype, dtype);
          expect(actual, isNot(same(matrix1)));
        });

        test('should add a matrix, negative values', () {
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
          expect(actual.rowCount, 3);
          expect(actual.colCount, 5);
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

        test('should add a scalar, matrix 3x4', () {
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
          expect(actual.rowCount, 3);
          expect(actual.colCount, 4);
          expect(actual.dtype, dtype);
        });

        test('should add a scalar, matrix 3x1', () {
          final matrix = Matrix.fromList([
            [1.0],
            [5.0],
            [9.0],
          ], dtype: dtype);

          final actual = matrix + 7;

          final expected = [
            [8.0],
            [12.0],
            [16.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 3);
          expect(actual.colCount, 1);
          expect(actual.dtype, dtype);
        });

        test('should add a scalar, matrix 5x1', () {
          final matrix = Matrix.fromList([
            [1.0],
            [5.0],
            [9.0],
            [13.0],
            [17.0],
          ], dtype: dtype);

          final actual = matrix + 7;

          final expected = [
            [8.0],
            [12.0],
            [16.0],
            [20.0],
            [24.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 5);
          expect(actual.colCount, 1);
          expect(actual.dtype, dtype);
        });

        test('should add a scalar, matrix 5x1, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([
            1.0,
            5.0,
            9.0,
            13.0,
            17.0,
          ], 5, 1, dtype: dtype);

          final actual = matrix + 7;

          final expected = [
            [8.0],
            [12.0],
            [16.0],
            [20.0],
            [24.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 5);
          expect(actual.colCount, 1);
          expect(actual.dtype, dtype);
        });

        test('should add a scalar, matrix 6x1', () {
          final matrix = Matrix.fromList([
            [1.0],
            [5.0],
            [9.0],
            [13.0],
            [17.0],
            [21.0],
          ], dtype: dtype);

          final actual = matrix + 7;

          final expected = [
            [8.0],
            [12.0],
            [16.0],
            [20.0],
            [24.0],
            [28.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 6);
          expect(actual.colCount, 1);
          expect(actual.dtype, dtype);
        });

        test('should add a scalar, matrix 7x1', () {
          final matrix = Matrix.fromList([
            [1.0],
            [5.0],
            [9.0],
            [13.0],
            [17.0],
            [21.0],
            [25.0],
          ], dtype: dtype);

          final actual = matrix + 7;

          final expected = [
            [8.0],
            [12.0],
            [16.0],
            [20.0],
            [24.0],
            [28.0],
            [32.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 7);
          expect(actual.colCount, 1);
          expect(actual.dtype, dtype);
        });

        test('should add a scalar, matrix 1x6', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
          ], dtype: dtype);

          final actual = matrix + 7;

          final expected = [
            [8.0, 9.0, 10.0, 11.0, 12.0, 13.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 1);
          expect(actual.colCount, 6);
          expect(actual.dtype, dtype);
        });

        test('should add a scalar, matrix 2x7', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0],
            [7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0],
          ], dtype: dtype);

          final actual = matrix + 10;

          final expected = [
            [11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0],
            [17.0, 16.0, 15.0, 14.0, 13.0, 12.0, 11.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 2);
          expect(actual.colCount, 7);
          expect(actual.dtype, dtype);
        });

        test('should add a scalar, matrix 2x9', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0],
            [7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0, 9.0, 8.0],
          ], dtype: dtype);

          final actual = matrix + 11;

          final expected = [
            [12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0],
            [18.0, 17.0, 16.0, 15.0, 14.0, 13.0, 12.0, 20.0, 19.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 2);
          expect(actual.colCount, 9);
          expect(actual.dtype, dtype);
        });

        test('should add a scalar, matrix 2x9, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([
            1.0,
            2.0,
            3.0,
            4.0,
            5.0,
            6.0,
            7.0,
            8.0,
            9.0,
            7.0,
            6.0,
            5.0,
            4.0,
            3.0,
            2.0,
            1.0,
            9.0,
            8.0,
          ], 2, 9, dtype: dtype);

          final actual = matrix + 11;

          final expected = [
            [12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0],
            [18.0, 17.0, 16.0, 15.0, 14.0, 13.0, 12.0, 20.0, 19.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 2);
          expect(actual.colCount, 9);
          expect(actual.dtype, dtype);
        });

        test(
            'should add a scalar, matrix 2x9, fromFlattenedList constructor, source list has more elements than needed',
            () {
          final matrix = Matrix.fromFlattenedList([
            1.0,
            2.0,
            3.0,
            4.0,
            5.0,
            6.0,
            7.0,
            8.0,
            9.0,
            7.0,
            6.0,
            5.0,
            4.0,
            3.0,
            2.0,
            1.0,
            9.0,
            8.0,
            10.0,
            11.0,
          ], 2, 9, dtype: dtype);

          final actual = matrix + 11;

          final expected = [
            [12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0],
            [18.0, 17.0, 16.0, 15.0, 14.0, 13.0, 12.0, 20.0, 19.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 2);
          expect(actual.colCount, 9);
          expect(actual.dtype, dtype);
        });

        test(
            'should add a scalar, matrix 2x9, fromFlattenedList constructor, source list has more elements than needed, case 2',
            () {
          final matrix = Matrix.fromFlattenedList([
            1.0,
            2.0,
            3.0,
            4.0,
            5.0,
            6.0,
            7.0,
            8.0,
            9.0,
            7.0,
            6.0,
            5.0,
            4.0,
            3.0,
            2.0,
            1.0,
            9.0,
            8.0,
            10.0,
            11.0,
            12.0,
          ], 2, 9, dtype: dtype);

          final actual = matrix + 11;

          final expected = [
            [12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0],
            [18.0, 17.0, 16.0, 15.0, 14.0, 13.0, 12.0, 20.0, 19.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 2);
          expect(actual.colCount, 9);
          expect(actual.dtype, dtype);
        });

        test('should add a scalar, scalar is 0', () {
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
          expect(actual.rowCount, 3);
          expect(actual.colCount, 4);
          expect(actual.dtype, dtype);
        });
      });
    });
