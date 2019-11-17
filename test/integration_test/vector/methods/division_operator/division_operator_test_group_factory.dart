import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorDivisionOperatorTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('/ operator', () {
        test('should perform division by another vector', () {
          final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);
          final vector2 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);

          final actual = vector1 / vector2;

          expect(actual, equals([1.0, 1.0, 1.0, 1.0, 1.0]));
          expect(actual.length, equals(5));
          expect(actual.dtype, dtype);
        });

        test('should throw an error if one tries to divide by a vector of '
            'inappropriate length', () {
          final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final vector2 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
              dtype: dtype);

          expect(() => vector1 / vector2, throwsRangeError);
        });

        test('should perform division by a scalar', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final result = vector / 2.0;

          expect(result, isNot(same(vector)));
          expect(result.length, equals(5));
          expect(result, equals([0.5, 1.0, 1.5, 2.0, 2.5]));
        });
      });
    });
