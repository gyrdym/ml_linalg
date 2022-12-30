import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixScalarConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('scalar constructor', () {
        test(
            'should create a matrix with all zero elements except for main '
            'diagonal ones - they should be equal to the given scalar value',
            () {
          final matrix = Matrix.scalar(-3.0, 7, dtype: dtype);

          expect(
              matrix,
              equals([
                [-3, 0, 0, 0, 0, 0, 0],
                [0, -3, 0, 0, 0, 0, 0],
                [0, 0, -3, 0, 0, 0, 0],
                [0, 0, 0, -3, 0, 0, 0],
                [0, 0, 0, 0, -3, 0, 0],
                [0, 0, 0, 0, 0, -3, 0],
                [0, 0, 0, 0, 0, 0, -3],
              ]));
          expect(matrix.dtype, dtype);
        });
      });
    });
