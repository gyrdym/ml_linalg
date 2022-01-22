import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/common/exception/cholesky_non_square_matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixDecomposeTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('decompose', () {
        test('should perform cholesky decomposition', () {
          final matrix = Matrix.fromList([
            [4, 12, -16],
            [12, 37, -43],
            [-16, -43, 98],
          ], dtype: dtype);

          expect(
              matrix.decompose(Decomposition.cholesky),
              equals([
                [
                  [2, 0, 0],
                  [6, 1, 0],
                  [-8, 5, 3],
                ],
                [
                  [2, 6, -8],
                  [0, 1, 5],
                  [0, 0, 3],
                ],
              ]));

          expect(matrix.dtype, dtype);
        });

        test('should throw exception if matrix is not square', () {
          final matrix = Matrix.fromList([
            [4, 12, -16],
            [12, 37, -43],
            [-16, -43, 98],
            [-1, -4, 9],
          ], dtype: dtype);

          expect(() => matrix.decompose(),
              throwsA(isA<CholeskyNonSquareMatrixException>()));
        });
      });
    });
