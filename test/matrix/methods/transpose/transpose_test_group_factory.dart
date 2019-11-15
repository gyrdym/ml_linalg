import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixTransposeTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('transpose method', () {
        test('should transpose a matrix', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final actual = matrix.transpose();

          final expected = [
            [1.0, 5.0, 9.0],
            [2.0, 6.0, .0],
            [3.0, 7.0, -2.0],
            [4.0, 8.0, -3.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 4);
          expect(actual.columnsNum, 3);
          expect(actual.dtype, dtype);
        });

        test('should transpose a 1xN matrix', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0], dtype: dtype);
          final matrix = Matrix.fromRows([vector], dtype: dtype);

          final actual = matrix.transpose();

          final expected = [
            [1.0],
            [2.0],
            [3.0],
            [4.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowsNum, 4);
          expect(actual.columnsNum, 1);
          expect(actual.dtype, dtype);
        });

        test('should transpose a Nx1 matrix', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0], dtype: dtype);
          final matrix = Matrix.fromColumns([vector], dtype: dtype);

          final actual = matrix.transpose();
          final expected = [
            [1.0, 2.0, 3.0, 4.0],
          ];

          expect(actual, equals(expected));
          expect(actual.columnsNum, 4);
          expect(actual.rowsNum, 1);
          expect(actual.dtype, dtype);
        });
      });
    });
