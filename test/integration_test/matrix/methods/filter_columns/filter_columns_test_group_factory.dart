import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixFilterColumnsTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('filterColumns method', () {
        test(
            'should return a new matrix consisting of filtered columns, filter by column index',
            () {
          final matrix = Matrix.fromList([
            [11.0, 12.0, 13.0, 14.0],
            [15.0, 16.0, 17.0, 18.0],
            [21.0, 22.0, 23.0, 24.0],
          ], dtype: dtype);

          final indicesToExclude = [0, 3];
          final actual = matrix
              .filterColumns((column, idx) => !indicesToExclude.contains(idx));
          final expected = [
            [12.0, 13.0],
            [16.0, 17.0],
            [22.0, 23.0],
          ];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test(
            'should return a new matrix consisting of filtered columns, filter by column',
            () {
          final matrix = Matrix.fromList([
            [11.0, 33.0, 13.0, 14.0],
            [15.0, 92.0, 17.0, 18.0],
            [21.0, 22.0, 23.0, 24.0],
          ], dtype: dtype);

          final actual =
              matrix.filterColumns((column, _) => column.sum() > 100);
          final expected = [
            [33.0],
            [92.0],
            [22.0],
          ];

          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });
      });
    });
