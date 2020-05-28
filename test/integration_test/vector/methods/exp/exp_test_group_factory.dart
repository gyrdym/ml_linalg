import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorExpTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('exp method', () {
        test('should raise euler\'s numbers to elements of vector', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final result = vector.exp();

          expect(result, iterableAlmostEqualTo([
            2.7182, 7.3890, 20.08553, 54.5981, 148.4131], 1e-3));
        });
      });
    });
