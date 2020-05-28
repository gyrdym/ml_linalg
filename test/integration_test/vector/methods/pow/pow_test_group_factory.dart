import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void vectorPowTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('pow method', () {
        test('should raise vector elements to the power', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final result = vector.pow(3);

          expect(result, isNot(same(vector)));
          expect(result.length, equals(5));
          expect(result, equals([1.0, 8.0, 27.0, 64.0, 125.0]));
          expect(result.dtype, dtype);
        });

        test('should raise vector elements to 0', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final result = vector.pow(0);

          expect(result, isNot(same(vector)));
          expect(result.length, equals(5));
          expect(result, equals([1.0, 1.0, 1.0, 1.0, 1.0]));
          expect(result.dtype, dtype);
        });

        test('should raise vector elements to float power', () {
          final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0],
              dtype: dtype);
          final result = vector.pow(1.2);

          expect(result, isNot(same(vector)));
          expect(result.length, equals(5));
          expect(result, iterableAlmostEqualTo(
              [1.0, 2.297, 3.7371, 5.27803, 6.8986], 1e-3));
          expect(result.dtype, dtype);
        });
      });
    });
