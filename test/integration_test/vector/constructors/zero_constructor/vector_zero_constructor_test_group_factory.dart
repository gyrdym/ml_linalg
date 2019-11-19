import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorZeroConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('zero constructor', () {
        test('should fill a newly created vector with zeroes, case 1', () {
          final vector = Vector.zero(10, dtype: dtype);
          expect(vector,
              equals([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]));
          expect(vector.length, equals(10));
          expect(vector.dtype, dtype);
        });

        test('should fill a newly created vector with zeroes, case 2', () {
          final vector = Vector.zero(1, dtype: dtype);
          expect(vector, equals([0.0]));
          expect(vector.length, equals(1));
          expect(vector.dtype, dtype);
        });

        test('should fill a newly created vector with zeroes, case 3', () {
          final vector = Vector.zero(2, dtype: dtype);
          expect(vector, equals([0.0, 0.0]));
          expect(vector.length, equals(2));
          expect(vector.dtype, dtype);
        });
      });
    });
