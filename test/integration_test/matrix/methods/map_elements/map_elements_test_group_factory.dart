import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixMapElementsTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('mapElements method', () {
        test('should perform element-wise mapping of the matrix to a new one',
            () {
          final matrix = Matrix.fromList([
            [11.0, 12.0, 13.0, 14.0],
            [15.0, 16.0, 17.0, 18.0],
            [21.0, 22.0, 23.0, 24.0],
          ], dtype: dtype);
          final actual = matrix.mapElements((el) => el * 3);
          final expected = [
            [33.0, 36.0, 39.0, 42.0],
            [45.0, 48.0, 51.0, 54.0],
            [63.0, 66.0, 69.0, 72.0],
          ];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test('should perform element-wise mapping of a column matrix', () {
          final matrix =
              Matrix.column([11.0, 12.0, -13.0, 14.2, 1.0], dtype: dtype);
          final actual = matrix.mapElements((el) => el * -2);
          final expected = [
            [-22.0],
            [-24.0],
            [26.0],
            [closeTo(-28.4, 1e-3)],
            [-2]
          ];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test('should perform element-wise mapping of a row matrix', () {
          final matrix =
              Matrix.row([11.0, 12.0, -13.0, 14.2, 1.0], dtype: dtype);
          final actual = matrix.mapElements((el) => el * -2);
          final expected = [
            [-22.0, -24.0, 26.0, closeTo(-28.4, 1e-3), -2]
          ];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test('should return empty matrix if an empty matrix is being mapped',
            () {
          final matrix = Matrix.fromColumns([], dtype: dtype);
          final actual = matrix.mapElements((el) => el + 200);

          expect(actual, equals(<double>[]));
          expect(actual.dtype, dtype);
        });
      });
    });
