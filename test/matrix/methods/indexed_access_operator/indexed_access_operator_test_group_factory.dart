import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixIndexedAccessOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('[] operator', () {
        test('should provide indexed access to its elements', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0],
            [6.0, 7.0, 8.0]
          ], dtype: dtype);

          expect(matrix[0][0], 1.0);
          expect(matrix[0][1], 2.0);
          expect(matrix[0][2], 3.0);
          expect(matrix[1][0], 6.0);
          expect(matrix[1][1], 7.0);
          expect(matrix[1][2], 8.0);

          expect(matrix.dtype, dtype);
        });
      });
    });
