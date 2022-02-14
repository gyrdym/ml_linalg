import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixRandomSPDConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('randomSPD constructor', () {
        test(
            'should create a square matrix with random elements, each element should be within a specified range',
            () {
          final matrix = Matrix.randomSPD(30, dtype: dtype, min: -10, max: 10);

          matrix.forEach((row) {
            row.forEach((element) {
              expect(element, inInclusiveRange(-1e4, 1e4));
            });
          });

          expect(matrix.rowsNum, 30);
          expect(matrix.columnsNum, 30);
          expect(matrix.dtype, dtype);
        });
      });
    });
