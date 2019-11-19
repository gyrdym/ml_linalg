import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorNormalizeTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('normalize method', () {
        test('should normalize itself (Eucleadean norm)', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final actual = vector.normalize(Norm.euclidean);
          final expected = [0.134, 0.269, 0.404, 0.539, 0.674];

          expect(actual, iterableAlmostEqualTo(expected, 1e-3));
          expect(actual.norm(Norm.euclidean), closeTo(1.0, 1e-3));
          expect(actual.dtype, dtype);
        });

        test('should normalize itself (Manhattan norm)', () {
          final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0],
              dtype: dtype);
          final actual = vector.normalize(Norm.manhattan);
          final expected = [1 / 15, -2 / 15, 3 / 15, -4 / 15, 5 / 15];

          expect(actual, iterableAlmostEqualTo(expected, 1e-3));
          expect(actual.norm(Norm.manhattan), closeTo(1.0, 1e-3));
          expect(actual.dtype, dtype);
        });
      });
    });
