import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixMultiplyTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('multiply method', () {
        test('should return Hadamard product', () {
          final matrix1 = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);
          final matrix2 = Matrix.fromList([
            [-11.0, 17.0,     1.0,   1.0],
            [523.0,  0.0,   -27.0,   9.0],
            [ 11.0,  9.0, 10001.0, -21.0],
          ], dtype: dtype);
          final actual = matrix1.multiply(matrix2);
          final expected = [
            [ -11, 34,      3,  4],
            [2615,  0,   -189, 72],
            [  99,  0, -20002, 63],
          ];

          expect(actual, expected);
          expect(actual.dtype, dtype);
        });

        test('should handle column matrices', () {
          final matrix1 = Matrix.column([-12, 20, 30, 2,  7], dtype: dtype);
          final matrix2 = Matrix.column([ -1,  3,  2, 9, 17], dtype: dtype);
          final actual = matrix1.multiply(matrix2);
          final expected = [[12], [60], [60], [18], [119]];

          expect(actual, expected);
          expect(actual.dtype, dtype);
        });

        test('should handle row matrices', () {
          final matrix1 = Matrix.row([-12, 20, 30, 2,  7], dtype: dtype);
          final matrix2 = Matrix.row([ -1,  3,  2, 9, 17], dtype: dtype);
          final actual = matrix1.multiply(matrix2);
          final expected = [[12, 60, 60, 18, 119]];

          expect(actual, expected);
          expect(actual.dtype, dtype);
        });

        test('should handle single element matrices', () {
          final matrix1 = Matrix.fromList([[-12.3]], dtype: dtype);
          final matrix2 = Matrix.fromList([[2]], dtype: dtype);
          final actual = matrix1.multiply(matrix2);
          final expected = [[closeTo(-24.6, 1e-3)]];

          expect(actual, expected);
          expect(actual.dtype, dtype);
        });

        test('should handle empty matrices', () {
          final matrix1 = Matrix.fromList([], dtype: dtype);
          final matrix2 = Matrix.fromList([], dtype: dtype);
          final actual = matrix1.multiply(matrix2);
          final expected = <double>[];

          expect(actual, expected);
          expect(actual.dtype, dtype);
        });

        test('should throw an exception if columns counts are different', () {
          final matrix1 = Matrix.fromList([[12, 21, 100]], dtype: dtype);
          final matrix2 = Matrix.fromList([[12, 33]], dtype: dtype);
          final actual = () => matrix1.multiply(matrix2);

          expect(actual, throwsException);
        });

        test('should throw an exception if rows counts are different', () {
          final matrix1 = Matrix.fromList([
            [12,  21, 100],
            [ 0, -21, 300],
          ], dtype: dtype);
          final matrix2 = Matrix.fromList([[12, 33, 300]], dtype: dtype);
          final actual = () => matrix1.multiply(matrix2);

          expect(actual, throwsException);
        });
      });
    });
