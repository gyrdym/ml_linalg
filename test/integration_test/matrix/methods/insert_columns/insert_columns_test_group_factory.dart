import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixInsertColumnsTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('insertColumns method', () {
        test('should insert a new column by column index', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final newCol = Vector.fromList(
              [100.0, 200.0, 300.0, 400.0, 500.0], dtype: dtype);
          final newMatrix = matrix.insertColumns(1, [newCol]);

          expect(matrix.dtype, dtype);
          expect(newMatrix.dtype, dtype);
          expect(newMatrix, equals([
            [4.0, 100.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 200.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, 300.0, .0, -8.0, -12.0, 12.0],
            [16.0, 400.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 500.0, 10.0, 34.0, 2.0, 10.0],
          ]));
        });

        test('should insert a new column at the very first index', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final newCol = Vector.fromList(
              [100.0, 200.0, 300.0, 400.0, 500.0], dtype: dtype);
          final newMatrix = matrix.insertColumns(0, [newCol]);

          expect(matrix.dtype, dtype);
          expect(newMatrix.dtype, dtype);
          expect(newMatrix, equals([
            [100.0, 4.0, 8.0, 12.0, 16.0, 34.0],
            [200.0, 20.0, 24.0, 28.0, 32.0, 23.0],
            [300.0, 36.0, .0, -8.0, -12.0, 12.0],
            [400.0, 16.0, 1.0, -18.0, 3.0, 11.0],
            [500.0, 112.0, 10.0, 34.0, 2.0, 10.0],
          ]));
        });

        test('should set a new column at penultimate index', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);
          final newCol = Vector.fromList([100.0, 200.0, 300.0, 400.0, 500.0],
              dtype: dtype);
          final newMatrix = matrix.insertColumns(4, [newCol]);

          expect(matrix.dtype, dtype);
          expect(newMatrix.dtype, dtype);
          expect(newMatrix, equals([
            [4.0, 8.0, 12.0, 16.0, 100.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 200.0, 23.0],
            [36.0, .0, -8.0, -12.0, 300.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 400.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 500.0, 10.0],
          ]));
        });

        test('should set a new column at very last index', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final newCol = Vector.fromList(
              [100.0, 200.0, 300.0, 400.0, 500.0], dtype: dtype);
          final newMatrix = matrix.insertColumns(5, [newCol]);

          expect(matrix.dtype, dtype);
          expect(newMatrix.dtype, dtype);
          expect(newMatrix, equals([
            [4.0, 8.0, 12.0, 16.0, 34.0, 100.0],
            [20.0, 24.0, 28.0, 32.0, 23.0, 200.0],
            [36.0, .0, -8.0, -12.0, 12.0, 300.0],
            [16.0, 1.0, -18.0, 3.0, 11.0, 400.0],
            [112.0, 10.0, 34.0, 2.0, 10.0, 500.0],
          ]));
        });

        test('should insert new columns by column index', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final newCols = [
            Vector.fromList(
                [100.0, 200.0, 300.0, 400.0, 500.0], dtype: dtype),
            Vector.fromList(
                [-100.0, -200.0, -300.0, -400.0, -500.0], dtype: dtype),
          ];
          final newMatrix = matrix.insertColumns(1, newCols);

          expect([
            newMatrix.getColumn(1),
            newMatrix.getColumn(2),
          ], equals(newCols));

          expect(matrix.dtype, dtype);
          expect(newMatrix.dtype, dtype);

          expect(newMatrix, equals([
            [4.0, 100.0, -100.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 200.0, -200.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, 300.0, -300.0, .0, -8.0, -12.0, 12.0],
            [16.0, 400.0, -400.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 500.0, -500.0, 10.0, 34.0, 2.0, 10.0],
          ]));
        });

        test('should insert new columns at the very first index', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);
          final newCols = [
            Vector.fromList(
                [100.0, 200.0, 300.0, 400.0, 500.0], dtype: dtype),
            Vector.fromList(
                [-100.0, -200.0, -300.0, -400.0, -500.0], dtype: dtype),
          ];

          final newMatrix = matrix.insertColumns(0, newCols);

          expect(matrix.dtype, dtype);
          expect(newMatrix.dtype, dtype);
          expect(newMatrix, equals([
            [100.0, -100.0, 4.0, 8.0, 12.0, 16.0, 34.0],
            [200.0, -200.0, 20.0, 24.0, 28.0, 32.0, 23.0],
            [300.0, -300.0, 36.0, .0, -8.0, -12.0, 12.0],
            [400.0, -400.0, 16.0, 1.0, -18.0, 3.0, 11.0],
            [500.0, -500.0, 112.0, 10.0, 34.0, 2.0, 10.0],
          ]));
        });

        test('should set new columns at penultimate index', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final newCol = Vector.fromList(
              [100.0, 200.0, 300.0, 400.0, 500.0], dtype: dtype);
          final newMatrix = matrix.insertColumns(4, [newCol]);

          expect(matrix.dtype, dtype);
          expect(newMatrix.dtype, dtype);
          expect(newMatrix, equals([
            [4.0, 8.0, 12.0, 16.0, 100.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 200.0, 23.0],
            [36.0, .0, -8.0, -12.0, 300.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 400.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 500.0, 10.0],
          ]));
        });

        test('should set new columns at very last index', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);
          final newCols = [
            Vector.fromList(
                [100.0, 200.0, 300.0, 400.0, 500.0], dtype: dtype),
            Vector.fromList(
                [-100.0, -200.0, -300.0, -400.0, -500.0], dtype: dtype),
          ];
          final newMatrix = matrix.insertColumns(5, newCols);

          expect(matrix.dtype, dtype);
          expect(newMatrix.dtype, dtype);
          expect(newMatrix, equals([
            [4.0, 8.0, 12.0, 16.0, 34.0, 100.0, -100.0],
            [20.0, 24.0, 28.0, 32.0, 23.0, 200.0, -200.0],
            [36.0, .0, -8.0, -12.0, 12.0, 300.0, -300.0],
            [16.0, 1.0, -18.0, 3.0, 11.0, 400.0, -400.0],
            [112.0, 10.0, 34.0, 2.0, 10.0, 500.0, -500.0],
          ]));
        });

        test('should throw an error if new column has invalid length', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final newCol = Vector.fromList(
              [100.0, 200.0, 300.0, 400.0, 500.0, 1000.0], dtype: dtype);

          expect(() => matrix.insertColumns(4, [newCol]), throwsException);
        });

        test('should throw an error if the passed column index is greater than or '
            'equal to the total number of new columns', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final newCol = Vector.fromList(
              [100.0, 200.0, 300.0, 400.0, 500.0], dtype: dtype);

          expect(() => matrix.insertColumns(6, [newCol]), throwsRangeError);
        });
      });
    });
