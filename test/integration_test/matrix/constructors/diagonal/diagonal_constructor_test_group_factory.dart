import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixDiagonalConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('diagonal constructor', () {
        test(
            'should create a matrix with all zero elements but main diagonal '
            'ones', () {
          final source = [1.0, 2.0, 3.0, 4.0, 5.0];
          final matrix = Matrix.diagonal(source, dtype: dtype);

          expect(
              matrix,
              equals([
                [1, 0, 0, 0, 0],
                [0, 2, 0, 0, 0],
                [0, 0, 3, 0, 0],
                [0, 0, 0, 4, 0],
                [0, 0, 0, 0, 5],
              ]));
          expect(matrix.dtype, dtype);
        });

        test('should create empty matrix if empty list is provided', () {
          final source = <double>[];
          final matrix = Matrix.diagonal(source, dtype: dtype);

          expect(matrix, equals(<Iterable<double>>[]));
          expect(matrix.rowsNum, 0);
          expect(matrix.columnsNum, 0);
          expect(matrix.hasData, isFalse);
          expect(matrix.dtype, dtype);
        });
      });
    });
