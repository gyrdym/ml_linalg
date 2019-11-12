import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_class_name_mapping.dart';

void vectorToIntegerPowerTestGroupFactory(DType dtype) =>
    group(dtypeToVectorClassName[dtype], () {
      group('toIntegerPower method', () {
        test('should raise vector elements to the integer power', () {
          final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final result = vector1.toIntegerPower(3);

          expect(result != vector1, isTrue);
          expect(result.length, equals(5));
          expect(result, equals([1.0, 8.0, 27.0, 64.0, 125.0]));
          expect(result.dtype, dtype);
        });
      });
    });
