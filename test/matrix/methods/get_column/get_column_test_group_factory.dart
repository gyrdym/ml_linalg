import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixGetColumnTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('getColumn method', () {
        test('should return required column as a vector', () {
          final matrix = Matrix.fromList([
            [11.0, 12.0, 13.0, 14.0],
            [15.0, 16.0, 17.0, 18.0],
            [21.0, 22.0, 23.0, 24.0],
          ], dtype: dtype);

          final column1 = matrix.getColumn(0);
          final column2 = matrix.getColumn(1);
          final column3 = matrix.getColumn(2);
          final column4 = matrix.getColumn(3);

          expect(column1, [11.0, 15.0, 21.0]);
          expect(column2, [12.0, 16.0, 22.0]);
          expect(column3, [13.0, 17.0, 23.0]);
          expect(column4, [14.0, 18.0, 24.0]);

          expect(matrix.dtype, dtype);
        });

        test('should cache repeatedly retrieving column vector', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.1],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          // write value to the cache
          final column1 = matrix.getColumn(1);
          final column2 = matrix.getColumn(1);

          expect(identical(column1, column2), isTrue);
          expect(matrix.dtype, dtype);
        });
      });
    });
