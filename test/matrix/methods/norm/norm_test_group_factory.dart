import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixNormTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('norm method', () {
        test('should find a frobenius norm', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 17.2626;

          expect(norm, closeTo(expected, 0.6));
        });
      });
    });
