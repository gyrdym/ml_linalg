import 'package:linalg/src/matrix/float32x4_matrix.dart';
import 'package:linalg/src/matrix/range.dart';
import 'package:linalg/src/vector/vector.dart';
import 'package:test/test.dart';

void main() {
  group('Float32x4Matrix', () {
    group('`from ` constructor', () {
      test('should create matrix based on given list', () {
        final actual = Float32x4Matrix.from([
          [1.0, 2.0, 3.0, 4.0, 5.0],
          [6.0, 7.0, 8.0, 9.0, 0.0],
        ]);
        final expected = [
          [1.0, 2.0, 3.0, 4.0, 5.0],
          [6.0, 7.0, 8.0, 9.0, 0.0],
        ];
        expect(actual, equals(expected));
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
        final submatrix = matrix.submatrix(Range(1, 3), Range(1, 2));
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
        final submatrix = matrix.submatrix(Range(1, 3, endInclusive: true), Range(1, 2, endInclusive: true));
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
        final submatrix = matrix.submatrix(Range(1, 3, endInclusive: true), Range(1, 2, endInclusive: false));
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
        final submatrix = matrix.submatrix(Range(1, 3, endInclusive: false), Range(1, 2, endInclusive: true));
        final expected = [
          [16.0, 17.0],
          [22.0, 23.0],
        ];
        expect(submatrix, expected);
      });
    });
  });
}