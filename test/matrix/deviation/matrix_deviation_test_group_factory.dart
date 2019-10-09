import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

import '../../dtype_to_class_name_mapping.dart';

void matrixDeviationTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixClassName[dtype], () {
      group('deviation', () {
        test('should calculate standard deviation for each column and return '
            'calculated values as a vector', () {
          final matrix = Matrix.fromList([
            [10,   20,   3000],
            [33,    0,  30000],
            [27,  -20,  30000],
            [21, 1330, -10000],
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation,
              iterableAlmostEqualTo([8.496, 576.0805, 17369.154], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test('should calculate standard deviation column-wise for a matrix with '
            'just one column', () {
          final matrix = Matrix.fromList([
            [10],
            [33],
            [27],
            [21],
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation,
              iterableAlmostEqualTo([8.496], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test('should calculate standard deviation column-wise for a matrix with '
            'just one row', () {
          final matrix = Matrix.fromList([
            [10,   20,   3000],
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation, equals([0, 0, 0]));
          expect(deviation.dtype, dtype);
        });

        test('should return an empty vector for an empty matrix (column-wise '
            'case)', () {
          final matrix = Matrix.empty(dtype: dtype);

          final deviation = matrix.deviation(Axis.columns);

          expect(deviation, isEmpty);
          expect(deviation.dtype, dtype);
        });

        test('should calculate standard deviation for each row and return '
            'calculated values as a vector', () {
          final matrix = Matrix.fromList([
            [1,     1,      1],
            [33,    0,  30000],
            [27,  -20,  30000],
            [0,     0,      0],
          ], dtype: dtype); // means 1, 10011, 10002.33, 0,

          final deviation = matrix.deviation(Axis.rows);

          expect(deviation,
              iterableAlmostEqualTo([0, 14134.363, 14140.498, 0], 1e-2));
          expect(deviation.dtype, dtype);
        });

        test('should calculate standard deviation row-wise for a matrix with '
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

        test('should calculate standard deviation row-wise for a matrix with '
            'just one row', () {
          final matrix = Matrix.fromList([
            [27,  -20,  30000],
          ], dtype: dtype);

          final deviation = matrix.deviation(Axis.rows);

          expect(deviation, iterableAlmostEqualTo([14140.499], 1e-3));
          expect(deviation.dtype, dtype);
        });

        test('should return an empty vector for an empty matrix (row-wise '
            'case)', () {
          final matrix = Matrix.empty(dtype: dtype);

          final deviation = matrix.deviation(Axis.rows);

          expect(deviation, isEmpty);
          expect(deviation.dtype, dtype);
        });
      });
    });