import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixRowIndicesTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('rowIndices getter', () {
        test('should contain zero-based ordered iterable of row indices', () {
          final matrix = Matrix.fromList([
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [100, 200, 300, 400],
          ], dtype: dtype);

          expect(matrix.rowIndices, equals([0, 1, 2]));
          expect(matrix.dtype, dtype);
        });

        test('should contain empty iterable if matrix is empty', () {
          final matrix = Matrix.fromList([], dtype: dtype);

          expect(matrix.rowIndices, isEmpty);
          expect(matrix.dtype, dtype);
        });
      });
    });
