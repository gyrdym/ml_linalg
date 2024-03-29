import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixRowsTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('rows getter', () {
        test('should return matrix rows', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0],
            [20.0, 24.0, 28.0, 32.0],
            [36.0, .0, -8.0, -12.0],
          ], dtype: dtype);

          expect(
              matrix.rows,
              equals([
                [4.0, 8.0, 12.0, 16.0],
                [20.0, 24.0, 28.0, 32.0],
                [36.0, .0, -8.0, -12.0],
              ]));

          expect(matrix.dtype, dtype);
        });
      });
    });
