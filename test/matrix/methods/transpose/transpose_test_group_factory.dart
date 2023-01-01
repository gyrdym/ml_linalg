import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixTransposeTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('transpose method', () {
        test('should transpose a matrix', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final actual = matrix.transpose();

          final expected = [
            [1.0, 5.0, 9.0],
            [2.0, 6.0, .0],
            [3.0, 7.0, -2.0],
            [4.0, 8.0, -3.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 4);
          expect(actual.columnCount, 3);
          expect(actual.dtype, dtype);
        });

        test('should transpose 3x5 matrix', () {
          final matrix = Matrix.fromList([
            [1, 2, 3, 4, 10],
            [5, 6, 7, 8, 11],
            [9, 0, -2, -3, 12],
          ], dtype: dtype);

          final actual = matrix.transpose();

          final expected = [
            [1, 5, 9],
            [2, 6, 0],
            [3, 7, -2],
            [4, 8, -3],
            [10, 11, 12],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 5);
          expect(actual.columnCount, 3);
          expect(actual.dtype, dtype);
        });

        test('should transpose 3x5 matrix, fromFlattenedList constructor', () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            10,
            5,
            6,
            7,
            8,
            11,
            9,
            0,
            -2,
            -3,
            12,
          ], 3, 5, dtype: dtype);

          final actual = matrix.transpose();

          final expected = [
            [1, 5, 9],
            [2, 6, 0],
            [3, 7, -2],
            [4, 8, -3],
            [10, 11, 12],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 5);
          expect(actual.columnCount, 3);
          expect(actual.dtype, dtype);
        });

        test(
            'should transpose 3x5 matrix, fromFlattenedList constructor, source list has more elements than needed',
            () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            10,
            5,
            6,
            7,
            8,
            11,
            9,
            0,
            -2,
            -3,
            12,
            13,
            14,
            15
          ], 3, 5, dtype: dtype);

          final actual = matrix.transpose();

          final expected = [
            [1, 5, 9],
            [2, 6, 0],
            [3, 7, -2],
            [4, 8, -3],
            [10, 11, 12],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 5);
          expect(actual.columnCount, 3);
          expect(actual.dtype, dtype);
        });

        test('should transpose 5x3 matrix', () {
          final matrix = Matrix.fromList([
            [1, 2, 3],
            [4, 10, 5],
            [6, 7, 8],
            [11, 9, 0],
            [-2, -3, 12],
          ], dtype: dtype);

          final actual = matrix.transpose();

          final expected = [
            [1, 4, 6, 11, -2],
            [2, 10, 7, 9, -3],
            [3, 5, 8, 0, 12],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 3);
          expect(actual.columnCount, 5);
          expect(actual.dtype, dtype);
        });

        test('should transpose a 1xN matrix', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0], dtype: dtype);
          final matrix = Matrix.fromRows([vector], dtype: dtype);

          final actual = matrix.transpose();

          final expected = [
            [1.0],
            [2.0],
            [3.0],
            [4.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 4);
          expect(actual.columnCount, 1);
          expect(actual.dtype, dtype);
        });

        test('should transpose a Nx1 matrix', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0], dtype: dtype);
          final matrix = Matrix.fromColumns([vector], dtype: dtype);

          final actual = matrix.transpose();
          final expected = [
            [1.0, 2.0, 3.0, 4.0],
          ];

          expect(actual, equals(expected));
          expect(actual.columnCount, 4);
          expect(actual.rowCount, 1);
          expect(actual.dtype, dtype);
        });
      });
    });
