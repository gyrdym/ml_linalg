import 'package:ml_linalg/axis.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';
import '../../../helpers.dart';

void matrixDeviationTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('deviation method', () {
        test(
            'should calculate standard deviation for each column and return '
            'calculated values as a vector', () {
          final matrix = Matrix.fromList([
            [10, 20, 3000],
            [33, 0, 30000],
            [27, -20, 30000],
            [21, 1330, -10000],
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation,
              iterableAlmostEqualTo([8.496, 576.0805, 17369.154], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation column-wise for a matrix with '
            'just one column', () {
          final matrix = Matrix.fromList([
            [10],
            [33],
            [27],
            [21],
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation, iterableAlmostEqualTo([8.496], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation column-wise for a matrix with '
            'just one column, 5x1 matrix', () {
          final matrix = Matrix.fromList([
            [1],
            [2],
            [3],
            [4],
            [5],
          ], dtype: dtype);

          // 1 - 3 = -2 = 4
          // 2 - 3 = -1 = 1
          // 3 - 3 = 0 = 0
          // 4 - 3 = 1 = 1
          // 5 - 3 = 2 = 4
          //--------------
          // 10 / 5 = 2

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation, iterableAlmostEqualTo([1.414], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation column-wise for a matrix with '
            'just one column, 9x1 matrix', () {
          final matrix = Matrix.fromList([
            [1],
            [2],
            [3],
            [4],
            [5],
            [6],
            [7],
            [8],
            [9],
          ], dtype: dtype);

          // 1 - 5 = -4 = 16
          // 2 - 5 = -3 = 9
          // 3 - 5 = -2 = 4
          // 4 - 5 = -1 = 1
          // 5 - 5 = 0 = 0
          // 6 - 5 = 1 = 1
          // 7 - 5 = 2 = 4
          // 8 - 5 = 3 = 9
          // 9 - 5 = 4 = 16
          //--------------
          // 60 / 9 = 6.66

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation, iterableAlmostEqualTo([2.581], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation column-wise for a matrix with '
            'just one column, 9x2 matrix', () {
          final matrix = Matrix.fromList([
            [1, 1],
            [2, 2],
            [3, 3],
            [4, 4],
            [5, 5],
            [6, 6],
            [7, 7],
            [8, 8],
            [9, 9],
          ], dtype: dtype);

          // 1 - 5 = -4 = 16
          // 2 - 5 = -3 = 9
          // 3 - 5 = -2 = 4
          // 4 - 5 = -1 = 1
          // 5 - 5 = 0 = 0
          // 6 - 5 = 1 = 1
          // 7 - 5 = 2 = 4
          // 8 - 5 = 3 = 9
          // 9 - 5 = 4 = 16
          //--------------
          // 60 / 9 = 6.66

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation, iterableAlmostEqualTo([2.581, 2.581], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation column-wise for a matrix with '
            'just one row', () {
          final matrix = Matrix.fromList([
            [10, 20, 3000],
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation, equals([0, 0, 0]));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation column-wise for a matrix with '
            'just one row, 1x5 matrix', () {
          final matrix = Matrix.fromList([
            [10, 20, 3000, 4000, -60000],
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation, equals([0, 0, 0, 0, 0]));
          expect(deviation.dtype, dtype);
        });

        test(
            'should return an empty vector for an empty matrix (column-wise '
            'case)', () {
          final matrix = Matrix.empty(dtype: dtype);

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation, isEmpty);
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation for each row and return '
            'calculated values as a vector', () {
          final matrix = Matrix.fromList([
            [1, 1, 1],
            [33, 0, 30000], // 33 - 10011, 0 - 10011, 30000 - 10011
            [27, -20, 30000],
            [0, 0, 0],
          ], dtype: dtype); // means 1, 10011, 10002.33, 0,

          final deviation = matrix.deviation(Axis.rows);

          expect(deviation,
              iterableAlmostEqualTo([0, 14134.363, 14140.498, 0], 1e-2));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation row-wise for a matrix with '
            'just one column', () {
          final matrix = Matrix.fromList([
            [10],
            [33],
            [27],
            [21],
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.rows);

          expect(deviation, equals([0, 0, 0, 0]));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation row-wise for a matrix with '
            'just one row', () {
          final matrix = Matrix.fromList([
            [27, -20, 30000],
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.rows);

          expect(deviation, iterableAlmostEqualTo([14140.499], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation row-wise for a matrix with '
            'just one row, 1x5 matrix', () {
          final matrix = Matrix.fromList([
            [3, 4, 5, 6, 7],
          ], dtype: dtype);

          // 3 - 5 = -2 = 4
          // 4 - 5 = -1 = 1
          // 5 - 5 = -0 = 0
          // 6 - 5 = 1 = 1
          // 7 - 5 = 2 = 4
          //-------------------
          // 10 / 5 = 2

          final deviation = matrix.deviation(Axis.rows);

          expect(deviation, iterableAlmostEqualTo([1.414], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation row-wise for a matrix with '
            'just one row, 1x9 matrix', () {
          final matrix = Matrix.fromList([
            [3, 4, 5, 6, 7, 8, 9, 10, 11],
          ], dtype: dtype);

          // 3 - 7 = -4 = 16
          // 4 - 7 = -3 = 9
          // 5 - 7 = -2 = 4
          // 6 - 7 = -1 = 1
          // 7 - 7 = 0 = 0
          // 8 - 7 = 1 = 1
          // 9 - 7 = 2 = 4
          // 10 - 7 = 3 = 9
          // 11 - 7 = 4 = 16
          //-------------------
          // 60 / 9 = 6.66

          final deviation = matrix.deviation(Axis.rows);

          expect(deviation, iterableAlmostEqualTo([2.581], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation row-wise for a matrix with '
            'just one row, 2x5 matrix', () {
          final matrix = Matrix.fromList([
            [3, 4, 5, 6, 7],
            [1, 2, 3, 4, 5]
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.rows);

          expect(deviation, iterableAlmostEqualTo([1.414, 1.414], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test(
            'should calculate standard deviation row-wise for a matrix with '
            'just one row, 2x9 matrix', () {
          final matrix = Matrix.fromList([
            [3, 4, 5, 6, 7, 8, 9, 10, 11],
            [3, 4, 5, 6, 7, 8, 9, 10, 11],
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.rows);

          expect(deviation, iterableAlmostEqualTo([2.581, 2.581], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test(
            'should return an empty vector for an empty matrix (row-wise '
            'case)', () {
          final matrix = Matrix.empty(dtype: dtype);

          final deviation = matrix.deviation(Axis.rows);

          expect(deviation, isEmpty);
          expect(deviation.dtype, dtype);
        });
      });
    });
