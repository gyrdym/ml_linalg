import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixUniqueRowsTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('uniqueRows method', () {
        test(
            'should return all the matrix rows if the matrix does not have '
            'repeating rows at all', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final actual = matrix.uniqueRows();

          final expected = [
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test('should return non-repeating rows', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [36.0, .0, -8.0, -12.0, 12.0],
          ], dtype: dtype);

          final actual = matrix.uniqueRows();

          final expected = [
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
          ];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });
      });
    });
