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
          final actual =
              matrix.eigen(initial: Vector.filled(2, 1.0, dtype: dtype));

          expect(actual, hasLength(1));
          expect(actual.elementAt(0).value, closeTo(2, 1e-3));
          expect(
              actual.elementAt(0).vector, iterableAlmostEqualTo([0, 1], 1e-2));
        });
      });
    });
