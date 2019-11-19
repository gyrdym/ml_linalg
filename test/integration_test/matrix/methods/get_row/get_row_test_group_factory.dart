import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixGetRowTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('getRow method', () {
        test('should return required row as a vector', () {
          final matrix = Matrix.fromList([
            [11.0, 12.0, 13.0, 14.0],
            [15.0, 16.0, 17.0, 18.0],
          ], dtype: dtype);

          final row1 = matrix.getRow(0);
          final row2 = matrix.getRow(1);

          expect(row1 is Vector, isTrue);
          expect(row1, [11.0, 12.0, 13.0, 14.0]);

          expect(row2 is Vector, isTrue);
          expect(row2, [15.0, 16.0, 17.0, 18.0]);

          expect(matrix.dtype, dtype);
        });

        test('should cache repeatedly retrieving row vector', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.1],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          // write value to the cache
          final row1 = matrix.getRow(1);
          final row2 = matrix.getRow(1);

          expect(identical(row1, row2), isTrue);

          expect(matrix.dtype, dtype);
        });
      });
    });
