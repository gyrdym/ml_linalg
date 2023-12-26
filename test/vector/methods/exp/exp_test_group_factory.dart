import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';
import '../../../helpers.dart';

void vectorExpTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('exp method', () {
        test('should raise euler\'s numbers to elements of vector', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final result = vector.exp();

          expect(
              result,
              iterableAlmostEqualTo(
                  [2.7182, 7.3890, 20.08553, 54.5981, 148.4131], 1e-3));
        });

        test('should extract value from cache', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);

          final log = vector.log();
          final exp = vector.exp();
          final exp2 = vector.exp();

          expect(exp, exp2);
          expect(exp, isNot(log));
        });
      });
    });
