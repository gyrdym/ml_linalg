import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixFromColumnsConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('fromColumns constructor', () {
        test('should create an instance with predefined vectors as matrix '
            'columns', () {
          final actual = Matrix.fromColumns([
            Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype),
            Vector.fromList([6.0, 7.0, 8.0, 9.0, 0.0], dtype: dtype),
          ], dtype: dtype);

          final expected = [
            [1.0, 6.0],
            [2.0, 7.0],
            [3.0, 8.0],
            [4.0, 9.0],
            [5.0, 0.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 5);
          expect(actual.columnsNum, 2);
          expect(actual.dtype, dtype);
        });

        test('should create an instance based on an empty list', () {
          final actual = Matrix.fromColumns([], dtype: dtype);
          final expected = <double>[];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 0);
          expect(actual.columnsNum, 0);
          expect(actual.dtype, dtype);
        });
      });
    });