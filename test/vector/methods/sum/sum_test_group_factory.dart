import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void vectorSumTestGroupFactory(DType dtype) =>
    group(dtypeToVectorTestTitle[dtype], () {
      group('sum method', () {
        test('should find vector elements sum', () {
          final vector =
              Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype);

          expect(vector.sum(), equals(15.0));
        });

        test(
            'should find vector elements sum, negative and positive numbers '
            'case', () {
          final vector =
              Vector.fromList([1.0, -20.0, 3.02, 14.0, -5.0], dtype: dtype);

          expect(vector.sum(), closeTo(-6.98, 1e-3));
        });

        test(
            'should find vector elements sum if the vector consists of just '
            'only element', () {
          final vector = Vector.fromList([-100.0], dtype: dtype);

          expect(vector.sum(), equals(-100.0));
        });

        test(
            'should return zero if the vector consists of just '
            'only zero', () {
          final vector = Vector.fromList([0.0], dtype: dtype);

          expect(vector.sum(), equals(0.0));
        });

        test('should return zero if all vector elements are zero', () {
          final vector = Vector.fromList([0, 0, 0, 0, 0, 0], dtype: dtype);

          expect(vector.sum(), equals(0.0));
        });

        test(
            'should find vector elements sum if there are zeroes in the '
            'vector', () {
          final vector = Vector.fromList([0.0, 12345.6789, 0.0], dtype: dtype);

          expect(vector.sum(), closeTo(12345.6789, 1e-3));
        });

        test('should return double.nan if a vector is empty', () {
          final vector = Vector.fromList([], dtype: dtype);

          expect(vector.sum(), isNaN);
        });
      });
    });
