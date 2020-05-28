import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixPowTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('pow method', () {
        test('should raise all the matrix elements to the provided power', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, 0.0, -2.0, -3.0],
          ], dtype: dtype);
          final raised = matrix.pow(3);

          expect(raised, [
            [  1.0,   8.0,  27.0,  64.0],
            [125.0, 216.0, 343.0, 512.0],
            [729.0,   0.0,  -8.0, -27.0],
          ]);
          expect(matrix.dtype, dtype);
        });

        test('should raise all the matrix elements to 0', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, 0.0, -2.0, -3.0],
          ], dtype: dtype);
          final raised = matrix.pow(0);

          expect(raised, [
            [1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0],
          ]);
          expect(matrix.dtype, dtype);
        });
      });
    });
