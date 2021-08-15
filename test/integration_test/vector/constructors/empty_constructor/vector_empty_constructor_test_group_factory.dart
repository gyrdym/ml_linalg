import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorEmptyConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('empty constructor', () {
        test('should create a vector with 0 length', () {
          final vector = Vector.empty(dtype: dtype);

          expect(vector.length, 0);
          expect(vector.isEmpty, isTrue);
          expect(vector.dtype, dtype);
        });

        test(
            'should create a vector that throws an exception if one tries to'
            'access its elements by index', () {
          final vector = Vector.empty(dtype: dtype);

          expect(() => vector[0], throwsException);
        });
      });
    });
