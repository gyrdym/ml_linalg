import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixFromRowsConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('fromRows constructor', () {
        test('should create an instance with predefined vectors as matrix '
            'rows', () {
          final actual = Matrix.fromRows([
            Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]),
            Vector.fromList([6.0, 7.0, 8.0, 9.0, 0.0]),
          ], dtype: dtype);

          final expected = [
            [1.0, 2.0, 3.0, 4.0, 5.0],
            [6.0, 7.0, 8.0, 9.0, 0.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 2);
          expect(actual.columnsNum, 5);
          expect(actual.dtype, dtype);
        });

        test('should create an instance based on an empty list', () {
          final actual = Matrix.fromRows([], dtype: dtype);
          final expected = <double>[];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 0);
          expect(actual.columnsNum, 0);
          expect(actual.dtype, dtype);
        });
      });
    });