import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixMapRowsTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('mapRows method', () {
        test('should perform row-wise mapping of the matrix to a new one', () {
          final matrix = Matrix.fromList([
            [11.0, 12.0, 13.0, 14.0],
            [15.0, 16.0, 17.0, 18.0],
            [21.0, 22.0, 23.0, 24.0],
          ], dtype: dtype);

          final modifier = Vector.filled(4, 1.0, dtype: dtype);
          final actual = matrix.mapRows((row) => row - modifier);

          final expected = [
            [10.0, 11.0, 12.0, 13.0],
            [14.0, 15.0, 16.0, 17.0],
            [20.0, 21.0, 22.0, 23.0],
          ];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });
      });
    });
