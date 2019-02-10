import 'dart:typed_data';

import 'package:ml_linalg/range.dart';
import 'package:ml_linalg/src/matrix/float32x4/float32x4_matrix.dart';
import 'package:ml_linalg/src/vector/float32x4/float32x4_vector.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

void main() {
  group('Float32x4Matrix', () {
    test('should create an instance based on given list', () {
      final actual = Float32x4Matrix.from([
        [1.0, 2.0, 3.0, 4.0, 5.0],
        [6.0, 7.0, 8.0, 9.0, 0.0],
      ]);
      final expected = [
        [1.0, 2.0, 3.0, 4.0, 5.0],
        [6.0, 7.0, 8.0, 9.0, 0.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 2);
      expect(actual.columnsNum, 5);
    });

    test('should create an instance with predefined vectors as matrix rows', () {
      final actual = Float32x4Matrix.rows([
        Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]),
        Float32x4Vector.from([6.0, 7.0, 8.0, 9.0, 0.0]),
      ]);
      final expected = [
        [1.0, 2.0, 3.0, 4.0, 5.0],
        [6.0, 7.0, 8.0, 9.0, 0.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 2);
      expect(actual.columnsNum, 5);
    });

    test('should create an instance with predefined vectors as matrix columns', () {
      final actual = Float32x4Matrix.columns([
        Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]),
        Float32x4Vector.from([6.0, 7.0, 8.0, 9.0, 0.0]),
      ]);
      final expected = [
        [1.0, 6.0],
        [2.0, 7.0],
        [3.0, 8.0],
        [4.0, 9.0],
        [5.0, 0.0],
      ];
      expect(actual, equals(expected));
      expect(actual.rowsNum, 5);
      expect(actual.columnsNum, 2);
    });

    test('should create an instance from flattened collection', () {
      final actual = Float32x4Matrix.flattened([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], 2, 3);
      final expected = [
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
      ];
      expect(actual.rowsNum, 2);
      expect(actual.columnsNum, 3);
      expect(actual, equals(expected));
    });

    test('should throw an error if one tries to create a matrix from flattened collection and with unproper specified '
        'dimensions', () {
      expect(() => Float32x4Matrix.flattened([1.0, 2.0, 3.0, 4.0, 5.0], 2, 3), throwsException);
    });

    test('should provide indexed access to its elements', () {
      final matrix = Float32x4Matrix.from([
        [1.0, 2.0, 3.0],
        [6.0, 7.0, 8.0]
      ]);
      expect(matrix[0][0], 1.0);
      expect(matrix[0][1], 2.0);
      expect(matrix[0][2], 3.0);
      expect(matrix[1][0], 6.0);
      expect(matrix[1][1], 7.0);
      expect(matrix[1][2], 8.0);
    });

    test('should return required row as a vector', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
      ]);
      final row1 = matrix.getRow(0);
      final row2 = matrix.getRow(1);

      expect(row1 is MLVector, isTrue);
      expect(row1, [11.0, 12.0, 13.0, 14.0]);

      expect(row2 is MLVector, isTrue);
      expect(row2, [15.0, 16.0, 17.0, 18.0]);
    });

    test('should cache repeatedly retrieving row vector', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      // write value to the cache
      final row1 = matrix.getRow(1);
      final row2 = matrix.getRow(1);

      expect(identical(row1, row2), isTrue);
    });

    test('should ignore cache to get row vector if it is needed', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      // write value to the cache
      final row1 = matrix.getRow(1);
      final row2 = matrix.getRow(1, tryCache: false);

      expect(identical(row1, row2), isFalse);
      expect(row1, equals(row2));
    });

    test('should return required column as a vector', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
      ]);
      final column1 = matrix.getColumn(0);
      final column2 = matrix.getColumn(1);
      final column3 = matrix.getColumn(2);
      final column4 = matrix.getColumn(3);

      expect(column1 is MLVector, isTrue);
      expect(column1, [11.0, 15.0, 21.0]);

      expect(column2 is MLVector, isTrue);
      expect(column2, [12.0, 16.0, 22.0]);

      expect(column3 is MLVector, isTrue);
      expect(column3, [13.0, 17.0, 23.0]);

      expect(column4 is MLVector, isTrue);
      expect(column4, [14.0, 18.0, 24.0]);
    });

    test('should cache repeatedly retrieving column vector', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      // write value to the cache
      final column1 = matrix.getColumn(1);
      final column2 = matrix.getColumn(1);

      expect(identical(column1, column2), isTrue);
    });

    test('should ignore cache to get column vector if it is needed', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      // write value to the cache
      final column1 = matrix.getColumn(1);
      final column2 = matrix.getColumn(1, tryCache: false);

      expect(identical(column1, column2), isFalse);
      expect(column1, equals(column2));
    });

    test('should cut out a submatrix with respect to given intervals, rows and columns range ends are excluded', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
        [24.0, 32.0, 53.0, 74.0],
      ]);
      final submatrix = matrix.submatrix(rows: Range(1, 3), columns: Range(1, 2));
      final expected = [
        [16.0],
        [22.0],
      ];
      expect(submatrix, expected);
    });

    test('should cut out a submatrix with respect to given intervals, rows and columns range ends are included', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
        [24.0, 32.0, 53.0, 74.0],
      ]);
      final submatrix = matrix.submatrix(rows: Range(1, 3, endInclusive: true),
          columns: Range(1, 2, endInclusive: true));
      final expected = [
        [16.0, 17.0],
        [22.0, 23.0],
        [32.0, 53.0],
      ];
      expect(submatrix, expected);
    });

    test('should cut out a submatrix with respect to given intervals, just rows range end is included', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
        [24.0, 32.0, 53.0, 74.0],
      ]);
      final submatrix = matrix.submatrix(rows: Range(1, 3, endInclusive: true),
          columns: Range(1, 2, endInclusive: false));
      final expected = [
        [16.0],
        [22.0],
        [32.0],
      ];
      expect(submatrix, expected);
    });

    test('should cut out a submatrix with respect to given intervals, just columns range end is included', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
        [24.0, 32.0, 53.0, 74.0],
      ]);
      final submatrix = matrix.submatrix(rows: Range(1, 3, endInclusive: false),
          columns: Range(1, 2, endInclusive: true));
      final expected = [
        [16.0, 17.0],
        [22.0, 23.0],
      ];
      expect(submatrix, expected);
    });

    test('should cut out a submatrix with respect to given intervals, both rows and columns ranges are unspecified', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
        [24.0, 32.0, 53.0, 74.0],
      ]);
      final submatrix = matrix.submatrix();
      final expected = [
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
        [24.0, 32.0, 53.0, 74.0],
      ];
      expect(submatrix, expected);
    });

    test('should cut out a submatrix with respect to given intervals, rows range is unspecified', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
        [24.0, 32.0, 53.0, 74.0],
      ]);
      final submatrix = matrix.submatrix(columns: Range(0, 2));
      final expected = [
        [11.0, 12.0],
        [15.0, 16.0],
        [21.0, 22.0],
        [24.0, 32.0],
      ];
      expect(submatrix, expected);
    });

    test('should cut out a submatrix with respect to given intervals, columns range is unspecified', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
        [24.0, 32.0, 53.0, 74.0],
      ]);
      final submatrix = matrix.submatrix(rows: Range(0, 2));
      final expected = [
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
      ];
      expect(submatrix, expected);
    });

    test('should reduce all the matrix rows into a single vector, without initial reducer value', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
      ]);
      final actual = matrix.reduceRows((combine, vector) => combine + vector);
      final expected = [47, 50, 53, 56];
      expect(actual, equals(expected));
    });

    test('should reduce all the matrix rows into a single vector, with initial reducer value', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
      ]);
      final actual = matrix.reduceRows((combine, vector) => combine + vector,
          initValue: Float32x4Vector.from([2.0, 3.0, 4.0, 5.0]));
      final expected = [49, 53, 57, 61];
      expect(actual, equals(expected));
    });

    test('should reduce all the matrix columns into a single vector, without initial reducer value', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
      ]);
      final actual = matrix.reduceColumns((combine, vector) => combine + vector);
      final expected = [50, 66, 90];
      expect(actual, equals(expected));
    });

    test('should reduce all the matrix columns into a single vector, with initial reducer value', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
      ]);
      final actual = matrix.reduceColumns((combine, vector) => combine + vector,
          initValue: Float32x4Vector.from([2.0, 3.0, 4.0]));
      final expected = [52, 69, 94];
      expect(actual, equals(expected));
    });

    test('should perform multiplication by a vector', () {
      final matrix = Float32x4Matrix.from([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final vector = Float32x4Vector.from([2.0, 3.0, 4.0, 5.0]);
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

    test('should throw an error if one tries to multiple by a vector of unproper length', () {
      final matrix = Float32x4Matrix.from([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final vector = Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 7.0]);
      expect(() => matrix * vector, throwsException);
    });

    test('should perform multiplication of a matrix and another matrix', () {
      final matrix1 = Float32x4Matrix.from([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final matrix2 = Float32x4Matrix.from([
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

    test('should throw an error if one tries to mult a matrix with another matrix of unproper dimensions', () {
      final matrix1 = Float32x4Matrix.from([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final matrix2 = Float32x4Matrix.from([
        [1.0, 2.0],
        [5.0, 6.0],
        [9.0, .0],
      ]);
      expect(() => matrix1 * matrix2, throwsException);
    });

    test('should transpose a matrix', () {
      final matrix = Float32x4Matrix.from([
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
      final vector = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0]);
      final matrix = Float32x4Matrix.rows([vector]);
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
      final vector = Float32x4Vector.from([1.0, 2.0, 3.0, 4.0]);
      final matrix = Float32x4Matrix.columns([vector]);
      final actual = matrix.transpose();
      final expected = [
        [1.0, 2.0, 3.0, 4.0],
      ];
      expect(actual, equals(expected));
      expect(actual.columnsNum, 4);
      expect(actual.rowsNum, 1);
    });

    test('should perform multiplication of a matrix and a scalar', () {
      final matrix = Float32x4Matrix.from([
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
      final matrix1 = Float32x4Matrix.from([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final matrix2 = Float32x4Matrix.from([
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
      final matrix1 = Float32x4Matrix.from([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final matrix2 = Float32x4Matrix.from([
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
      final matrix = Float32x4Matrix.from([
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

    test('should map row wise its elements to a new matrix', () {
      final matrix = Float32x4Matrix.from([
        [1.0, 2.0, 3.0, 4.0],
        [5.0, 6.0, 7.0, 8.0],
        [9.0, .0, -2.0, -3.0],
      ]);
      final actual = matrix.fastMap<Float32x4>((Float32x4 element) => element.scale(4.0));
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
      final matrix = Float32x4Matrix.from([
        [1.0],
        [5.0],
        [9.0],
      ]);
      final column1 = matrix.toVector();
      final column2 = matrix.toVector();
      expect(column1 is MLVector, isTrue);
      expect(column1, equals([1.0, 5.0, 9.0]));
      expect(identical(column1, column2), isTrue);
    });

    test('should convert itself to a mutable vector column', () {
      final matrix = Float32x4Matrix.from([
        [1.0],
        [5.0],
        [9.0],
      ]);
      final column1 = matrix.toVector(mutable: true);
      final column2 = matrix.toVector(mutable: true);

      expect(column1 is MLVector, isTrue);
      expect(column1.isMutable, isTrue);
      expect(column1, equals([1.0, 5.0, 9.0]));
      expect(identical(column1, column2), isFalse);
      expect(column1, equals(column2));
    });

    test('should convert itself to a vector row', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0],
      ]);
      final row1 = matrix.toVector();
      final row2 = matrix.toVector();
      expect(row1 is MLVector, isTrue);
      expect(row1, equals([4.0, 8.0, 12.0, 16.0]));
      expect(identical(row1, row2), isTrue);
    });

    test('should convert itself to a mutable vector row', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0],
      ]);
      final row1 = matrix.toVector(mutable: true);
      final row2 = matrix.toVector(mutable: true);

      expect(row1 is MLVector, isTrue);
      expect(row1.isMutable, isTrue);
      expect(row1, equals([4.0, 8.0, 12.0, 16.0]));
      expect(identical(row1, row2), isFalse);
      expect(row1, equals(row2));
    });

    test('should throw an error if one tries to convert it into vector if its dimension is inappropriate', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0],
        [20.0, 24.0, 28.0, 32.0],
        [36.0, .0, -8.0, -12.0],
      ]);
      expect(() => matrix.toVector(), throwsException);
    });

    test('should create a new matrix from its diffrent segments', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.pick(
          rowRanges: [Range(0, 2), Range(3, 4)],
          columnRanges: [Range(1, 2), Range(3, 4)],
      );
      final expected = [
        [8.0, 16.0],
        [24.0, 32.0],
        [1.0, 3.0],
      ];
      expect(actual, equals(expected));
    });
  });

  group('Float32x4Matrix.pick()', () {
    test('should create a new matrix from its diffrent segments (same row ranges case)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.pick(
        rowRanges: [Range(0, 2), Range(0, 2)],
        columnRanges: [Range(1, 2), Range(3, 4)],
      );
      final expected = [
        [8.0, 16.0],
        [24.0, 32.0],
        [8.0, 16.0],
        [24.0, 32.0],
      ];
      expect(actual, equals(expected));
    });

    test('should create a new matrix from its diffrent segments (same coulmn ranges case)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.pick(
        rowRanges: [Range(0, 2), Range(3, 4)],
        columnRanges: [Range(1, 2), Range(1, 2)],
      );
      final expected = [
        [8.0, 8.0],
        [24.0, 24.0],
        [1.0, 1.0],
      ];
      expect(actual, equals(expected));
    });

    test('should create a new matrix from its diffrent segments (one row range, one column range)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.pick(
        rowRanges: [Range(0, 2)],
        columnRanges: [Range(1, 2)],
      );
      final expected = [
        [8.0],
        [24.0],
      ];
      expect(actual, equals(expected));
    });

    test('should create a new matrix from its diffrent segments (one of the row ranges is out of bound)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = () => matrix.pick(
        // take all 5 rows (20 > 5) and add second row to them (range from 1 to 2)
        rowRanges: [Range(0, 20), Range(1, 2)],
        columnRanges: [Range(1, 2)],
      );
      expect(actual, throwsRangeError, reason: '0, 20 - is not a correct range');
    });

    test('should create a new matrix from its diffrent segments (one of the column ranges is out of bound)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = () => matrix.pick(
        rowRanges: [Range(1, 2)],
        columnRanges: [Range(1, 6)],
      );
      expect(actual, throwsRangeError, reason: '1, 6 - is not a correct range');
    });

    test('should create a new matrix from its diffrent segments (given row range covers the whole rows range of the '
        'matrix)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.1],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.pick(
        rowRanges: [Range(0, 5)],
        columnRanges: [Range(1, 3)],
      );
      final expected = [
        [8.0, 12.0],
        [24.0, 28.0],
        [.0, -8.0],
        [1.0, -18.0],
        [10.0, 34.0],
      ];
      expect(actual, equals(expected));
    });

    test('should create a new matrix from its diffrent segments (given column range covers the whole columns range of '
        'the matrix)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.pick(
        rowRanges: [Range(0, 2)],
        columnRanges: [Range(0, 5)],
      );
      final expected = [
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
      ];
      expect(actual, equals(expected));
    });

    test('should create a new matrix from its diffrent segments (two or more row ranges cover the whole rows range of'
        'the matrix are given)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.pick(
        rowRanges: [Range(0, 5), Range(0, 5)],
        columnRanges: [Range(2, 3)],
      );
      final expected = [
        [12.0],
        [28.0],
        [-8.0],
        [-18.0],
        [34.0],
        [12.0],
        [28.0],
        [-8.0],
        [-18.0],
        [34.0],
      ];
      expect(actual, equals(expected));
    });

    test('should create a new matrix from its diffrent segments (two or more column ranges cover the whole columnss range '
        'of the matrix are given)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.pick(
        rowRanges: [Range(0, 1)],
        columnRanges: [Range(0, 5), Range(0, 5)],
      );
      final expected = [
        [4.0, 8.0, 12.0, 16.0, 34.0, 4.0, 8.0, 12.0, 16.0, 34.0],
      ];
      expect(actual, equals(expected));
    });

    test('should create a new matrix from its diffrent segments (columnRanges parameter is omitted)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.pick(
        rowRanges: [Range(0, 1), Range(3,4)],
      );
      final expected = [
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
      ];
      expect(actual, equals(expected));
    });

    test('should create a new matrix from its diffrent segments (rowRanges parameter is omitted)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.pick(
        columnRanges: [Range(0, 1), Range(3,4)],
      );
      final expected = [
        [4.0, 16.0],
        [20.0, 32.0],
        [36.0, -12.0],
        [16.0, 3.0],
        [112.0, 2.0],
      ];
      expect(actual, equals(expected));
    });

    test('should create a new matrix from its diffrent segments (both rowRanges and columnRanges parameters are '
        'omitted)', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ]);
      final actual = matrix.pick();
      final expected = [
        [4.0, 8.0, 12.0, 16.0, 34.0],
        [20.0, 24.0, 28.0, 32.0, 23.0],
        [36.0, .0, -8.0, -12.0, 12.0],
        [16.0, 1.0, -18.0, 3.0, 11.0],
        [112.0, 10.0, 34.0, 2.0, 10.0],
      ];
      expect(actual, equals(expected));
    });
  });

  group('Float32x4Matrix.toString()', () {
    test('should provide readable string representation', () {
      final matrix = Float32x4Matrix.from([
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

    test('should provide readable string representation for Nx1 matrix, created from iterable', () {
      final matrix = Float32x4Matrix.from([
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

    test('should provide readable string representation for Nx1 matrix, created from columns constructor', () {
      final vector = Float32x4Vector.from([4.0, 20.0, 36.0, 16.0, 112.0]);
      final matrix = Float32x4Matrix.columns([vector]);
      final actual = matrix.toString();
      final expected = 'Matrix 5 x 1:\n'
          '(4.0)\n'
          '(20.0)\n'
          '(36.0)\n'
          '(16.0)\n'
          '(112.0)\n';
      expect(actual, expected);
    });

    test('should provide readable string representation for 1xN matrix, created from iterable', () {
      final matrix = Float32x4Matrix.from([
        [4.0, 8.0, 12.0, 16.0, 34.0],
      ]);
      final actual = matrix.toString();
      final expected = 'Matrix 1 x 5:\n'
          '(4.0, 8.0, 12.0, 16.0, 34.0)\n';
      expect(actual, expected);
    });

    test('should provide readable string representation for 1xN matrix, created from rows constructor', () {
      final vector = Float32x4Vector.from([4.0, 8.0, 12.0, 16.0, 34.0]);
      final matrix = Float32x4Matrix.rows([vector]);
      final actual = matrix.toString();
      final expected = 'Matrix 1 x 5:\n'
          '(4.0, 8.0, 12.0, 16.0, 34.0)\n';
      expect(actual, expected);
    });

    test('should cut string representation of big matrices', () {
      final matrix = Float32x4Matrix.from([
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
}
