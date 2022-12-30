import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void vectorFilledConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('filled constructor', () {
        test('should create a vector filled with the passed value', () {
          final vector = Vector.filled(10, 2.0, dtype: dtype);
          expect(vector,
              equals([2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0]));
          expect(vector.length, equals(10));
          expect(vector.dtype, dtype);
        });
      });
    });
