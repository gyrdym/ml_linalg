import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void vectorToIntegerPowerTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('toIntegerPower method', () {
        test('should raise vector elements to the integer power', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final result = vector.toIntegerPower(3);

          expect(result, isNot(same(vector)));
          expect(result.length, equals(5));
          expect(result, equals([1.0, 8.0, 27.0, 64.0, 125.0]));
          expect(result.dtype, dtype);
        });
      });
    });
