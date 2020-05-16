import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixSubtractionOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('- operator', () {
        test('should perform matricies subtraction', () {
          final matrix1 = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final matrix2 = Matrix.fromList([
            [10.0, 20.0, 30.0, 40.0],
            [-5.0, 16.0, 2.0, 18.0],
            [2.0, -1.0, -2.0, -7.0],
          ], dtype: dtype);

          final actual = matrix1 - matrix2;

          final expected = [
            [-9.0, -18.0, -27.0, -36.0],
            [10.0, -10.0, 5.0, -10.0],
            [7.0, 1.0, .0, 4.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 3);
          expect(actual.columnsNum, 4);
          expect(actual.dtype, dtype);
        });
      });
    });
