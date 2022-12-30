import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixRandomConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('random constructor', () {
        test(
            'should create a matrix with random elements, each element should be within a specified range',
            () {
          final matrix = Matrix.random(20, 30, dtype: dtype, min: -3, max: 3);

          matrix.forEach((row) {
            row.forEach((element) {
              expect(element, inInclusiveRange(-3, 3));
            });
          });

          expect(matrix.rowCount, 20);
          expect(matrix.columnCount, 30);
          expect(matrix.dtype, dtype);
        });
      });
    });
