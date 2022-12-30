import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixReduceColumnsTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('reduceColumns method', () {
        test(
            'should reduce all the matrix columns into a single vector, without '
            'initial reducer value', () {
          final matrix = Matrix.fromList([
            [11.0, 12.0, 13.0, 14.0],
            [15.0, 16.0, 17.0, 18.0],
            [21.0, 22.0, 23.0, 24.0],
          ], dtype: dtype);

          final actual =
              matrix.reduceColumns((combine, vector) => combine + vector);
          final expected = [50, 66, 90];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test(
            'should reduce all the matrix columns into a single vector, with '
            'initial reducer value', () {
          final matrix = Matrix.fromList([
            [11.0, 12.0, 13.0, 14.0],
            [15.0, 16.0, 17.0, 18.0],
            [21.0, 22.0, 23.0, 24.0],
          ], dtype: dtype);

          final actual = matrix.reduceColumns(
              (combine, vector) => combine + vector,
              initValue: Vector.fromList([2.0, 3.0, 4.0], dtype: dtype));
          final expected = [52, 69, 94];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });
      });
    });
