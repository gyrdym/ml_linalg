import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixReduceRowsTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('reduceRows method', () {
        test(
            'should reduce all the matrix rows into a single vector, without '
            'initial reducer value', () {
          final matrix = Matrix.fromList([
            [11.0, 12.0, 13.0, 14.0],
            [15.0, 16.0, 17.0, 18.0],
            [21.0, 22.0, 23.0, 24.0],
          ], dtype: dtype);

          final actual =
              matrix.reduceRows((combine, vector) => combine + vector);
          final expected = [47, 50, 53, 56];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test(
            'should reduce all the matrix rows into a single vector, with initial '
            'reducer value', () {
          final matrix = Matrix.fromList([
            [11.0, 12.0, 13.0, 14.0],
            [15.0, 16.0, 17.0, 18.0],
            [21.0, 22.0, 23.0, 24.0],
          ], dtype: dtype);

          final actual = matrix.reduceRows(
              (combine, vector) => combine + vector,
              initValue: Vector.fromList([2.0, 3.0, 4.0, 5.0], dtype: dtype));
          final expected = [49, 53, 57, 61];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });
      });
    });
