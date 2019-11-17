import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixMultiplicationOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('* operator', () {
        test('should perform multiplication of a matrix and a vector', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final actual = matrix * vector;

          final expected = [
            [40],
            [96],
            [-5],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 3);
          expect(actual.columnsNum, 1);
          expect(actual.dtype, dtype);
        });

        test('should throw an error if one tries to multiple a matrix by a '
            'vector of unproper length', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0, 7.0],
              dtype: dtype);

          expect(() => matrix * vector, throwsException);
        });

        test('should perform multiplication of a matrix and another matrix', () {
          final matrix1 = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [1.0, 2.0],
            [5.0, 6.0],
            [9.0, .0],
            [-9.0, 1.0],
          ], dtype: dtype);

          final actual = matrix1 * matrix2;

          final expected = [
            [2.0, 18.0],
            [26.0, 54.0],
            [18.0, 15.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 3);
          expect(actual.columnsNum, 2);
          expect(actual.dtype, dtype);
        });

        test('should throw an error if one tries to multiplicate a matrix with '
            'another matrix of unproper dimensions', () {
          final matrix1 = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [1.0, 2.0],
            [5.0, 6.0],
            [9.0, .0],
          ], dtype: dtype);

          expect(() => matrix1 * matrix2, throwsException);
        });

        test('should perform multiplication of a matrix and a scalar', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final actual = matrix * 3;

          final expected = [
            [3.0, 6.0, 9.0, 12.0],
            [15.0, 18.0, 21.0, 24.0],
            [27.0, .0, -6.0, -9.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 3);
          expect(actual.columnsNum, 4);
          expect(actual.dtype, dtype);
        });
      });
    });
