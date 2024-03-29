import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';
import '../../../helpers.dart';

void matrixSolveTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('solve', () {
        test('should solve system of linear equations, 2x2 matrix', () {
          final A = Matrix.fromList([
            [3, 1],
            [4, 3],
          ], dtype: dtype);
          final B = Matrix.fromList([
            [3],
            [17],
          ], dtype: dtype);
          final actual = A.solve(B);
          final expected = [
            [-1.6],
            [7.8],
          ];

          expect(actual, iterable2dAlmostEqualTo(expected, 1e-6));
        });

        test('should solve system of linear equations, 3x3 matrix', () {
          final A = Matrix.fromList([
            [1, 1, 1],
            [0, 2, 5],
            [2, 5, -1],
          ], dtype: dtype);
          final B = Matrix.fromList([
            [6],
            [-4],
            [27],
          ], dtype: dtype);
          final actual = A.solve(B);
          final expected = [
            [5],
            [3],
            [-2]
          ];

          expect(actual, iterable2dAlmostEqualTo(expected, 1e-6));
        });
      });
    });
