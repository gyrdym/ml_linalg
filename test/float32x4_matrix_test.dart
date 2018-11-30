import 'package:linalg/src/matrix/float32x4_matrix.dart';
import 'package:linalg/src/matrix/range.dart';
import 'package:linalg/src/vector/float32x4_vector.dart';
import 'package:linalg/src/vector/vector.dart';
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
      final column1 = matrix.getRowVector(0);
      final column2 = matrix.getRowVector(1);

      expect(column1 is Vector, isTrue);
      expect(column1, [11.0, 12.0, 13.0, 14.0]);

      expect(column2 is Vector, isTrue);
      expect(column2, [15.0, 16.0, 17.0, 18.0]);
    });

    test('should return required column as a vector', () {
      final matrix = Float32x4Matrix.from([
        [11.0, 12.0, 13.0, 14.0],
        [15.0, 16.0, 17.0, 18.0],
        [21.0, 22.0, 23.0, 24.0],
      ]);
      final row1 = matrix.getColumnVector(0);
      final row2 = matrix.getColumnVector(1);
      final row3 = matrix.getColumnVector(2);
      final row4 = matrix.getColumnVector(3);

      expect(row1 is Vector, isTrue);
      expect(row1, [11.0, 15.0, 21.0]);

      expect(row2 is Vector, isTrue);
      expect(row2, [12.0, 16.0, 22.0]);

      expect(row3 is Vector, isTrue);
      expect(row3, [13.0, 17.0, 23.0]);

      expect(row4 is Vector, isTrue);
      expect(row4, [14.0, 18.0, 24.0]);
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

    test('should perform multiplication with a Vector instance', () {
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

    test('should throw an error if one tries to mult a matrix with a vector of unproper length', () {
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
  });
}