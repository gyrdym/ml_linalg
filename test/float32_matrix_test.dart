import 'dart:typed_data';

import 'package:ml_linalg/axis.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:ml_linalg/sort_direction.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

void main() {
  group('Matrix', () {
    test('should perform column-wise mapping of the matrix to a new one', () {
      final matrix = Matrix.fromList([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
      ]);
      final modifier = Vector.filled(3, 2.0);
      final actual = matrix.mapColumns((column) => column + modifier);
      final expected = [
        [13.0, 14.0, 15.0, 16.0],
        [17.0, 18.0, 19.0, 20.0],
        [23.0, 24.0, 25.0, 26.0],
      ];
      expect(actual, equals(expected));
    });

    test('should perform row-wise mapping of the matrix to a new one', () {
      final matrix = Matrix.fromList([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
      ]);
      final modifier = Vector.filled(4, 1.0);
      final actual = matrix.mapRows((row) => row - modifier);
      final expected = [
        [10.0, 11.0, 12.0, 13.0],
        [14.0, 15.0, 16.0, 17.0],
        [20.0, 21.0, 22.0, 23.0],
      ];
      expect(actual, equals(expected));
    });

    test('should perform multiplication by a vector', () {
      final matrix = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0]);
      final actual = matrix * vector;
      final expected = [
        [40],
        [96],
        [-5],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 3);
      expect(actual.columnsNum, 1);
    });

    test('should throw an error if one tries to multiple by a vector of '
        'unproper length', () {
      final matrix = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0, 7.0]);
      expect(() => matrix * vector, throwsException);
    });

    test('should perform multiplication of a matrix and another matrix', () {
      final matrix1 = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final matrix2 = Matrix.fromList([
        [1.0, 2.0],
        [5.0, 6.0],
        [9.0, .0],
        [-9.0, 1.0],
      ]);
      final actual = matrix1 * matrix2;
      final expected = [
        [2.0, 18.0],
        [26.0, 54.0],
        [18.0, 15.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 3);
      expect(actual.columnsNum, 2);
    });

    test('should throw an error if one tries to mult a matrix with another '
        'matrix of unproper dimensions', () {
      final matrix1 = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final matrix2 = Matrix.fromList([
        [1.0, 2.0],
        [5.0, 6.0],
        [9.0, .0],
      ]);
      expect(() => matrix1 * matrix2, throwsException);
    });

    test('should perform row-wise division by a vector', () {
      final matrix = Matrix.fromList([
        [4.0, 6.0, 20.0, 125.0],
        [10.0, 18.0, 28.0, 40.0],
        [18.0, .0, -12.0, -35.0],
      ]);
      final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0]);
      final actual = matrix / vector;
      final expected = [
        [2.0, 2.0, 5.0, 25.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -3.0, -7.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 3);
      expect(actual.columnsNum, 4);
    });

    test('should perform column-wise division by a vector', () {
      final matrix = Matrix.fromList([
        [4.0, 6.0, 20.0, 120.0],
        [9.0, 18.0, 27.0, 45.0],
        [14.0, .0, -21.0, -35.0],
      ]);
      final vector = Vector.fromList([2.0, 3.0, 7.0]);
      final actual = matrix / vector;
      final expected = [
        [2.0, 3.0, 10.0, 60.0],
        [3.0, 6.0, 9.0, 15.0],
        [2.0, .0, -3.0, -5.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 3);
      expect(actual.columnsNum, 4);
    });

    test('should throw an error if one tries to divide by a vector of '
        'unproper length', () {
      final matrix = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0, 7.0]);
      expect(() => matrix / vector, throwsException);
    });

    test('should perform division of a matrix by another matrix', () {
      final matrix1 = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final matrix2 = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, 1.0, -2.0, -3.0],
      ]);
      final actual = matrix1 / matrix2;
      final expected = [
        [1.0, 1.0, 1.0, 1.0],
        [1.0, 1.0, 1.0, 1.0],
        [1.0, .0, 1.0, 1.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 3);
      expect(actual.columnsNum, 4);
    });

    test('should throw an error if one tries to divide a matrix by another '
        'matrix of unproper dimensions', () {
      final matrix1 = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final matrix2 = Matrix.fromList([
        [1.0, 2.0],
        [5.0, 6.0],
        [9.0, .0],
      ]);
      expect(() => matrix1 / matrix2, throwsException);
    });

    test('should perform division of a matrix by a scalar', () {
      final matrix1 = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final scalar = 2.0;
      final actual = matrix1 / scalar;
      final expected = [
        [.5, 1.0, 1.5, 2.0],
        [2.5, 3.0, 3.5, 4.0],
        [4.5, .0, -1.0, -1.5],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 3);
      expect(actual.columnsNum, 4);
    });

    test('should find a frobenius norm', () {
      final matrix = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final norm = matrix.norm(MatrixNorm.frobenius);
      final expected = 17.2626;
      expect(norm, closeTo(expected, 0.6));
    });

    test('should transpose a matrix', () {
      final matrix = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final actual = matrix.transpose();
      final expected = [
        [1.0, 5.0, 9.0],
        [2.0, 6.0, .0],
        [3.0, 7.0, -2.0],
        [4.0, 8.0, -3.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 4);
      expect(actual.columnsNum, 3);
    });

    test('should transpose a 1xN matrix', () {
      final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0]);
      final matrix = Matrix.fromRows([vector]);
      final actual = matrix.transpose();
      final expected = [
        [1.0],
        [2.0],
        [3.0],
        [4.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 4);
      expect(actual.columnsNum, 1);
    });

    test('should transpose a Nx1 matrix', () {
      final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0]);
      final matrix = Matrix.fromColumns([vector]);
      final actual = matrix.transpose();
      final expected = [
        [1.0, 2.0, 3.0, 4.0],
      ];
      expect(actual, equals(expected));
      expect(actual.columnsNum, 4);
      expect(actual.rowsNum, 1);
    });

    test('should perform multiplication of a matrix and a scalar', () {
      final matrix = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final actual = matrix * 3;
      final expected = [
        [3.0, 6.0, 9.0, 12.0],
        [15.0, 18.0, 21.0, 24.0],
        [27.0, .0, -6.0, -9.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 3);
      expect(actual.columnsNum, 4);
    });

    test('should perform matricies subtraction', () {
      final matrix1 = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final matrix2 = Matrix.fromList([
        [10.0, 20.0, 30.0, 40.0],
        [-5.0, 16.0, 2.0, 18.0],
        [2.0, -1.0, -2.0, -7.0],
      ]);
      final actual = matrix1 - matrix2;
      final expected = [
        [-9.0, -18.0, -27.0, -36.0],
        [10.0, -10.0, 5.0, -10.0],
        [7.0, 1.0, .0, 4.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 3);
      expect(actual.columnsNum, 4);
    });

    test('should perform addition of a matrix', () {
      final matrix1 = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final matrix2 = Matrix.fromList([
        [10.0, 20.0, 30.0, 40.0],
        [-5.0, 16.0, 2.0, 18.0],
        [2.0, -1.0, -2.0, -7.0],
      ]);
      final actual = matrix1 + matrix2;
      final expected = [
        [11.0, 22.0, 33.0, 44.0],
        [0.0, 22.0, 9.0, 26.0],
        [11.0, -1.0, -4.0, -10.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 3);
      expect(actual.columnsNum, 4);
    });

    test('should perform addition of a scalar', () {
      final matrix = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final actual = matrix + 7;
      final expected = [
        [8.0, 9.0, 10.0, 11.0],
        [12.0, 13.0, 14.0, 15.0],
        [16.0, 7.0, 5.0, 4.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 3);
      expect(actual.columnsNum, 4);
    });

    test('should find its max value', () {
      final matrix = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);

      final actual = matrix.max();
      final expected = 9.0;
      expect(actual, equals(expected));
    });

    test('should find its min value', () {
      final matrix = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);

      final actual = matrix.min();
      final expected = -3.0;
      expect(actual, equals(expected));
    });

    test('should map row wise its elements to a new matrix', () {
      final matrix = Matrix.fromList([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final actual =
          matrix.fastMap((Float32x4 element) => element.scale(4.0));
      final expected = [
        [4.0, 8.0, 12.0, 16.0],
        [20.0, 24.0, 28.0, 32.0],
        [36.0, .0, -8.0, -12.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 3);
      expect(actual.columnsNum, 4);
    });

    test('should convert itself to a vector column', () {
      final matrix = Matrix.fromList([
        [1.0],
        [5.0],
        [9.0],
      ]);
      final column1 = matrix.toVector();
      final column2 = matrix.toVector();
      expect(column1 is Vector, isTrue);
      expect(column1, equals([1.0, 5.0, 9.0]));
      expect(identical(column1, column2), isTrue);
    });

    test('should convert itself to a vector row', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0],
      ]);
      final row1 = matrix.toVector();
      final row2 = matrix.toVector();
      expect(row1 is Vector, isTrue);
      expect(row1, equals([4.0, 8.0, 12.0, 16.0]));
      expect(identical(row1, row2), isTrue);
    });

    test('should throw an error if one tries to convert it into vector if its '
        'dimension is inappropriate', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0],
        [20.0, 24.0, 28.0, 32.0],
        [36.0, .0, -8.0, -12.0],
      ]);
      // ignore: unnecessary_lambdas
      expect(() => matrix.toVector(), throwsException);
    });

    test('should return rows', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0],
        [20.0, 24.0, 28.0, 32.0],
        [36.0, .0, -8.0, -12.0],
      ]);
      expect(matrix.rows, equals([
        [4.0, 8.0, 12.0, 16.0],
        [20.0, 24.0, 28.0, 32.0],
        [36.0, .0, -8.0, -12.0],
      ]));
    });

    test('should return columns', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0],
        [20.0, 24.0, 28.0, 32.0],
        [36.0, .0, -8.0, -12.0],
      ]);
      expect(matrix.columns, equals([
        [4.0, 20.0, 36.0],
        [8.0, 24.0, .0],
        [12.0, 28.0, -8.0],
        [16.0, 32.0, -12.0],
      ]));
    });
  });

  group('uniqueRows', () {
    test('should return the same row vectors as the matrix rows if all the '
        'rows are unique', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.uniqueRows();
      final expected = [
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ];
      expect(actual, equals(expected));
    });

    test('should return just unique rows', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [36.0, .0, -8.0, -12.0, 12.0],
      ]);
      final actual = matrix.uniqueRows();
      final expected = [
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
      ];
      expect(actual, equals(expected));
    });
  });

  group('insertColumn', () {
    test('should insert a new column by column index', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final newCol = Vector.fromList([100.0, 200.0, 300.0, 400.0, 500.0]);
      final newMatrix = matrix.insertColumns(1, [newCol]);

      expect(newMatrix.getColumn(1), equals(newCol));
      expect(newMatrix.getRow(0), equals([4.0, 100.0, 8.0, 12.0, 16.0, 34.0]));
      expect(newMatrix.getRow(4), equals([112.0, 500.0, 10.0, 34.0, 2.0, 10.0]));
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
      ]);
      final newCol = Vector.fromList([100.0, 200.0, 300.0, 400.0, 500.0]);
      final newMatrix = matrix.insertColumns(0, [newCol]);

      expect(newMatrix.getColumn(0), equals(newCol));
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
      ]);
      final newCol = Vector.fromList([100.0, 200.0, 300.0, 400.0, 500.0]);
      final newMatrix = matrix.insertColumns(4, [newCol]);

      expect(newMatrix.getColumn(4), equals(newCol));
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
      ]);
      final newCol = Vector.fromList([100.0, 200.0, 300.0, 400.0, 500.0]);
      final newMatrix = matrix.insertColumns(5, [newCol]);

      expect(newMatrix.getColumn(5), equals(newCol));
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
      ]);
      final newCols = [
        Vector.fromList([100.0, 200.0, 300.0, 400.0, 500.0]),
        Vector.fromList([-100.0, -200.0, -300.0, -400.0, -500.0]),
      ];
      final newMatrix = matrix.insertColumns(1, newCols);

      expect([
        newMatrix.getColumn(1),
        newMatrix.getColumn(2),
      ], equals(newCols));

      expect(newMatrix.getRow(0),
          equals([4.0, 100.0, -100.0, 8.0, 12.0, 16.0, 34.0]));
      expect(newMatrix.getRow(4),
          equals([112.0, 500.0, -500.0, 10.0, 34.0, 2.0, 10.0]));
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
      ]);
      final newCols = [
        Vector.fromList([100.0, 200.0, 300.0, 400.0, 500.0]),
        Vector.fromList([-100.0, -200.0, -300.0, -400.0, -500.0]),
      ];
      final newMatrix = matrix.insertColumns(0, newCols);

      expect([
        newMatrix.getColumn(0),
        newMatrix.getColumn(1),
      ], equals(newCols));

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
      ]);
      final newCol = Vector.fromList([100.0, 200.0, 300.0, 400.0, 500.0]);
      final newMatrix = matrix.insertColumns(4, [newCol]);

      expect(newMatrix.getColumn(4), equals(newCol));
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
      ]);
      final newCols = [
        Vector.fromList([100.0, 200.0, 300.0, 400.0, 500.0]),
        Vector.fromList([-100.0, -200.0, -300.0, -400.0, -500.0]),
      ];
      final newMatrix = matrix.insertColumns(5, newCols);

      expect([
        newMatrix.getColumn(5),
        newMatrix.getColumn(6),
      ], equals(newCols));

      expect(newMatrix, equals([
        [4.0, 8.0, 12.0, 16.0, 34.0, 100.0, -100.0],
        [20.0, 24.0, 28.0, 32.0, 23.0, 200.0, -200.0],
        [36.0, .0, -8.0, -12.0, 12.0, 300.0, -300.0],
        [16.0, 1.0, -18.0, 3.0, 11.0, 400.0, -400.0],
        [112.0, 10.0, 34.0, 2.0, 10.0, 500.0, -500.0],
      ]));
    });

    test('should throw an error if a new column has an invalid length', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final newCol = Vector.fromList([100.0, 200.0, 300.0, 400.0, 500.0, 1000.0]);
      expect(() => matrix.insertColumns(4, [newCol]), throwsRangeError);
    });

    test('should throw an error if the passed column index is greater than or '
        'equal to the total number of new columns', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final newCol = Vector.fromList([100.0, 200.0, 300.0, 400.0, 500.0]);

      expect(() => matrix.insertColumns(6, [newCol]), throwsRangeError);
    });
  });

  group('sample', () {
    test('should create a new matrix from its diffrent segments', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.sample(
        rowIndices: [0, 1, 3],
        columnIndices: [1, 3],
      );
      final expected = [
        [8.0, 16.0],
        [24.0, 32.0],
        [1.0, 3.0],
      ];
      expect(actual, equals(expected));
      expect(actual, isNot(same(matrix)));
    });

    test('should create a new matrix from its diffrent segments even if there '
        'are the same row indices in `rowIndices` parameter', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.sample(
        rowIndices: [0, 1, 0, 1],
        columnIndices: [1, 3],
      );
      final expected = [
        [8.0, 16.0],
        [24.0, 32.0],
        [8.0, 16.0],
        [24.0, 32.0],
      ];
      expect(actual, equals(expected));
      expect(actual, isNot(same(matrix)));
    });

    test('should create a new matrix from its diffrent segments even if there '
        'are the same column indices in `columIndices` parameter', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.sample(
        rowIndices: [0, 1, 3],
        columnIndices: [1, 1],
      );
      final expected = [
        [8.0, 8.0],
        [24.0, 24.0],
        [1.0, 1.0],
      ];
      expect(actual, equals(expected));
      expect(actual, isNot(same(matrix)));
    });

    test('should throw a range error if one of the column indices is out of '
        'bound)', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = () => matrix.sample(
            rowIndices: [1],
            columnIndices: [1, 2, 3, 4, 5],
          );
      expect(actual, throwsRangeError);
    });

    test('should create a new matrix from its diffrent segments (given row '
        'indices cover the whole rows range of the matrix)', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.sample(
        rowIndices: [0, 1, 2, 3, 4],
        columnIndices: [1, 2],
      );
      final expected = [
        [8.0, 12.0],
        [24.0, 28.0],
        [.0, -8.0],
        [1.0, -18.0],
        [10.0, 34.0],
      ];
      expect(actual, equals(expected));
      expect(actual, isNot(same(matrix)));
    });

    test('should create a new matrix from its diffrent segments (given column '
        'indices cover the whole columns range of the matrix)', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.sample(
        rowIndices: [0, 1],
        columnIndices: [0, 1, 2, 3, 4],
      );
      final expected = [
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
      ];
      expect(actual, equals(expected));
      expect(actual, isNot(same(matrix)));
    });

    test('should create a new matrix from its diffrent segments (columnIndices '
        'parameter is omitted)', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.sample(
        rowIndices: [0, 3],
      );
      final expected = [
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
      ];
      expect(actual, equals(expected));
      expect(actual, isNot(same(matrix)));
    });

    test('should create a new matrix from its diffrent segments (rowIndices '
        'parameter is omitted)', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.sample(
        columnIndices: [0, 3],
      );
      final expected = [
        [4.0, 16.0],
        [20.0, 32.0],
        [36.0, -12.0],
        [16.0, 3.0],
        [112.0, 2.0],
      ];
      expect(actual, equals(expected));
      expect(actual, isNot(same(matrix)));
    });

    test('should create a new matrix from its diffrent segments (both '
        'rowIndices and columnIndices parameters are omitted)', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.sample();
      final expected = [
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ];
      expect(actual, equals(expected));
      expect(actual, isNot(same(matrix)));
    });
  });

  group('sort', () {
    test('should sort the matrix row-wise with asc direction', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final expected = [
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ];
      final actual = matrix.sort((vector) => vector[2], Axis.rows,
          SortDirection.asc);
      expect(actual, equals(expected));
      expect(matrix, isNot(equals(expected)));
    });

    test('should sort the matrix column-wise with asc direction', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final expected = [
        [16.0, 12.0, 8.0, 34.0, 4.0],
        [32.0, 28.0, 24.0, 23.0, 20.0],
        [-12.0, -8.0, 0.0, 12.0, 36.0],
        [3.0, -18.0, 1.0, 11.0, 16.0],
        [2.0, 34.0, 10.0, 10.0, 112.0],
      ];
      final actual = matrix.sort((vector) => vector[2], Axis.columns,
          SortDirection.asc);
      expect(actual, equals(expected));
      expect(matrix, isNot(equals(expected)));
    });

    test('should sort the matrix row-wise with desc direction', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final expected = [
        [112.0, 10.0, 34.0, 2.0, 10.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
      ];
      final actual = matrix.sort((vector) => vector[2], Axis.rows,
          SortDirection.desc);
      expect(actual, equals(expected));
      expect(matrix, isNot(equals(expected)));
    });

    test('should sort the matrix column-wise with desc direction', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final expected = [
        [4.0, 34.0, 8.0, 12.0, 16.0],
        [20.0, 23.0, 24.0, 28.0, 32.0],
        [36.0, 12.0, 0.0, -8.0, -12.0],
        [16.0, 11.0, 1.0, -18.0, 3.0],
        [112.0, 10.0, 10.0, 34.0, 2.0],
      ];
      final actual = matrix.sort((vector) => vector[2], Axis.columns,
          SortDirection.desc);
      expect(actual, equals(expected));
      expect(matrix, isNot(equals(expected)));
    });
  });

  group('toString', () {
    test('should provide readable string representation', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.toString();
      final expected = 'Matrix 5 x 5:\n'
          '(4.0, 8.0, 12.0, 16.0, 34.0)\n'
          '(20.0, 24.0, 28.0, 32.0, 23.0)\n'
          '(36.0, 0.0, -8.0, -12.0, 12.0)\n'
          '(16.0, 1.0, -18.0, 3.0, 11.0)\n'
          '(112.0, 10.0, 34.0, 2.0, 10.0)\n';
      expect(actual, expected);
    });

    test('should provide readable string representation for Nx1 matrix, '
        'created from iterable', () {
      final matrix = Matrix.fromList([
        [4.0],
        [20.0],
        [36.0],
        [16.0],
        [112.0],
      ]);
      final actual = matrix.toString();
      final expected = 'Matrix 5 x 1:\n'
          '(4.0)\n'
          '(20.0)\n'
          '(36.0)\n'
          '(16.0)\n'
          '(112.0)\n';
      expect(actual, expected);
    });

    test('should provide readable string representation for Nx1 matrix, '
        'created from columns constructor', () {
      final vector = Vector.fromList([4.0, 20.0, 36.0, 16.0, 112.0]);
      final matrix = Matrix.fromColumns([vector]);
      final actual = matrix.toString();
      final expected = 'Matrix 5 x 1:\n'
          '(4.0)\n'
          '(20.0)\n'
          '(36.0)\n'
          '(16.0)\n'
          '(112.0)\n';
      expect(actual, expected);
    });

    test('should provide readable string representation for 1xN matrix, '
        'created from iterable', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0],
      ]);
      final actual = matrix.toString();
      final expected = 'Matrix 1 x 5:\n'
          '(4.0, 8.0, 12.0, 16.0, 34.0)\n';
      expect(actual, expected);
    });

    test('should provide readable string representation for 1xN matrix, '
        'created from rows constructor', () {
      final vector = Vector.fromList([4.0, 8.0, 12.0, 16.0, 34.0]);
      final matrix = Matrix.fromRows([vector]);
      final actual = matrix.toString();
      final expected = 'Matrix 1 x 5:\n'
          '(4.0, 8.0, 12.0, 16.0, 34.0)\n';
      expect(actual, expected);
    });

    test('should cut string representation of big matrices', () {
      final matrix = Matrix.fromList([
        [4.0, 8.0, 12.0, 16.0, 34.0, 21.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0, 12.0, 124.0],
        [36.0, .0, -8.0, -12.0, 12.0, 43.0, 78.0],
        [16.0, 1.0, -18.0, 3.0, 11.0, 21.0, 22.0],
        [112.0, 10.0, 34.0, 2.0, 10.0, 33.0, 66.0],
        [12.0, 1.0, 4.0, 2.0, 9.0, 39.0, 66.0],
        [11.0, 10.0, 34.0, 1.0, 10.0, 33.0, 16.0],
      ]);
      final actual = matrix.toString();
      final expected = 'Matrix 7 x 7:\n'
          '(4.0, 8.0, 12.0, 16.0, 34.0, ...)\n'
          '(20.0, 24.0, 28.0, 32.0, 23.0, ...)\n'
          '(36.0, 0.0, -8.0, -12.0, 12.0, ...)\n'
          '(16.0, 1.0, -18.0, 3.0, 11.0, ...)\n'
          '(112.0, 10.0, 34.0, 2.0, 10.0, ...)\n'
          '...';
      expect(actual, expected);
    });
  });

  group('rowIndices', () {
    test('should contain zero-based ordered iterable of row indices', () {
      final matrix = Matrix.fromList([
        [  1,   2,   3,   4],
        [ 10,  20,  30,  40],
        [100, 200, 300, 400],
      ]);

      expect(matrix.rowIndices, equals([0, 1, 2]));
    });

    test('should contain empty iterable if the matrix is empty', () {
      final matrix = Matrix.fromList([]);

      expect(matrix.rowIndices, isEmpty);
    });
  });

  group('columnIndices', () {
    test('should contain zero-based iterable of ordered column indices', () {
      final matrix = Matrix.fromList([
        [  1,   2,   3,   4],
        [ 10,  20,  30,  40],
        [100, 200, 300, 400],
      ]);

      expect(matrix.columnIndices, equals([0, 1, 2, 3]));
    });

    test('should contain empty iterable if the matrix is empty', () {
      final matrix = Matrix.fromList([]);

      expect(matrix.columnIndices, isEmpty);
    });
  });
}
