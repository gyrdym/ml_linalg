import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixRowConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('row constructor', () {
        test('should create a matrix with just one row', () {
          final source = [1.0, 2.0, 3.0, 4.0, 5.0];
          final matrix = Matrix.row(source, dtype: dtype);

          expect(matrix, equals([
            [1, 2, 3, 4, 5]
          ]));

          expect(matrix.columnsNum, 5);
          expect(matrix.rowsNum, 1);
          expect(matrix.dtype, dtype);
        });

        test('should create empty matrix if empty list is provided', () {
          final source = <double>[];
          final matrix = Matrix.row(source, dtype: dtype);

          expect(matrix, equals(<Iterable<double>>[]));
          expect(matrix.rowsNum, 0);
          expect(matrix.columnsNum, 0);
          expect(matrix.hasData, isFalse);
          expect(matrix.dtype, dtype);
        });
      });
    });
