import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorSqrtTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('sqrt method', () {
        test('should extract square root of each element', () {
          final vector = Vector.fromList([4, 25, 9], dtype: dtype);

          expect(vector.sqrt(), equals([2, 5, 3]));
        });

        test('should return NaN value for negative elements', () {
          final vector = Vector.fromList([-4, -25, -9], dtype: dtype);

          expect(vector.sqrt(), equals([isNaN, isNaN, isNaN]));
        });
      });
    });
