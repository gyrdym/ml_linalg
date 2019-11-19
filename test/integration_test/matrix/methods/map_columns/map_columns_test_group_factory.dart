import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixMapColumnsTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('mapColumns method', () {
        test('should perform column-wise mapping of the matrix to a new one', () {
          final matrix = Matrix.fromList([
            [11.0, 12.0, 13.0, 14.0],
            [15.0, 16.0, 17.0, 18.0],
            [21.0, 22.0, 23.0, 24.0],
          ], dtype: dtype);

          final modifier = Vector.filled(3, 2.0, dtype: dtype);
          final actual = matrix.mapColumns((column) => column + modifier);
          final expected = [
            [13.0, 14.0, 15.0, 16.0],
            [17.0, 18.0, 19.0, 20.0],
            [23.0, 24.0, 25.0, 26.0],
          ];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });
      });
    });
