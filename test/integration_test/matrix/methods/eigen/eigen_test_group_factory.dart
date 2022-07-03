import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';
import '../../../../helpers.dart';

void eigenTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('eigen', () {
        test(
            'should return eigen vectors and eigen values for Power Iteration method',
            () {
          final matrix = Matrix.fromList([
            [1, 0],
            [0, 2],
          ], dtype: dtype);
          final actual = matrix.eigen();

          expect(actual, hasLength(1));
          expect(actual.elementAt(0).value, closeTo(2, 1e-3));
          expect(
              actual.elementAt(0).vector, iterableAlmostEqualTo([0, 1], 1e-2));
        });

        test('should solve PageRank problem', () {
          final l = Matrix.fromList([
            [0, 1 / 2, 1 / 3, 0, 0, 0],
            [1 / 3, 0, 0, 0, 1 / 2, 0],
            [1 / 3, 1 / 2, 0, 1, 0, 1 / 2],
            [1 / 3, 0, 1 / 3, 0, 1 / 2, 1 / 2],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 1 / 3, 0, 0, 0]
          ], dtype: dtype);

          final initial = Vector.randomFilled(6, seed: 10, dtype: dtype);
          final eigen = l.eigen(initial: initial, iterationCount: 30).first;
          final actual = eigen.vector / eigen.vector.sum() * 100;
          final expected = [16, 5.33, 40, 25.33, 0, 13.33];

          expect(actual, iterableAlmostEqualTo(expected, 1e-2));
        });
      });
    });
